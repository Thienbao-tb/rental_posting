import 'package:flutter/material.dart';

import 'property_detail_page.dart';

class CategoryPage extends StatelessWidget {
  final String title;
  final List<Map<String, String>> properties;

  const CategoryPage({
    super.key,
    required this.title,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        '$title (${properties.length} tin)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.blue),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mở trang bộ lọc')),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Danh sách tin đăng
            Expanded(
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                cacheExtent: 1000, // Tăng bộ nhớ đệm để giảm giật
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final property = properties[index];
                  return _buildPropertyItem(
                    context: context,
                    image: property['image'] ?? 'assets/images/placeholder.jpg',
                    title: property['title'] ?? 'Không có tiêu đề',
                    price: property['price'] ?? 'N/A',
                    area: property['area'] ?? 'N/A',
                    updateDate: property['updateDate'] ?? 'N/A',
                    address: property['address'] ?? 'N/A',
                    category: property['category'] ?? 'N/A',
                    level: property['level'] ?? 'N/A',
                    expiryDate: property['expiryDate'] ?? 'N/A',
                    description: property['description'] ?? 'Không có mô tả',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyItem({
    required BuildContext context,
    required String image,
    required String title,
    required String price,
    required String area,
    required String updateDate,
    required String address,
    required String category,
    required String level,
    required String expiryDate,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              image: image,
              category: category,
              title: title,
              address: address,
              price: price,
              area: area,
              level: level,
              updateDate: updateDate,
              expiryDate: expiryDate,
              description: description,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  image,
                  width: 120, // Sửa kích thước hợp lý
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Thông tin
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$price | $area',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      updateDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(
                              image: image,
                              category: category,
                              title: title,
                              address: address,
                              price: price,
                              area: area,
                              level: level,
                              updateDate: updateDate,
                              expiryDate: expiryDate,
                              description: description,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Xem chi tiết',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
