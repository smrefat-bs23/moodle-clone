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
/// resource. JSONPlaceholder does not persist writes, so every mutation
/// is followed by a refetch of the list to honestly reflect that.
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

  List<PostEntity> get _currentPosts => switch (state) {
    PostLoaded(:final posts) => posts,
    PostMutating(:final posts) => posts,
    _ => const [],
  };

  /// Fetch all posts (GET)
  Future<void> fetchPosts() async {
    emit(const PostLoading());

    final (posts, error) = await _getPostsUseCase();

    if (posts != null) {
      emit(PostLoaded(posts: posts));
    } else if (error != null) {
      emit(PostError(message: error.message, canRetry: true));
    }
  }

  /// Create a new post (POST), then refetch the list
  Future<void> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    emit(PostMutating(posts: _currentPosts));

    final (_, error) = await _createPostUseCase(
      PostEntity(userId: userId, title: title, body: body),
    );

    if (error != null) {
      emit(PostError(message: error.message, canRetry: true));
      return;
    }
    await fetchPosts();
  }

  /// Fully replace an existing post (PUT), then refetch the list
  Future<void> updatePost(PostEntity post) async {
    emit(PostMutating(posts: _currentPosts));

    final (_, error) = await _updatePostUseCase(post);

    if (error != null) {
      emit(PostError(message: error.message, canRetry: true));
      return;
    }
    await fetchPosts();
  }

  /// Partially update a post's title (PATCH), then refetch the list
  Future<void> patchPostTitle(int id, String title) async {
    emit(PostMutating(posts: _currentPosts));

    final (_, error) = await _patchPostUseCase(id, title: title);

    if (error != null) {
      emit(PostError(message: error.message, canRetry: true));
      return;
    }
    await fetchPosts();
  }

  /// Delete a post (DELETE), then refetch the list
  Future<void> deletePost(int id) async {
    emit(PostMutating(posts: _currentPosts));

    final (_, error) = await _deletePostUseCase(id);

    if (error != null) {
      emit(PostError(message: error.message, canRetry: true));
      return;
    }
    await fetchPosts();
  }
}
