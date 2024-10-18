class Comment {
  int userId;
  String text;
  int? id;
  int? postId;
  String? author;

  Comment({
    required this.userId,
    required this.text,
    this.postId,
    this.id,
    this.author,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      author: json['author'],
      userId: json['user_id'],
      postId: json['post_id'],
      id: json['id'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() => {
        'post_id': postId,
        'text': text,
        'user_id': userId,
        'id': id,
      };
}
