import 'package:arba_test_web/src/bloc/post_cubit.dart';
import 'package:arba_test_web/src/model/post.dart';
import 'package:arba_test_web/src/repositories/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPost extends StatefulWidget {
  final Post? post;
  const NewPost({super.key, this.post});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  final postRepo = PostRepository();
  bool hasError = false;
  bool hasSuccess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasSuccess) {
        Navigator.of(context).pop(true);
      }

      if (hasError) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    hasError = false;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final postState = context.watch<PostCubit>().state;
    final existingPost = widget.post; // This is the post that we are editing

    if (postState.isSuccess) {
      setState(() {
        hasSuccess = true;
      });
    }

    if (existingPost != null && !postState.isSuccess) {
      imageUrlController.text = existingPost.image;
      captionController.text = existingPost.caption;
    }

    return AlertDialog(
      title: Text(existingPost != null ? 'Edit New Post' : 'Add New Post'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(
              labelText: 'Image URL',
            ),
          ),
          TextField(
            controller: captionController,
            decoration: const InputDecoration(
              labelText: 'Caption',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (existingPost != null) {
              context.read<PostCubit>().update(
                    existingPost.id,
                    imageUrlController.text,
                    captionController.text,
                  );
            } else {
              context.read<PostCubit>().add(
                    imageUrlController.text,
                    captionController.text,
                  );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
