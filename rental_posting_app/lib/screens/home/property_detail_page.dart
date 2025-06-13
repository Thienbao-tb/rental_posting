import 'package:flutter/material.dart';

import '../../custom_widgets/button_nav_bar.dart';
import '../../custom_widgets/main_button.dart';

class PostDetailScreen extends StatefulWidget {
  final String image;
  final String category;
  final String title;
  final String address;
  final String price;
  final String area;
  final String level;
  final String updateDate;
  final String expiryDate;
  final String description;

  const PostDetailScreen({
    super.key,
    required this.image,
    required this.category,
    required this.title,
    required this.address,
    required this.price,
    required this.area,
    required this.level,
    required this.updateDate,
    required this.expiryDate,
    required this.description,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  int selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    // TODO: Điều hướng đến các màn tương ứng nếu cần
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          widget.title.length > 20
              ? '${widget.title.substring(0, 20)}...'
              : widget.title,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slide show tự động
                  AutomaticSlideshow(imageUrls: [widget.image]),
                  // Content
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, top: 5, bottom: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 10,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        PropertyInfoRow(
                            label: 'Địa chỉ', value: widget.address),
                        PropertyInfoRow(
                            label: 'Giá cho thuê',
                            value: widget.price,
                            valueColor: Colors.orange),
                        PropertyInfoRow(label: 'Diện tích', value: widget.area),
                        PropertyInfoRow(label: 'Mã tin', value: widget.level),
                        PropertyInfoRow(
                            label: 'Ngày cập nhật', value: widget.updateDate),
                        PropertyInfoRow(
                            label: 'Ngày hết hạn', value: widget.expiryDate),
                        const SizedBox(height: 16),
                        ButtonDemoPage(description: widget.description),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, top: 5, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bản đồ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                            "Địa chỉ: ${widget.address} https://maps.app.goo.gl/L1woVXfZHgRghs2PA"),
                        const SizedBox(height: 10),
                        const Text(
                          "Thông tin liên hệ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Text("Điện thoại: 0382187103"),
                        const Text("Zalo: 0382187103"),
                        const SizedBox(height: 10),
                        const Text(
                          "Phản hồi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          "Mọi thông tin trên website chỉ mang tính chất tham khảo. Nếu bạn có phản hồi với tin đăng này (báo xấu, tin đã cho thuê, không liên lạc được,...), vui lòng thông báo để canthohostel.com có thể xử lý.",
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MainButton(
                                label: "Gửi phản hồi",
                                onPressed: null,
                                color: const Color(0xFF0961F5)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Có thể bạn quan tâm",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        ProductScrollView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class AutomaticSlideshow extends StatefulWidget {
  final List<String> imageUrls;

  const AutomaticSlideshow({super.key, required this.imageUrls});

  @override
  State<AutomaticSlideshow> createState() => _AutomaticSlideshowState();
}

class _AutomaticSlideshowState extends State<AutomaticSlideshow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: widget.imageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.imageUrls[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.imageUrls.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 18),
                      ),
                      onPressed: () {
                        if (_currentPage > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          _pageController.animateToPage(
                            widget.imageUrls.length - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 18),
                      ),
                      onPressed: () {
                        if (_currentPage < widget.imageUrls.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          _pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ButtonDemoPage extends StatefulWidget {
  final String description;

  const ButtonDemoPage({super.key, required this.description});

  @override
  State<ButtonDemoPage> createState() => _ButtonDemoPageState();
}

class _ButtonDemoPageState extends State<ButtonDemoPage> {
  late Widget content;

  @override
  void initState() {
    super.initState();
    content = ExpandableText(text: widget.description);
  }

  void _handleButtonPress(Widget widget) {
    setState(() {
      content = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                ),
                onPressed: () => _handleButtonPress(
                    ExpandableText(text: widget.description)),
                child: const Text("Mô tả"),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
                onPressed: () => _handleButtonPress(
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                        "- Gần trường, chợ, khu vực an ninh\n- Giờ giấc tự do, xe miễn phí\n- Hợp đồng rõ ràng, linh động"),
                  ),
                ),
                child: const Text("Đặc điểm tin"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 3,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(color: Colors.grey[800]);
    final linkStyle =
        const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: defaultStyle);
        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: defaultStyle,
              maxLines: isExpanded ? null : widget.trimLines,
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (isOverflow)
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Text(
                  isExpanded ? 'thu gọn' : 'xem thêm...',
                  style: linkStyle,
                ),
              ),
          ],
        );
      },
    );
  }
}

class PropertyInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const PropertyInfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.label,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.teal : Colors.grey,
          ),
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.teal : Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}

class ProductScrollView extends StatelessWidget {
  const ProductScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProductItem> products = [
      ProductItem(
        imageUrl: "assets/images/img1.jpg",
        price: '3.000.000 VNĐ',
        title: 'Mặt bằng Cao Cấp Full Nội Thất',
        area: '50m²',
        date: 'Cập nhật: 2024-06-07',
        contact: 'Liên hệ: 0382187103',
        location: 'Xuân Thủy, Phường An Bình, Quận Ninh Kiều, Cần Thơ.',
      ),
      ProductItem(
        imageUrl: "assets/images/img2.jpg",
        price: '4.200.000 VNĐ',
        title: 'Mặt bằng Cao Cấp Trung Tâm',
        area: '45m²',
        date: 'Cập nhật: 2024-06-05',
        contact: 'Liên hệ: 0901234567',
        location: 'Nguyễn Văn Cừ, Phường An Khánh, Quận Ninh Kiều, Cần Thơ.',
      ),
      ProductItem(
        imageUrl: 'assets/images/img3.jpg',
        price: '2.800.000 VNĐ',
        title: 'Mặt bằng Cao Cấp Văn Phòng',
        area: '35m²',
        date: 'Cập nhật: 2024-06-01',
        contact: 'Liên hệ: 0387654321',
        location: '30/4, Phường Xuân Khánh, Quận Ninh Kiều, Cần Thơ.',
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: products.map((product) {
          return ProductCard(product: product);
        }).toList(),
      ),
    );
  }
}

class ProductItem {
  final String imageUrl;
  final String price;
  final String title;
  final String area;
  final String date;
  final String contact;
  final String location;

  ProductItem({
    required this.imageUrl,
    required this.price,
    required this.title,
    required this.area,
    required this.date,
    required this.contact,
    required this.location,
  });
}

class ProductCard extends StatelessWidget {
  final ProductItem product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                product.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Không tải được ảnh')),
                  );
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      product.date,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.area,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      product.contact,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.location,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
