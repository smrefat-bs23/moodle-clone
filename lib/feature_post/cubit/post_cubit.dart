import 'package:bloc/bloc.dart';
import 'package:flutter_boilerplate_domain/flutter_boilerplate_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'post_cubit.freezed.dart';

/// State for the posts screen
@freezed
class PostState with _$PostState {
  /// Initial state
  const factory PostState.initial() = PostInitial;

  /// Loading state (initial fetch)
  const factory PostState.loading() = PostLoading;

  /// Loaded state with the current list of posts
  const factory PostState.loaded({required List<PostEntity> posts}) =
      PostLoaded;

  /// A create/update/patch/delete request is in flight.
  ///
  /// Keeps the last known [posts] visible while the mutation completes.
  const factory PostState.mutating({required List<PostEntity> posts}) =
      PostMutating;

  /// Error state
  const factory PostState.error({
    required String message,
    @Default(false) bool canRetry,
  }) = PostError;
}

/// Cubit for managing the posts screen state
///
/// Demonstrates all five CRUD verbs against JSONPlaceholder's `/posts`
/// resource. JSONPlaceholder does not persist writes, so we apply
/// **optimistic local updates** after every successful mutation —
/// otherwise the subsequent refetch would clobber the user's edit /
/// new item / deletion with the original server payload and the UI
/// would look broken.
///
/// Local edits live in [_localEdits] keyed by post id and are merged on
/// top of the server's response on every fetch.
@injectable
class PostCubit extends Cubit<PostState> {
  /// Creates a new [PostCubit] instance
  PostCubit({
    required GetPostsUseCase getPostsUseCase,
    required CreatePostUseCase createPostUseCase,
    required UpdatePostUseCase updatePostUseCase,
    required PatchPostUseCase patchPostUseCase,
    required DeletePostUseCase deletePostUseCase,
  }) : _getPostsUseCase = getPostsUseCase,
       _createPostUseCase = createPostUseCase,
       _updatePostUseCase = updatePostUseCase,
       _patchPostUseCase = patchPostUseCase,
       _deletePostUseCase = deletePostUseCase,
       super(const PostInitial());

  final GetPostsUseCase _getPostsUseCase;
  final CreatePostUseCase _createPostUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final PatchPostUseCase _patchPostUseCase;
  final DeletePostUseCase _deletePostUseCase;

  /// Local overrides applied on top of server payloads, keyed by
  /// post id. Lets the UI keep showing the user's edits even after
  /// a refetch that returns the (non-persisted) server original.
  final Map<int, PostEntity> _localEdits = <int, PostEntity>{};

  /// Ids the user has deleted locally. Filtered out of any fetched list
  /// so a refetch doesn't resurrect them.
  final Set<int> _locallyDeletedIds = <int>{};

  List<PostEntity> get _currentPosts => switch (state) {
    PostLoaded(:final posts) => posts,
    PostMutating(:final posts) => posts,
    _ => const [],
  };

  /// Fetch all posts (GET), then merge [_localEdits] on top so the
  /// user's in-place edits survive the round-trip.
  Future<void> fetchPosts() async {
    emit(const PostLoading());

    final (posts, error) = await _getPostsUseCase();

    if (posts != null) {
      emit(PostLoaded(posts: _mergeEdits(posts)));
    } else if (error != null) {
      emit(PostError(message: error.message, canRetry: true));
    }
  }

  /// Apply [_localEdits] on top of a server-fetched list. Edits take
  /// precedence; locally-deleted ids are filtered out.
  List<PostEntity> _mergeEdits(List<PostEntity> posts) {
    final out = <PostEntity>[];
    for (final post in posts) {
      final id = post.id;
      if (id != null && _locallyDeletedIds.contains(id)) continue;
      final override = id == null ? null : _localEdits[id];
      out.add(override ?? post);
    }
    return out;
  }

  /// Create a new post (POST). The new post is added to the local
  /// list optimistically — JSONPlaceholder will assign id=101, but
  /// every subsequent refetch returns the original 100 posts. To
  /// keep the new post visible across refreshes we store it under a
  /// stable synthetic id based on a monotonic counter and remember
  /// it in [_localEdits].
  Future<void> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    final syntheticId = -(_localEdits.length + 1);
    final optimistic = PostEntity(
      id: syntheticId,
      userId: userId,
      title: title,
      body: body,
    );
    _localEdits[syntheticId] = optimistic;
    emit(PostLoaded(
      posts: [..._currentPosts, optimistic],
    ));

    final (_, error) = await _createPostUseCase(
      PostEntity(userId: userId, title: title, body: body),
    );

    if (error != null) {
      // Roll back the optimistic insert so the UI matches reality.
      _localEdits.remove(syntheticId);
      emit(PostLoaded(posts: _mergeEdits(_currentPosts)));
      emit(PostError(message: error.message, canRetry: true));
    }
  }

  /// Fully replace an existing post (PUT). The new fields are applied
  /// optimistically and remembered via [_localEdits] so subsequent
  /// refetches don't revert them (the demo server doesn't persist).
  Future<void> updatePost(PostEntity post) async {
    final id = post.id;
    if (id == null) {
      emit(const PostError(message: 'Cannot update a post without an id.'));
      return;
    }
    emit(PostMutating(posts: _currentPosts));

    final (_, error) = await _updatePostUseCase(post);

    if (error != null) {
      emit(PostError(message: error.message, canRetry: true));
      return;
    }

    // Remember the new fields so a later refetch can't clobber them.
    _localEdits[id] = post;
    emit(PostLoaded(posts: _mergeEdits(_currentPosts)));
  }

  /// Partially update a post's title (PATCH). The new title is applied
  /// optimistically and remembered via [_localEdits] so a refetch that
  /// returns the (unchanged) server original doesn't revert it.
  Future<void> patchPostTitle(int id, String title) async {
    emit(PostMutating(posts: _currentPosts));

    final (_, error) = await _patchPostUseCase(id, title: title);

    if (error != null) {
      emit(PostError(message: error.message, canRetry: true));
      return;
    }

    // Find the existing post (with any prior local edit applied).
    final existing = _currentPosts.firstWhere(
      (p) => p.id == id,
      orElse: () => PostEntity(
        id: id,
        userId: 0,
        title: title,
        body: '',
      ),
    );
    final patched = existing.copyWith(title: title);
    _localEdits[id] = patched;
    emit(PostLoaded(posts: _mergeEdits(_currentPosts)));
  }

  /// Delete a post (DELETE). The id is recorded in [_locallyDeletedIds]
  /// so a subsequent refetch that returns the original (undeleted) list
  /// doesn't resurrect the row.
  Future<void> deletePost(int id) async {
    emit(PostMutating(posts: _currentPosts));

    final (_, error) = await _deletePostUseCase(id);

    if (error != null) {
      emit(PostError(message: error.message, canRetry: true));
      return;
    }

    _localEdits.remove(id);
    _locallyDeletedIds.add(id);
    emit(PostLoaded(
      posts: _currentPosts.where((p) => p.id != id).toList(growable: false),
    ));
  }
}
