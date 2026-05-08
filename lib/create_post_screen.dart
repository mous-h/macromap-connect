import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'post_model.dart';
import 'post_repository.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  bool _isPosting = false;

  Future<void> _submitPost() async {
    if (_contentController.text.trim().isEmpty) return;

    setState(() => _isPosting = true);
    final user = FirebaseAuth.instance.currentUser;

    final newPost = Post(
      id: '', // Firestore auto-generates this
      uid: user?.uid ?? 'anon',
      email: user?.email ?? 'anonymous',
      content: _contentController.text.trim(),
      likes: 0,
      createdAt: DateTime.now(),
    );

    await PostRepository().createPost(newPost);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'What are you eating?',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isPosting ? null : _submitPost,
                child: _isPosting
                    ? const CircularProgressIndicator()
                    : const Text('Post'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
