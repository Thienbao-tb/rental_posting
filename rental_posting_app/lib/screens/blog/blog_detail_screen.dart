import 'package:flutter/material.dart';

import 'blog_list_screen.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogPost post;

  const BlogDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f9ff),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a8066),
        elevation: 0,
        title: Text(
          post.title.length > 20
              ? '${post.title.substring(0, 20)}...'
              : post.title,
          style: const TextStyle(
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
      body: Container(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(post.description),
              const SizedBox(height: 10),
              const Text(
                "Thuê nhà trọ - phòng trọ là mối quan tâm của rất nhiều sinh viên, "
                "người lao động xa quê tìm đến các thành phố để học tập, làm việc. "
                "Tuy nhiên để tìm thuê nhà trọ - phòng trọ giá rẻ, sạch sẽ như ý muốn "
                "là điều không phải đơn giản. Hiện nay trên các trang mạng facebook, "
                "zalo...thường xuất hiện nhiều chia sẻ về việc bị lừa đảo trong khi"
                " tìm thuê nhà trọ - phòng trọ. Điều này thật đáng lo ngại.",
              ),
              const SizedBox(height: 10),
              Image.asset(
                post.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              const SizedBox(height: 10),
              const Text(
                "1. CÁC CÁCH TÌM THUÊ NHÀ TRỌ NHANH VÀ AN TOÀN NHẤT",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "1.1 Tìm gián tiếp qua mạng",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Internet ngày càng phát triển. Giờ đây bạn chỉ cần gõ mong "
                "muốn tìm nhà trọ vào công cụ tìm kiếm thông minh Google thì "
                "hàng trăm, thậm chí hàng ngàn kết quả hiện ra để bạn chọn lựa. Tuy "
                "đây là cách nhanh nhất nhưng cũng chứa đựng rủi ro cao nhất. Vì vậy "
                "bạn cần phải có kinh nghiệm tìm phòng thuê phòng trọ khi sử dụng "
                "cách này. Lưu ý:Internet ngày càng phát triển. Giờ đây bạn chỉ cần gõ mong "
                "muốn tìm nhà trọ vào công cụ tìm kiếm thông minh Google thì "
                "hàng trăm, thậm chí hàng ngàn kết quả hiện ra để bạn chọn lựa. Tuy "
                "đây là cách nhanh nhất nhưng cũng chứa đựng rủi ro cao nhất. Vì vậy "
                "bạn cần phải có kinh nghiệm tìm phòng thuê phòng trọ khi sử dụng "
                "cách này. Lưu ý:",
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
