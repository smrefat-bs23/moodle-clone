import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_post/cubit/post_cubit.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/flutter_boilerplate_domain.dart';

/// Posts page - demonstrates full CRUD against JSONPlaceholder's
/// `/posts` resource (GET, POST, PUT, PATCH, DELETE).
///
/// JSONPlaceholder is a fake API: writes are accepted but never
/// actually persisted. To keep the demo usable, the cubit applies
/// optimistic local updates after every mutation and remembers them
/// across refetches (see [PostCubit]). Pull-to-refresh still
/// re-hydrates from the server, and any local edits that the server
/// doesn't know about stay visible on top.
class PostsPage extends StatelessWidget {
  /// Creates an instance of [PostsPage]
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getIt<PostCubit>()..fetchPosts(),
      child: const _PostsPageBody(),
    );
  }
}

class _PostsPageBody extends StatelessWidget {
  const _PostsPageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.labelPostsDemo)),
      body: Column(
        children: [
          const _DemoBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context.read<PostCubit>().fetchPosts(),
              child: BlocBuilder<PostCubit, PostState>(
                builder: (context, state) => state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (posts) => _PostList(posts: posts),
                  mutating: (posts) => Stack(
                    children: [
                      _PostList(posts: posts),
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(),
                      ),
                    ],
                  ),
                  error: (message, canRetry) =>
                      _ErrorView(message: message, canRetry: canRetry),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(context),
        tooltip: AppStrings.labelCreatePost,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DemoBanner extends StatelessWidget {
  const _DemoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.secondaryContainer,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Text(
        AppStrings.bannerDemo,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList({required this.posts});

  final List<PostEntity> posts;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (posts.isEmpty) {
      return const Center(child: Text(AppStrings.emptyNoPosts));
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Dismissible(
          key: ValueKey(post.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: colorScheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Icon(Icons.delete, color: colorScheme.onError),
          ),
          onDismissed: (_) => context.read<PostCubit>().deletePost(post.id!),
          child: ListTile(
            title: Text(
              post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              post.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _showEditDialog(context, post: post),
            trailing: IconButton(
              icon: const Icon(Icons.short_text),
              tooltip: 'Quick patch title',
              onPressed: () => _showPatchTitleDialog(context, post: post),
            ),
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.canRetry});

  final String message;
  final bool canRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSize.iconXXl,
              color: colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center),
            if (canRetry) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: () => context.read<PostCubit>().fetchPosts(),
                icon: const Icon(Icons.refresh),
                label: const Text(AppStrings.labelTryAgain),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shows a dialog to create a new post (no [post]) or fully replace an
/// existing one via PUT ([post] provided).
Future<void> _showEditDialog(BuildContext context, {PostEntity? post}) async {
  final cubit = context.read<PostCubit>();
  final titleController = TextEditingController(text: post?.title ?? '');
  final bodyController = TextEditingController(text: post?.body ?? '');

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(post == null ? AppStrings.labelCreatePost : AppStrings.labelEditPost),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: AppStrings.labelTitle),
          ),
          TextField(
            controller: bodyController,
            decoration: const InputDecoration(labelText: AppStrings.labelBody),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(AppStrings.labelCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(post == null ? AppStrings.labelCreate : AppStrings.labelSave),
        ),
      ],
    ),
  );

  if (result != true) return;

  final title = titleController.text.trim();
  final body = bodyController.text.trim();
  if (title.isEmpty || body.isEmpty) return;

  if (post == null) {
    await cubit.createPost(userId: 1, title: title, body: body);
  } else {
    await cubit.updatePost(post.copyWith(title: title, body: body));
  }
}

/// Shows a dialog to partially update just a post's title via PATCH.
Future<void> _showPatchTitleDialog(
  BuildContext context, {
  required PostEntity post,
}) async {
  final cubit = context.read<PostCubit>();
  final titleController = TextEditingController(text: post.title);

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(AppStrings.labelPatchTitle),
      content: TextField(
        controller: titleController,
        decoration: const InputDecoration(labelText: AppStrings.labelTitle),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(AppStrings.labelCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(AppStrings.labelPatch),
        ),
      ],
    ),
  );

  if (result != true) return;

  final title = titleController.text.trim();
  if (title.isEmpty || post.id == null) return;

  await cubit.patchPostTitle(post.id!, title);
}
