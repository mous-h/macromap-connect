import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'feed_provider.dart';
import 'create_post_screen.dart';
import 'comments_sheet.dart';
import 'post_repository.dart'; // Ensure this is imported
import 'package:intl/intl.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Feed')),
      body: Column(
        children: [
          // ... (Keep the Announcement Banner StreamBuilder here) ...
          Expanded(
            child: Consumer<FeedProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading)
                  return const Center(child: CircularProgressIndicator());
                if (provider.posts.isEmpty)
                  return const Center(child: Text('No posts yet!'));

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.posts.length,
                  itemBuilder: (context, index) {
                    final post = provider.posts[index];
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(post.email.split('@')[0]),
                            subtitle: Text(post.content),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Fixed Like Button
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.favorite_border,
                                  size: 20,
                                ),
                                label: Text('${post.likes}'),
                                onPressed: () async {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    // Call the repository to handle the logic
                                    await PostRepository().toggleLike(
                                      post.id,
                                      user.uid,
                                    );
                                  }
                                },
                              ),
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.chat_bubble_outline,
                                  size: 20,
                                ),
                                label: const Text("Comment"),
                                onPressed: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      CommentsSheet(postId: post.id),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // ... (Keep the FloatingActionButton here) ...
    );
  }
}
