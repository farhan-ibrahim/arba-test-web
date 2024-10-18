import 'package:arba_test_web/src/bloc/post_cubit.dart';
import 'package:arba_test_web/src/repositories/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewComment extends StatefulWidget {
  const NewComment({super.key});

  @override
  State<NewComment> createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  TextEditingController textController = TextEditingController();
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

    if (postState.isSuccess) {
      setState(() {
        hasSuccess = true;
      });
    }

    return AlertDialog(
      title: const Text('Add New Comment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Comment',
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
            context.read<PostCubit>().addComment(textController.text);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
