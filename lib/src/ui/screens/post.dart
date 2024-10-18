import 'package:arba_test_web/src/bloc/auth_cubit.dart';
import 'package:arba_test_web/src/bloc/post_cubit.dart';
import 'package:arba_test_web/src/ui/dialogs/new_comment.dart';
import 'package:arba_test_web/src/ui/dialogs/new_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({
    super.key,
  });

  static const routeName = '/post_detail';

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // final post = ModalRoute.of(context)!.settings.arguments as Post;
    final post = context.watch<PostCubit>().state.post;
    final authState = context.watch<AuthCubit>().state;

    if (post == null) {
      return const Scaffold(
        body: Center(
          child: Text("Error loading post"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
      ),
      body: Center(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(post.caption),
                  Image(
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.5 / 0.75,
                    image: NetworkImage(post.image),
                  ),
                  const SizedBox(height: 10),
                  const Text('Comments'),
                  if (post.comments != null)
                    ...post.comments!.map(
                      (c) => ListTile(
                        leading: const Icon(Icons.comment),
                        title: Text(c.text),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ...authState.isLoggedIn && post.author == authState.user?.name
              ? [
                  FloatingActionButton(
                    heroTag: 'edit',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NewPost(post: post);
                          }).then((_) {
                        // This is a hack to refresh the page
                        setState(() {});
                      });
                    },
                    child: const Icon(Icons.edit),
                  )
                ]
              : [],
          const SizedBox(height: 10),
          ...authState.isLoggedIn
              ? [
                  FloatingActionButton(
                    heroTag: 'comment',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const NewComment();
                          }).then((_) {
                        // This is a hack to refresh the page
                        setState(() {});
                        context.read<PostCubit>().reset();
                      });
                    },
                    child: const Icon(Icons.comment),
                  )
                ]
              : [],
          const SizedBox(height: 10),
          ...authState.isLoggedIn && post.author == authState.user?.name
              ? [
                  FloatingActionButton(
                    heroTag: 'delete',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Post'),
                              content: const Text(
                                  'Are you sure you want to delete this post?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<PostCubit>().delete(post.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          }).then((_) {
                        // This is a hack to refresh the page
                        Navigator.of(context).pop();
                        // setState(() {});
                      });
                    },
                    child: const Icon(Icons.delete),
                  )
                ]
              : [],
        ],
      ),
    );
  }
}
