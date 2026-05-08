import 'package:flutter/material.dart';
import 'post_repository.dart';
import 'post_model.dart';

class FeedProvider extends ChangeNotifier {
  final PostRepository _repository = PostRepository();
  List<Post> _posts = [];
  bool _isLoading = true;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  FeedProvider() {
    _listenToFeed();
  }

  void _listenToFeed() {
    _repository.streamFeed().listen((newPosts) {
      _posts = newPosts;
      _isLoading = false;
      notifyListeners();
    });
  }
}
