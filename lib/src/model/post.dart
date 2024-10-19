import 'package:arba_test_web/src/model/comment.dart';
import 'package:arba_test_web/src/model/user.dart';

class Post {
  final String id;
  final String image;
  final String caption;
  String? userId;
  String? author;
  User? user;
  List<Comment>? comments;

  Post({
    required this.id,
    required this.image,
    required this.caption,
    this.userId,
    this.author,
    this.user,
    this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['user_id'],
      author: json['author'],
      id: json['id'],
      image: json['image'],
      caption: json['caption'],
      comments: json['comments']
          ?.map<Comment>((dynamic item) => Comment.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'caption': caption,
      };

  addUser(Map<String, dynamic> json) {
    user = User.fromJson(json);
  }

  addComments(List<dynamic> json) {
    comments = json.map((dynamic item) => Comment.fromJson(item)).toList();
  }
}
