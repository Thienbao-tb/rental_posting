import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/models/post_model.dart';
import 'package:rental_posting_app/providers/care_about_provider.dart';
import 'package:rental_posting_app/providers/user_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/api_config.dart';
import '../../config/format_function.dart';
import '../../custom_widgets/main_button.dart';
import '../../providers/detail_image_provider.dart';
import 'home_page.dart';

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
  final int idPhong;
  final int star;
  final String khuVuc;
  final double latitude;
  final double longitude;

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
    required this.idPhong,
    required this.star,
    required this.khuVuc,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late LatLng location;
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      // Gọi API
      final provider = Provider.of<DetailImageProvider>(context, listen: false);
      provider.fetchDetailImage(id: widget.idPhong);

      final userInfo = Provider.of<UserInfoProvider>(context, listen: false);
      userInfo.fetchUserInfo(postId: widget.idPhong);

      final similarPost = Provider.of<SimilarProvider>(context, listen: false);
      similarPost.fetchSimilar(idPost: widget.idPhong);
    });
  }

// Hàm mở URL trong trình duyệt mặc định
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // Hàm thực hiện cuộc gọi điện thoại
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }

  double _currentZoom = 13.0;
  final MapController _mapController = MapController();
  void _zoomIn() {
    setState(() {
      _currentZoom++;
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom--;
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailImageProvider = Provider.of<DetailImageProvider>(context);
    final detailImages = detailImageProvider.detailImages;

    final userInfoProvider = Provider.of<UserInfoProvider>(context);
    final userInfo = userInfoProvider.user;

    final similarProvider = Provider.of<SimilarProvider>(context);
    final similarPosts = similarProvider.similarPosts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomNavScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
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
                  detailImages.isNotEmpty
                      ? AutomaticSlideshow(
                          imageUrls: detailImages
                              .map((e) =>
                                  FormatFunction.buildAvatarUrl(e.duongdan))
                              .toList(),
                        )
                      : Image.network(
                          widget.image,
                        ),
                  // Content
                  Container(
                    padding:
                        const EdgeInsets.only(top: 16, right: 16, left: 16),
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
                            value: FormatFunction.formatPrice(widget.price),
                            valueColor: Colors.orange),
                        PropertyInfoRow(
                            label: 'Diện tích',
                            value: '${widget.area} m\u00B2'),
                        PropertyInfoRow(label: 'Mã tin', value: widget.level),
                        PropertyInfoRow(
                            label: 'Ngày cập nhật', value: widget.updateDate),
                        PropertyInfoRow(
                            label: 'Ngày hết hạn', value: widget.expiryDate),
                        const SizedBox(height: 16),
                        ButtonDemoPage(
                          description: HtmlWidget(
                            widget.description,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          maTin: widget.level,
                          loaiTinRao: widget.category,
                          doiTuong: 'Tất cả',
                          goiTin: FormatFunction.formatPostType(widget.star),
                          khuVuc: widget.khuVuc,
                        ),
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
                        SizedBox(
                          height: 250,
                          child: Stack(
                            children: [
                              FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  center:
                                      LatLng(widget.latitude, widget.longitude),
                                  zoom: _currentZoom,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                    subdomains: const ['a', 'b', 'c'],
                                    userAgentPackageName:
                                        'com.example.rental_posting_app',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(
                                            widget.latitude, widget.longitude),
                                        width: 40,
                                        height: 40,
                                        child: const Icon(Icons.location_pin,
                                            color: Colors.red, size: 40),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Nút zoom
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Column(
                                  children: [
                                    FloatingActionButton(
                                      heroTag: 'zoomIn',
                                      mini: true,
                                      onPressed: _zoomIn,
                                      child: const Icon(Icons.add),
                                    ),
                                    const SizedBox(height: 8),
                                    FloatingActionButton(
                                      heroTag: 'zoomOut',
                                      mini: true,
                                      onPressed: _zoomOut,
                                      child: const Icon(Icons.remove),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Thông tin liên hệ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    (userInfo?.anhdaidien?.isNotEmpty ?? false)
                                        ? NetworkImage(
                                            FormatFunction.buildAvatarUrl(
                                                userInfo!.anhdaidien!))
                                        : null,
                                backgroundColor: Colors.grey,
                                child: (userInfo?.anhdaidien?.isEmpty ?? true)
                                    ? const Icon(Icons.person,
                                        size: 24, color: Colors.white)
                                    : null,
                              ),

                              const SizedBox(height: 16),

                              // Name
                              userInfoProvider.isLoading
                                  ? const CircularProgressIndicator()
                                  : (userInfo == null
                                      ? const Text("Không có dữ liệu")
                                      : Text(
                                          userInfo.ten,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),

                              const SizedBox(height: 20),

                              // Phone Call Button
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      _makePhoneCall(userInfo!.sodienthoai),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00C851),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      userInfoProvider.isLoading
                                          ? const CircularProgressIndicator()
                                          : (userInfo == null
                                              ? const Text("Không có dữ liệu")
                                              : Text(userInfo.sodienthoai,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  )))
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Zalo Button
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () => _launchInBrowser(Uri.parse(
                                      'https://zalo.me/${userInfo?.sodienthoai}')),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black87,
                                    side: const BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Nhắn Zalo',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                onPressed: () => _showFeedbackDialog(context),
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
                        ProductScrollView(
                          similarPosts: similarPosts,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                        image: NetworkImage(widget.imageUrls[index]),
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
  final HtmlWidget description;
  final String maTin;
  final String loaiTinRao;
  final String doiTuong;
  final Widget goiTin;
  final String khuVuc;

  const ButtonDemoPage(
      {super.key,
      required this.description,
      required this.maTin,
      required this.loaiTinRao,
      required this.doiTuong,
      required this.goiTin,
      required this.khuVuc});

  @override
  State<ButtonDemoPage> createState() => _ButtonDemoPageState();
}

class _ButtonDemoPageState extends State<ButtonDemoPage> {
  late Widget content;

  @override
  void initState() {
    super.initState();
    content = widget.description;
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
                onPressed: () => _handleButtonPress(widget.description),
                child: const Text("Mô tả"),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleButtonPress(Column(
                  children: [
                    PropertyInfoRow(label: 'Mã tin', value: widget.maTin),
                    PropertyInfoRow(label: 'Khu vực', value: widget.khuVuc),
                    PropertyInfoRow(
                        label: 'Loại tin rao:', value: widget.loaiTinRao),
                    PropertyInfoRow(label: 'Đối tượng', value: widget.doiTuong),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text(
                            'Gói tin:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Expanded(child: widget.goiTin),
                      ],
                    ),
                  ],
                )),
                child: const Text("Đặc điểm tin"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ExpandableHtmlWidget(
          htmlWidget: content,
        ),
      ],
    );
  }
}

class ExpandableHtmlWidget extends StatefulWidget {
  final Widget htmlWidget;
  final double collapsedHeight;

  const ExpandableHtmlWidget({
    super.key,
    required this.htmlWidget,
    this.collapsedHeight = 130.0,
  });

  @override
  State<ExpandableHtmlWidget> createState() => _ExpandableHtmlWidgetState();
}

class _ExpandableHtmlWidgetState extends State<ExpandableHtmlWidget>
    with TickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? widget.htmlWidget
              : ClipRect(
                  child: SizedBox(
                    height: widget.collapsedHeight,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: widget.htmlWidget,
                    ),
                  ),
                ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent, // Hoặc thử Colors.blue.withOpacity(0.1)
              ],
            ),
          ),
          child: GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.blue,
                  size: 50,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class PropertyInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const PropertyInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
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
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

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
  final List<Post> similarPosts;
  const ProductScrollView({super.key, required this.similarPosts});

  @override
  Widget build(BuildContext context) {
    final List<ProductItem> products = similarPosts.map((post) {
      return ProductItem(
        image: (post.anhdaidien != null && post.anhdaidien!.isNotEmpty)
            ? FormatFunction.buildAvatarUrl(post.anhdaidien!)
            : "${ApiConfig.baseUrl}/images/news-1.jpg",
        title: post.ten ?? '',
        address: post.city!.ten,
        price: '${post.gia.toString()}',
        discountedPrice: "",
        updateDate:
            'Cập nhật: ${FormatFunction.formatDate(post.updated_at ?? '')}',
        category: post.category.ten,
        area: '${post.khuvuc}m²',
        level: post.id.toString(),
        expiryDate: post.thoigian_ketthuc.toString(),
        description: post.mota ?? '',
        star: post.dichvu_hot,
        chitietdiachi: post.chitietdiachi ?? "",
        idPhong: post.id,
        khuVuc: "${post.wards?.ten}, ${post.district?.ten}",
        latitude: FormatFunction.parseCoordinates(post.map ?? '').latitude,
        longitude: FormatFunction.parseCoordinates(post.map ?? '').longitude,
      );
    }).toList();
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
  final String image;
  final String title;
  final String address;
  final String price;
  final String discountedPrice;
  final String updateDate;
  final String category;
  final String area;
  final String level;
  final String expiryDate;
  final String description;
  final int star;
  final String chitietdiachi;
  final int idPhong;
  final String khuVuc;
  final double latitude;
  final double longitude;

  ProductItem(
      {required this.image,
      required this.title,
      required this.address,
      required this.price,
      required this.discountedPrice,
      required this.updateDate,
      required this.category,
      required this.area,
      required this.level,
      required this.expiryDate,
      required this.description,
      required this.star,
      required this.chitietdiachi,
      required this.idPhong,
      required this.khuVuc,
      required this.latitude,
      required this.longitude});
}

class ProductCard extends StatelessWidget {
  final ProductItem product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              image: product.image,
              category: product.category,
              title: product.title,
              address: product.chitietdiachi,
              price: product.price,
              area: product.area,
              level: product.level,
              updateDate: product.updateDate,
              expiryDate: product.expiryDate,
              description: product.description,
              idPhong: product.idPhong,
              star: product.star,
              khuVuc: product.khuVuc,
              latitude: product.latitude,
              longitude: product.longitude,
            ),
          ),
        );
      },
      child: Container(
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
                Image.network(
                  product.image,
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
                        FormatFunction.formatPrice(
                            int.parse(product.price).toString()),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        product.updateDate,
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
                      const Text('Diện tích: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          )),
                      Text(product.area,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Khu vực: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          )),
                      Text(product.khuVuc,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// void _showFeedbackDialog(BuildContext context) {
//   final TextEditingController _controller = TextEditingController();
//
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text("Gửi phản hồi"),
//       content: TextField(
//         controller: _controller,
//         maxLines: 5,
//         decoration: const InputDecoration(
//           hintText: "Nhập nội dung phản hồi...",
//           border: OutlineInputBorder(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context), // Đóng dialog
//           child: const Text("Hủy"),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             final feedback = _controller.text;
//             Navigator.pop(context); // Đóng dialog
//             print("Phản hồi: $feedback");
//             // TODO: Gửi phản hồi lên server tại đây
//           },
//           child: const Text("Gửi"),
//         ),
//       ],
//     ),
//   );
// }
void _showFeedbackDialog(BuildContext context) {
  final TextEditingController _controller = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false, // Không cho phép đóng khi tap ngoài
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.feedback_outlined,
                    color: Colors.blue.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gửi phản hồi",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Chia sẻ ý kiến để chúng tôi cải thiện",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Text field với design đẹp
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 6,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: "Nhập nội dung phản hồi của bạn...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Buttons với design đẹp
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Hủy",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        final feedback = _controller.text.trim();
                        if (feedback.isEmpty) {
                          // Hiển thị thông báo nếu chưa nhập nội dung
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Vui lòng nhập nội dung phản hồi'),
                              backgroundColor: Colors.orange.shade600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                          return;
                        }

                        Navigator.pop(context);

                        // Hiển thị thông báo thành công
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text('Gửi phản hồi thành công!'),
                              ],
                            ),
                            backgroundColor: Colors.green.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );

                        print("Phản hồi: $feedback");
                        // TODO: Gửi phản hồi lên server tại đây
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Gửi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
