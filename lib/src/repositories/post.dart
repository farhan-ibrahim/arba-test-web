import 'dart:convert';

import 'package:arba_test_web/src/model/comment.dart';
import 'package:arba_test_web/src/model/post.dart';
import 'package:arba_test_web/src/repositories/api.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  final client = API();

  Future<PostResponse> fetchPosts({
    int? page,
    int? limit,
  }) async {
    // final params =
    //     (page != null && limit != null) ? "?_page=$page&_limit=$limit" : "";

    final response = await client.get("posts/all");
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["data"];
      final posts = data.map((dynamic item) => Post.fromJson(item)).toList();
      return PostResponse(data: posts);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> fetchPostById(int id) async {
    final response = await http.get(Uri.parse('$address/posts/$id'));

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Comment>> fetchComments(int postId) async {
    final response = await http.get(
      Uri.parse('$address/posts/$postId/comments'),
    );

    if (response.statusCode == 200) {
      List<dynamic> commentsBody = jsonDecode(response.body);
      return commentsBody.map((item) => Comment.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<Post> createPost(String imageUrl, String caption, String token) async {
    final post = <String, dynamic>{
      "image": imageUrl,
      "caption": caption,
    };

    final response = await client.post("post/create", post, token);
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<Post> updatePost(Post post, String token) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Content-type": "application/json",
      "Authorization": token
    };

    final url = Uri.parse('$address/post/update/${post.id}');
    print("Make request from $url");

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(post.toJson()),
    );

    print("Response status: ${response.statusCode}");
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<bool> deletePost(int id, String token) async {
    // Delete post in API
    final url = Uri.parse('$address/post/delete/$id');
    print("Make request from $url");

    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Content-type": "application/json",
      "Authorization": token
    };
    final response = await http.delete(
      url,
      headers: headers,
    );

    print("Response status: ${response.statusCode}");
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<Comment> addComment(int postId, String text, String token) async {
    // Add comment in API
    final comment = <String, dynamic>{
      "post_id": postId,
      "text": text,
    };

    final response = await client.post("comment/create", comment, token);
    if (response.statusCode == 200) {
      return Comment.fromJson(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Failed to add comment');
    }
  }
}

class PostResponse {
  final List<Post> data;

  PostResponse({
    required this.data,
  });
}
