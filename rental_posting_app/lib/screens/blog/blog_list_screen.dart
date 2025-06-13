import 'package:flutter/material.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f9ff),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a8066),
        elevation: 0,
        title: const Text(
          'Danh sách bài viết',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const BlogPostList(),
    );
  }
}

class BlogPost {
  final String imageUrl;
  final String title;
  final String description;

  BlogPost({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

class BlogPostList extends StatelessWidget {
  const BlogPostList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BlogPost> posts = [
      BlogPost(
        imageUrl: 'assets/images/img1.jpg',
        title: 'Chú ý 9 kinh nghiệm tìm thuê nhà trọ bạn nhất định phải lưu ý',
        description:
            'Thuê nhà trọ - phòng trọ là mối quan tâm của rất nhiều sinh viên, người lao động xa quê tìm đến các thành phố để học tập...',
      ),
      BlogPost(
        imageUrl: 'assets/images/img2.jpg',
        title: 'Top 5 mẹo tiết kiệm chi phí khi thuê nhà trọ',
        description:
            'Hướng dẫn bạn cách tiết kiệm chi phí khi thuê nhà trọ mà vẫn đảm bảo chất lượng sống tốt...',
      ),
      BlogPost(
        imageUrl: 'assets/images/img3.jpg',
        title: 'Những điều cần biết trước khi ký hợp đồng thuê trọ',
        description:
            'Tìm hiểu các điều khoản quan trọng trong hợp đồng thuê trọ để tránh rủi ro...',
      ),
      BlogPost(
        imageUrl: 'assets/images/img1.jpg',
        title: 'Làm thế nào để tìm nhà trọ an toàn tại thành phố lớn',
        description:
            'Một số lưu ý giúp bạn tìm nhà trọ an toàn và phù hợp tại các thành phố lớn...',
      ),
      BlogPost(
        imageUrl: 'assets/images/img2.jpg',
        title: 'Kinh nghiệm chọn nhà trọ gần trường đại học',
        description:
            'Hướng dẫn sinh viên cách chọn nhà trọ gần trường để tiết kiệm thời gian di chuyển...',
      ),
      BlogPost(
        imageUrl: 'assets/images/img3.jpg',
        title: 'Cách xử lý khi gặp vấn đề với chủ nhà trọ',
        description:
            'Một số mẹo để giải quyết mâu thuẫn với chủ nhà trọ một cách hiệu quả...',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return BlogPostCard(post: posts[index]);
      },
    );
  }
}

class BlogPostCard extends StatelessWidget {
  final BlogPost post;

  const BlogPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: SizedBox(
                    width: 150,
                    child: Image.asset(
                      post.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          post.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
