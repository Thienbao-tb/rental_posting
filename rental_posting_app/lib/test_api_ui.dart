import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/providers/highlight_post_provider.dart';

import '../models/post_model.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final highlightPostProvider =
        Provider.of<HighlightPostProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !highlightPostProvider.isLoading &&
          highlightPostProvider.hasMore) {
        highlightPostProvider.fetchMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildPostItem(Post post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        title: Text(post.ten ?? ""),
        subtitle: Text(post.city?.ten ?? ""),
        trailing: Text('${post.gia ?? 0} đ'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HighlightPostProvider>(
      builder: (context, postProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Danh sách bài đăng')),
          body: RefreshIndicator(
            onRefresh: () async {
              await postProvider.fetchInitialPosts();
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: postProvider.posts.length + 1,
              itemBuilder: (context, index) {
                if (index < postProvider.posts.length) {
                  return _buildPostItem(postProvider.posts[index]);
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: postProvider.hasMore
                          ? const CircularProgressIndicator()
                          : const Text('Không còn bài viết nào.'),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
