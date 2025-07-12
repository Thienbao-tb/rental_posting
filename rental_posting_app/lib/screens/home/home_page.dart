import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/config/api_config.dart';
import 'package:rental_posting_app/providers/category_provider.dart';
import 'package:rental_posting_app/providers/location_provider.dart';
import 'package:rental_posting_app/providers/new_post_provider.dart';
import 'package:rental_posting_app/screens/home/post_property_page.dart';
import 'package:rental_posting_app/screens/home/profile_page.dart';

import '../../config/format_function.dart';
import '../../providers/auth_provider.dart';
import '../../providers/highlight_post_provider.dart';
import '../blog/blog_list_screen.dart';
import '../price/price_table.dart';
import 'category_page.dart';
import 'filter_page.dart';
import 'property_detail_page.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const PostPropertyPage(),
    const BlogListScreen(),
    const ProfilePage(),
  ];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
              icon: Icon(Icons.post_add), label: 'Đăng tin'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Bài viết'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  //theo dõi và điều khiển việc cuộn.
  final ScrollController _highlightScrollController = ScrollController();
  final ScrollController _newestScrollController = ScrollController();

  //theo dõi khi người dùng cuộn gần cuối danh sách để tự động tải thêm dữ liệu (lazy load).
  @override
  void initState() {
    super.initState();

    final highlightPostProvider =
        Provider.of<HighlightPostProvider>(context, listen: false);

    _highlightScrollController.addListener(() {
      if (_highlightScrollController.position.pixels >=
              _highlightScrollController.position.maxScrollExtent - 100 &&
          !highlightPostProvider.isLoading &&
          highlightPostProvider.hasMore) {
        highlightPostProvider.fetchMorePosts();
      }
    });

    final newPostProvider =
        Provider.of<NewPostProvider>(context, listen: false);
    _newestScrollController.addListener(() {
      if (_newestScrollController.position.pixels >=
              _newestScrollController.position.maxScrollExtent - 100 &&
          !newPostProvider.isLoading &&
          newPostProvider.hasMore) {
        newPostProvider.fetchMorePosts();
      }
    });

    Future.microtask(() {
      if (!mounted) return;
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      provider.fetchCategory();

      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      locationProvider.fetchQhuyenLocation();
      locationProvider.fetchPhuongXaLocation();
      locationProvider.fetchHotLocations();
    });
  }

  // hình ảnh cho carousel
  final List<String> promotionImages = [
    'assets/images/img1.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _highlightScrollController.dispose();
    _newestScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    final highlightPostProvider = Provider.of<HighlightPostProvider>(context);
    final highlightPosts = highlightPostProvider.posts;

    final newestPostProvider = Provider.of<NewPostProvider>(context);
    final newestPosts = newestPostProvider.posts;

    final locationProvider = Provider.of<LocationProvider>(context);
    final highlightLocations = locationProvider.locations;

    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categorys = categoryProvider.categorys;

    List<IconData> categoryIcons = [
      Icons.apartment,
      Icons.house,
      Icons.store,
      Icons.group,
      Icons.business,
      Icons.article,
    ];
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage:
                              (user?.anhdaidien?.isNotEmpty ?? false)
                                  ? NetworkImage(FormatFunction.buildAvatarUrl(
                                      user!.anhdaidien!))
                                  : null,
                          backgroundColor: Colors.grey,
                          child: (user?.anhdaidien?.isEmpty ?? true)
                              ? const Icon(Icons.person,
                                  size: 24, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          user?.ten ?? 'Ẩn danh',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.grey),
              title: const Text('Trang chủ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Column(
              children: List.generate(categorys.length, (index) {
                final category = categorys[index];
                final icon = categoryIcons.length > index
                    ? categoryIcons[index]
                    : Icons.category;
                return ListTile(
                  leading: Icon(
                    icon,
                    color: Colors.grey,
                  ),
                  title: Text(
                    category.ten,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryPage(
                            title: category.ten,
                            categoryId: [category.id],
                            keyWord: '',
                            dientich: const [],
                            mucgia: const [],
                            phuongxa: const [],
                            qhuyen: const [],
                            noiBat: false,
                            moiNhat: false,
                          ),
                        ));
                  },
                );
              }),
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.grey),
              title: const Text('Bảng giá'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BangGiaScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article, color: Colors.grey),
              title: const Text('Bài viết'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BlogListScreen(),
                    ));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'XEM TẤT CẢ BÀI ĐĂNG',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryPage(
                        title: 'Tất cả tin đăng',
                        categoryId: [-2],
                        keyWord: '',
                        dientich: [],
                        mucgia: [],
                        phuongxa: [],
                        qhuyen: [],
                        noiBat: false,
                        moiNhat: false,
                      ),
                    ));
              },
            ),
            ListTile(
              title: const Text(
                'PASS ĐỒ CŨ',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pass đồ cũ')),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.menu,
                                color: theme.colorScheme.primary),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.ten ?? "",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Hãy cùng StayConnect khám phá địa điểm phù hợp với bạn',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications_outlined,
                          color: theme.colorScheme.primary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Tính năng thông báo chưa được triển khai!')),
                        );
                      },
                    ),
                  ],
                ),

                // Phần Search
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm...',
                    prefixIcon:
                        Icon(Icons.search, color: theme.colorScheme.primary),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.filter_list,
                          color: theme.colorScheme.primary),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FilterPage()),
                        );
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.teal),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                              title: 'Kết quả tìm kiếm',
                              categoryId: [-2],
                              keyWord: value,
                              dientich: [],
                              mucgia: [],
                              phuongxa: [],
                              qhuyen: [],
                              noiBat: false,
                              moiNhat: false,
                            ),
                          ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vui lòng nhập từ khóa tìm kiếm!')),
                      );
                    }
                  },
                ),

                // Phần Carousel
                const SizedBox(height: 16),
                // SizedBox(
                //   height: 180,
                //   child: FlutterCarousel(
                //     options: CarouselOptions(
                //       height: 180,
                //       autoPlay: true,
                //       autoPlayInterval: const Duration(seconds: 3),
                //       viewportFraction: 1.0,
                //       showIndicator: true,
                //       slideIndicator: const CircularSlideIndicator(),
                //     ),
                //     items: promotionImages.map((imagePath) {
                //       return GestureDetector(
                //         onTap: () {
                //           ScaffoldMessenger.of(context).showSnackBar(
                //             const SnackBar(
                //                 content: Text(
                //                     'Tính năng xem khuyến mãi chưa được triển khai!')),
                //           );
                //         },
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.circular(12.0),
                //           child: Image.asset(
                //             imagePath,
                //             fit: BoxFit.cover,
                //             width: double.infinity,
                //             height: 180,
                //             errorBuilder: (context, error, stackTrace) =>
                //                 Container(
                //               width: double.infinity,
                //               height: 180,
                //               color: Colors.grey[300],
                //               child: const Icon(Icons.error, size: 40),
                //             ),
                //           ),
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                // Phần danh mục tìm kiếm
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Danh mục tìm kiếm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoryPage(
                              title: 'Tất cả danh mục',
                              categoryId: [-1],
                              keyWord: '',
                              qhuyen: [],
                              phuongxa: [],
                              mucgia: [],
                              dientich: [],
                              noiBat: false,
                              moiNhat: false,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      children: categorys.map((category) {
                        return _buildCategoryText(category.ten, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                title: category.ten,
                                categoryId: [category.id],
                                keyWord: '',
                                dientich: [],
                                mucgia: [],
                                phuongxa: [],
                                qhuyen: [],
                                noiBat: false,
                                moiNhat: false,
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    ),
                  ),
                ),

                //Phần tin nổi bật
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tin nổi bật',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoryPage(
                              title: 'Tất cả tin nổi bật',
                              categoryId: [-2],
                              keyWord: '',
                              dientich: [],
                              mucgia: [],
                              phuongxa: [],
                              qhuyen: [],
                              noiBat: true,
                              moiNhat: false,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 350,
                  child: ListView.builder(
                    controller: _highlightScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: highlightPosts.length +
                        (highlightPostProvider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < highlightPosts.length) {
                        final post = highlightPosts[index];
                        return SizedBox(
                          child: _buildPropertyCard(
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
                                  .longitude),
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
                ),

                // Phần tin đăng mới nhất
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tin đăng mới nhất',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoryPage(
                              title: 'Tất cả tin mới nhất',
                              categoryId: [-2],
                              keyWord: '',
                              dientich: [],
                              mucgia: [],
                              phuongxa: [],
                              qhuyen: [],
                              noiBat: false,
                              moiNhat: true,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 350,
                  child: ListView.builder(
                    controller: _newestScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: newestPosts.length +
                        (newestPostProvider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < newestPosts.length) {
                        final newestPost = newestPosts[index];
                        return SizedBox(
                          child: _buildPropertyCard(
                              context: context,
                              image: newestPost.anhdaidien != null
                                  ? FormatFunction.buildAvatarUrl(
                                      newestPost.anhdaidien ?? "")
                                  : "${ApiConfig.baseUrl}/images/news-1.jpg",
                              title: newestPost.ten ?? "",
                              address: newestPost.city?.ten ?? "",
                              price: newestPost.gia.toString(),
                              discountedPrice: "",
                              updateDate: FormatFunction.formatDate(
                                  newestPost.createdAt.toString()),
                              category: newestPost.category.ten,
                              area: newestPost.khuvuc.toString(),
                              level: "#${newestPost.id}",
                              expiryDate: FormatFunction.formatDate(
                                  newestPost.thoigian_ketthuc.toString()),
                              description: newestPost.mota ?? "",
                              star: newestPost.dichvu_hot,
                              chitietdiachi: newestPost.chitietdiachi ?? "",
                              idPhong: newestPost.id,
                              khuVuc:
                                  "${newestPost.wards?.ten} / ${newestPost.district?.ten}",
                              latitude: FormatFunction.parseCoordinates(
                                      newestPost.map ?? '')
                                  .latitude,
                              longitude: FormatFunction.parseCoordinates(
                                      newestPost.map ?? '')
                                  .longitude),
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
                ),

                // Phần khu vực nổi bật
                const SizedBox(height: 16),
                const Text(
                  'Khu vực nổi bật',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: highlightLocations.map((location) {
                    return _buildAreaCard(
                      location.ten,
                      FormatFunction.buildAvatarUrl(location.anhdaidien ?? ""),
                      () {
                        List<int> qhuyen = [];
                        List<int> phuongxa = [];

                        if (location.loai == 1) {
                          qhuyen = [location.id];
                        } else if (location.loai == 2) {
                          phuongxa = [location.id];
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                              title: location.ten,
                              categoryId: const [-1],
                              qhuyen: qhuyen,
                              phuongxa: phuongxa,
                              mucgia: const [],
                              dientich: const [],
                              keyWord: '',
                              noiBat: false,
                              moiNhat: false,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),

                //Sửa lại phần Route cho  khu vực nổi bật

                // const SizedBox(height: 8),
                // _buildAreaCard('Quận Bình Thủy', 'assets/images/img1.jpg', () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => CategoryPage(
                //         title: 'Tin tại Quận Bình Thủy',
                //         properties: filterByDistrict('Quận Bình Thủy'),
                //       ),
                //     ),
                //   );
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryText(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String title, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.teal : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildPropertyCard(
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
    final theme = Theme.of(context);
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(
                image: image,
                category: category,
                title: title,
                address: chitietdiachi,
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
        child: SizedBox(
          width: 330,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12)),
                  child: Image.network(
                    image,
                    height: 180,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: SizedBox(
                    height: 20,
                    child: Row(
                      children: [
                        Row(
                          children: List.generate(
                              star,
                              (index) => const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                  )),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14.0, vertical: 0),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: FormatFunction.formatTitle(star),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
                  child: Text(
                    chitietdiachi,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: FormatFunction.formatPrice(
                                int.parse(price).toString()),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ))
                      ])),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "Diện tích:",
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: " $area m\u00B2",
                            style: theme.textTheme.bodyMedium)
                      ])),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildAreaCard(String title, String image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 200,
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, size: 40),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
