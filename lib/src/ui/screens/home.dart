import 'package:arba_test_web/src/bloc/auth_cubit.dart';
import 'package:arba_test_web/src/bloc/post_cubit.dart';
import 'package:arba_test_web/src/repositories/post.dart';
import 'package:arba_test_web/src/ui/dialogs/new_post.dart';
import 'package:arba_test_web/src/ui/screens/login.dart';
import 'package:arba_test_web/src/ui/screens/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final postRepo = PostRepository();
  late Future<PostResponse> _posts;

  @override
  initState() {
    super.initState();
    _posts = postRepo.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest Posts'),
        leading: authState.isLoggedIn
            ? Center(child: Text(authState.user?.name ?? 'User'))
            : null,
        actions: [
          IconButton(
            icon: authState.isLoggedIn
                ? const Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 5.0),
                      Text("Logout"),
                    ],
                  )
                : const Icon(Icons.login),
            onPressed: () {
              if (authState.isLoggedIn) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AuthCubit>().logout();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    });
              } else {
                Navigator.restorablePushNamed(context, LoginScreen.routeName);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<PostResponse>(
        future: _posts,
        initialData: PostResponse(data: []),
        builder: (BuildContext context, AsyncSnapshot<PostResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return GridView.builder(
            itemCount: snapshot.data!.data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final post = snapshot.data!.data[index];
              return GestureDetector(
                onTap: () {
                  context.read<PostCubit>().select(post);
                  Navigator.pushNamed(
                    context,
                    PostDetailScreen.routeName,
                    arguments: post,
                  ).then((_) {
                    // This is a hack to refresh the page
                    setState(() {});
                    context.read<PostCubit>().getAll();
                  });
                },
                child: GridTile(
                  header: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.5),
                    child: Row(
                      children: [
                        Text(post.author?.substring(0, 5) ?? 'User'),
                        Expanded(child: Container()),
                        const Icon(Icons.comment),
                        const SizedBox(width: 5.0),
                        Text(post.comments?.length.toString() ?? '0'),
                      ],
                    ),
                  ),
                  footer: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Text(post.caption),
                    ),
                  ),
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(post.image),
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Text('Image not found'),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: authState.isLoggedIn
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const NewPost();
                    }).then((_) {
                  // This is a hack to refresh the page
                  setState(() {});
                });
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
