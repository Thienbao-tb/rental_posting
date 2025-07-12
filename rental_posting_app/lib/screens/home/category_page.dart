import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/providers/get_post_byCategory_provider.dart';

import '../../config/api_config.dart';
import '../../config/format_function.dart';
import 'filter_page.dart';
import 'property_detail_page.dart';

class CategoryPage extends StatefulWidget {
  final String title;
  final List<int> categoryId;
  final List<int> qhuyen;
  final List<int> phuongxa;
  final List<int> mucgia;
  final List<int> dientich;
  final String keyWord;
  final bool noiBat;
  final bool moiNhat;

  const CategoryPage(
      {super.key,
      required this.title,
      required this.categoryId,
      required this.keyWord,
      required this.qhuyen,
      required this.phuongxa,
      required this.mucgia,
      required this.dientich,
      required this.noiBat,
      required this.moiNhat});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<GetPostByCategoryProvider>(context, listen: false);
      provider.fetchPostByCategory(
          categoryIds: widget.categoryId,
          keyword: widget.keyWord,
          priceRanges: widget.mucgia,
          areaRanges: widget.dientich,
          wardIds: widget.phuongxa,
          districtIds: widget.qhuyen,
          noiBat: widget.noiBat,
          moiNhat: widget.moiNhat);
    });

    _scrollController.addListener(() {
      final provider =
          Provider.of<GetPostByCategoryProvider>(context, listen: false);

      double current = _scrollController.position.pixels;
      double max = _scrollController.position.maxScrollExtent;

      if (current >= max - 50 && !provider.isLoading && provider.hasMore) {
        provider.fetchMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getPostByCategoryProvider =
        Provider.of<GetPostByCategoryProvider>(context);
    final posts = getPostByCategoryProvider.posts;
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
                        '${widget.title} (${posts.length} tin)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FilterPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Danh sách tin đăng

            Expanded(
              child: getPostByCategoryProvider.isLoading && posts.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : posts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/noPost.png',
                                width: 130,
                              ),
                              const Text(
                                "Không có tin đăng cho danh mục này!!!",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemCount: posts.length +
                              (getPostByCategoryProvider.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < posts.length) {
                              final post = posts[index];
                              return _buildPropertyItem(
                                context: context,
                                image: post.anhdaidien != null
                                    ? FormatFunction.buildAvatarUrl(
                                        post.anhdaidien ?? "")
                                    : "${ApiConfig.baseUrl}/images/news-1.jpg",
                                title: post.ten ?? "",
                                address: post.city?.ten ?? "",
                                price: post.gia.toString(),
                                discountedPrice: "",
                                updateDate: FormatFunction.formatDate(
                                    post.createdAt.toString()),
                                category: post.category.ten,
                                area: post.khuvuc.toString(),
                                level: "#${post.id}",
                                expiryDate: FormatFunction.formatDate(
                                    post.thoigian_ketthuc.toString()),
                                description: post.mota ?? "",
                                star: post.dichvu_hot,
                                chitietdiachi: post.chitietdiachi ?? "",
                                idPhong: post.id,
                                khuVuc:
                                    "${post.wards?.ten} / ${post.district?.ten}",
                                latitude: FormatFunction.parseCoordinates(
                                        post.map ?? '')
                                    .latitude,
                                longitude: FormatFunction.parseCoordinates(
                                        post.map ?? '')
                                    .longitude,
                              );
                            } else {
                              return const SizedBox(
                                width: 250,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyItem(
      {required BuildContext context,
      required String image,
      required String title,
      required String address,
      required String price,
      required String discountedPrice,
      required String updateDate,
      required String category,
      required String area,
      required String level,
      required String expiryDate,
      required String description,
      required int star,
      required String chitietdiachi,
      required int idPhong,
      required String khuVuc,
      required double latitude,
      required double longitude}) {
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
              idPhong: idPhong,
              star: star,
              khuVuc: khuVuc,
              latitude: latitude,
              longitude: longitude,
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
                child: Image.network(
                  image,
                  width: 120,
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: FormatFunction.formatTitle(star),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${FormatFunction.formatPrice(price)} | $area m\u00B2',
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
                      khuVuc,
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
                              idPhong: 0,
                              star: 0,
                              khuVuc: '',
                              latitude: 0.0,
                              longitude: 0.0,
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
