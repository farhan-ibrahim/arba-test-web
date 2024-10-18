import 'package:arba_test_web/src/bloc/auth_cubit.dart';
import 'package:arba_test_web/src/model/post.dart';
import 'package:arba_test_web/src/repositories/post.dart';
import 'package:bloc/bloc.dart';

class PostState {
  final bool isSuccess;
  final Post? post;
  final String? error;

  const PostState({
    this.isSuccess = false,
    this.post,
    this.error,
  });

  PostState.copyWith({
    bool? isSuccess,
    this.post,
    this.error,
  }) : isSuccess = isSuccess ?? false;
}

class PostCubit extends Cubit<PostState> {
  final AuthCubit authCubit;

  PostCubit(this.authCubit) : super(const PostState());

  void add(String imageUrl, String caption) async {
    try {
      final currentUser = authCubit.state.user;
      if (currentUser == null) {
        emit(PostState.copyWith(error: 'Unauthorized'));
        return;
      }
      final post = await PostRepository().createPost(
        imageUrl,
        caption,
        currentUser.email,
      );
      emit(PostState.copyWith(isSuccess: true, post: post));
    } catch (e) {
      emit(PostState.copyWith(error: "An error occurred: ${e.toString()}"));
    }
  }

  void update(int postId, String imageUrl, String caption) async {
    try {
      final currentUser = authCubit.state.user;
      if (currentUser == null) {
        emit(PostState.copyWith(error: 'Unauthorized'));
        return;
      }
      final args = Post(id: postId, image: imageUrl, caption: caption);
      final updatedPost =
          await PostRepository().updatePost(args, currentUser.email);
      emit(PostState.copyWith(isSuccess: true, post: updatedPost));
    } catch (e) {
      emit(PostState.copyWith(error: "An error occurred: ${e.toString()}"));
    }
  }

  void delete(int postId) async {
    try {
      final currentUser = authCubit.state.user;
      if (currentUser == null) {
        emit(PostState.copyWith(error: 'Unauthorized'));
        return;
      }
      await PostRepository().deletePost(postId, currentUser.email);
      emit(PostState.copyWith(isSuccess: true));
    } catch (e) {
      emit(PostState.copyWith(error: "An error occurred: ${e.toString()}"));
    }
  }

  // Select a post to view
  void select(Post post) {
    emit(PostState(post: post));
  }

  // Clear the selected post
  void clear() {
    emit(const PostState());
  }

  void reset() {
    emit(PostState.copyWith(isSuccess: false, error: null));
  }

  void addComment(String text) async {
    try {
      final currentUser = authCubit.state.user;
      if (currentUser == null) {
        emit(PostState.copyWith(error: 'Unauthorized'));
        return;
      }
      final post = state.post;
      if (post == null) {
        emit(PostState.copyWith(error: 'Post not found'));
        return;
      }

      final newComment =
          await PostRepository().addComment(post.id, text, currentUser.email);
      final updatedPost = Post(
        id: post.id,
        image: post.image,
        caption: post.caption,
        comments: List.from(post.comments ?? [])..add(newComment),
      );
      emit(PostState.copyWith(isSuccess: true, post: updatedPost));
    } catch (e) {
      emit(PostState.copyWith(error: "An error occurred: ${e.toString()}"));
    }
  }
}
