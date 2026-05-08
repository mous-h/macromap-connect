import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_model.dart';

class PostRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Real-time stream of posts for the feed
  Stream<List<Post>> streamFeed() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Post.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  // Create a new post to the feed
  Future<void> createPost(Post post) async {
    final data = post.toMap();
    data['isHidden'] = false;
    await _db.collection('posts').add(data);
  }

  // FIXED: The toggleLike method now includes necessary variable definitions
  Future<void> toggleLike(String postId, String userId) async {
    // 1. Define the reference to the post document
    final postRef = _db.collection('posts').doc(postId);

    // 2. Define the reference to the specific user's like in the subcollection
    final likeRef = postRef.collection('likes').doc(userId);

    // 3. Get the document to see if it exists
    final doc = await likeRef.get();

    if (doc.exists) {
      // If the user already liked it, remove the like (Unlike)
      await likeRef.delete();
      await postRef.update({'likes': FieldValue.increment(-1)});
    } else {
      // If the user hasn't liked it, add the like (Like)
      await likeRef.set({
        'uid': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await postRef.update({'likes': FieldValue.increment(1)});
    }
  }
}
