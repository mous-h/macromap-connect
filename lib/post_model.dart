class Post {
  final String id;
  final String uid;
  final String email;
  final String content;
  final int likes;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.uid,
    required this.email,
    required this.content,
    required this.likes,
    required this.createdAt,
  });

  factory Post.fromMap(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      content: data['content'] ?? '',
      likes: data['likes'] ?? 0,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'content': content,
      'likes': likes,
      'createdAt': createdAt,
    };
  }
}
