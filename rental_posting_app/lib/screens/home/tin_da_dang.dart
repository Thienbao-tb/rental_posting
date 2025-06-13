import 'package:flutter/material.dart';

class Post {
  final String id;
  final String title;
  final String price;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String imageUrl;

  Post({
    required this.id,
    required this.title,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.imageUrl,
  });
}

class TinDaDang extends StatelessWidget {
  const TinDaDang({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Post> posts = [
      Post(
        id: 'POST001',
        title: 'Nhà cho thuê full nội thất',
        price: '12.000.000đ',
        startDate: DateTime(2025, 3, 21),
        endDate: DateTime(2025, 4, 21),
        status: 'Còn hạn',
        imageUrl: 'assets/images/img1.jpg',
      ),
      Post(
        id: 'POST002',
        title: 'Nhà trọ Tuấn Anh gần công',
        price: '1.200.000đ',
        startDate: DateTime(2025, 4, 18),
        endDate: DateTime(2025, 10, 18),
        status: 'Còn hạn',
        imageUrl: 'assets/images/img1.jpg',
      ),
      Post(
        id: 'POST003',
        title: 'Mặt bằng gần DH Cần Thơ',
        price: '1.000.000đ',
        startDate: DateTime(2025, 3, 21),
        endDate: DateTime(2025, 8, 21),
        status: 'Còn hạn',
        imageUrl: 'assets/images/img1.jpg',
      ),
      Post(
        id: 'POST004',
        title: 'Nhà trọ 30 phòng gần',
        price: '900.000đ',
        startDate: DateTime(2025, 2, 5),
        endDate: DateTime(2025, 12, 5),
        status: 'Còn hạn',
        imageUrl: 'assets/images/img1.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a8066),
        elevation: 0,
        title: const Text(
          'Danh sách tin đã đăng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
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
        color: Colors.blue[50],
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.asset(
                      post.imageUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Thuê trọ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Giá: ${post.price}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ngày bắt đầu: ${post.startDate.day}/${post.startDate.month}/${post.startDate.year}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Ngày kết thúc: ${post.endDate.day}/${post.endDate.month}/${post.endDate.year}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => Thanhtoan(),
                              //   ),
                              // );
                            },
                            child: Text(
                              'Trạng thái: ${post.status}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Text(
                            'Ngày tạo: ${post.startDate.year}-${post.startDate.month.toString().padLeft(2, '0')}-${post.startDate.day.toString().padLeft(2, '0')} 21:32:46',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
