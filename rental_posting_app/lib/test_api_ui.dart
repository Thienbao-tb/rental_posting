import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/providers/post_provider.dart';

class TestApiUi extends StatefulWidget {
  const TestApiUi({super.key});

  @override
  State<TestApiUi> createState() => _TestApiUiState();
}

class _TestApiUiState extends State<TestApiUi> {
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPosts();
    });
  }

  void _fetchPosts() {
    context.read<PostProvider>().getAllPost(page: currentPage);
  }

  void _nextPage() {
    setState(() {
      currentPage++;
    });
    _fetchPosts();
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      _fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final postState = context.watch<PostProvider>();
    final posts = postState.posts;

    return Scaffold(
      appBar: AppBar(title: const Text("Test API")),
      body: Column(
        children: [
          Expanded(
            child: postState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return ListTile(
                        title: Text(post.ten),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: const Text("Trang trước"),
                ),
                const SizedBox(width: 16),
                Text("Trang $currentPage"),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text("Trang sau"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
