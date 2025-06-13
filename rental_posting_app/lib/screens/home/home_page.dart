import 'package:flutter/material.dart';
import 'package:rental_posting_app/screens/auth/login_screen.dart';
import 'package:rental_posting_app/screens/home/post_property_page.dart';
import 'package:rental_posting_app/screens/home/profile_page.dart';

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
    HomePage(),
    PostPropertyPage(),
    ProfilePage(),
    LoginScreen()
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Đăng xuất'),
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

  // Promotion images for carousel
  final List<String> promotionImages = [
    'assets/images/img1.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
  ];
  // Featured properties data
  final List<Map<String, String>> featuredProperties = [
    {
      'image': 'assets/images/img1.jpg',
      'title': 'Mới bằng Cao cấp, KDC Hồng Phát...',
      'address': 'Xuân Thủy, Phường An Bình, Quận Ninh Kiều, Cần Thơ',
      'price': '3.000.000 đ',
      'discountedPrice': '1.500.000 đ',
      'updateDate': 'Cập nhật: 2025-04-07',
      'category': 'Nộp tiền',
      'area': '50m²',
      'level': '95',
      'expiryDate': '2025-04-27',
      'description':
          'Phòng có cửa sổ hứng nắng sáng, gần trung tâm, đầy đủ tiện nghi.',
      'district': 'Quận Ninh Kiều',
    },
    {
      'image': 'assets/images/img2.jpg',
      'title': 'Nhà trọ An Minh cao cấp 30 phòng...',
      'address': 'Nguyen Văn Cừ, Phường An Hòa, Quận Ninh Kiều, Cần Thơ',
      'price': '1.700.000 đ',
      'discountedPrice': '3.500.000 đ',
      'updateDate': 'Cập nhật: 2025-04-25',
      'category': 'Cho thuê phòng trọ',
      'area': '40m²',
      'level': '96',
      'expiryDate': '2025-05-25',
      'description': 'Phòng có máy lạnh, gần Đại học, khu vực an ninh.',
      'district': 'Quận Ninh Kiều',
    },
    {
      'image': 'assets/images/img3.jpg',
      'title': 'Căn hộ cao cấp trung tâm...',
      'address': 'Phường Cái Khế, Quận Ninh Kiều, Cần Thơ',
      'price': '2.500.000 đ',
      'discountedPrice': '2.000.000 đ',
      'updateDate': 'Cập nhật: 2025-04-10',
      'category': 'Cho thuê nhà ở',
      'area': '60m²',
      'level': '97',
      'expiryDate': '2025-05-10',
      'description': 'Căn hộ cao cấp với vị trí đắc địa, đầy đủ tiện nghi.',
      'district': 'Quận Ninh Kiều',
    },
  ];

  // Latest properties data
  final List<Map<String, String>> latestProperties = [
    {
      'image': 'assets/images/img1.jpg',
      'title': 'Nhà trọ An Minh cao cấp 30 phòng...',
      'address': 'Nguyen Văn Cừ, Phường An Hòa, Quận Ninh Kiều, Cần Thơ',
      'price': '1.700.000 đ',
      'discountedPrice': '3.500.000 đ',
      'updateDate': 'Cập nhật: 2025-04-25',
      'category': 'Cho thuê phòng trọ',
      'area': '40m²',
      'level': '96',
      'expiryDate': '2025-05-25',
      'description': 'Phòng có máy lạnh, gần Đại học, khu vực an ninh.',
      'district': 'Quận Ninh Kiều',
    },
    {
      'image': 'assets/images/img2.jpg',
      'title': 'Mới bằng Cao cấp, KDC Hồng Phát...',
      'address': 'Xuân Thủy, Phường An Bình, Quận Ninh Kiều, Cần Thơ',
      'price': '3.000.000 đ',
      'discountedPrice': '1.500.000 đ',
      'updateDate': 'Cập nhật: 2025-04-07',
      'category': 'Nộp tiền',
      'area': '50m²',
      'level': '95',
      'expiryDate': '2025-04-27',
      'description':
          'Phòng có cửa sổ hứng nắng sáng, gần trung tâm, đầy đủ tiện nghi.',
      'district': 'Quận Ninh Kiều',
    },
    {
      'image': 'assets/images/img3.jpg',
      'title': 'Phòng trọ sinh viên giá rẻ...',
      'address': 'Phường Xuân Khánh, Quận Bình Thủy, Cần Thơ',
      'price': '1.200.000 đ',
      'discountedPrice': '1.000.000 đ',
      'updateDate': 'Cập nhật: 2025-04-12',
      'category': 'Cho thuê phòng trọ',
      'area': '30m²',
      'level': '94',
      'expiryDate': '2025-05-12',
      'description': 'Phòng trọ giá rẻ, phù hợp cho sinh viên, gần trường học.',
      'district': 'Quận Bình Thủy',
    },
  ];

  // Rental properties data
  final List<Map<String, String>> rentalProperties = [
    {
      'image': 'assets/images/img1.jpg',
      'category': 'Cho thuê phòng trọ',
      'title': 'NHÀ TRỌ CAO CẤP 30M2, FULL NỘI THẤT, NĂM SAU LƯNG...',
      'price': '1,000,000 đ',
      'area': '50m²',
      'updateDate': 'Cập nhật: 2025-04-07 10:22:17',
      'address':
          'CT1B2, hẻm 40, đường Võ Trường Toản, phường An Hòa, quận Ninh Kiều, Cần Thơ',
      'level': '95',
      'expiryDate': '2025-04-27',
      'description':
          'Phòng có cửa sổ hứng nắng sáng, gần Đại học Cộng thường, khu công nghiệp Tân Bình/Vĩnh Lộc/Bình Chánh, bến xe miền Tây,... Có sẵn bàn ghế, camera 24/24, xem thêm',
      'district': 'Quận Ninh Kiều',
    },
    {
      'image': 'assets/images/img2.jpg',
      'category': 'Cho thuê phòng trọ',
      'title': 'NHÀ TRỌ CÓ MÁY LẠNH GẦN ĐẠI HỌC KỸ THUẬT CÔNG NG...',
      'price': '1,700,000 đ',
      'area': '40m²',
      'updateDate': 'Cập nhật: 2025-03-07 12:22:17',
      'address':
          'A78, hẻm 42, đường Võ Trường Toản, phường An Hòa, quận Ninh Kiều, Cần Thơ',
      'level': '96',
      'expiryDate': '2025-03-27',
      'description':
          'Phòng có máy lạnh, gần Đại học Kỹ thuật Công nghệ, khu dân cư yên tĩnh, an ninh tốt. Có sẵn bàn ghế, tủ quần áo, camera 24/24, xem thêm',
      'district': 'Quận Ninh Kiều',
    },
    {
      'image': 'assets/images/img3.jpg',
      'category': 'Cho thuê phòng trọ',
      'title': 'NHÀ TRỌ HƯNG THỊNH PHÁT CÓ 70 PHÒNG ĐẦY ĐỦ TIỆN NG...',
      'price': '2,100,000 đ',
      'area': '50m²',
      'updateDate': 'Cập nhật: 2025-05-07 11:22:17',
      'address': 'đường Võ Trường Toản, phường An Hòa, quận Ninh Kiều, Cần Thơ',
      'level': '97',
      'expiryDate': '2025-05-27',
      'description':
          'Nhà trọ cao cấp với 70 phòng, đầy đủ tiện nghi, gần trung tâm thành phố, khu vực an ninh. Có sẵn bàn ghế, giường, tủ, camera 24/24, xem thêm',
      'district': 'Quận Ninh Kiều',
    },
    {
      'image': 'assets/images/img4.jpg',
      'category': 'Cho thuê phòng trọ',
      'title': 'NHÀ TRỎ THIÊN AN 5 ĐẦY PHÒNG CHO SINH VIÊN, NGƯỜI ĐI LÀM...',
      'price': '1,700,000 đ',
      'area': '50m²',
      'updateDate': 'Cập nhật: 2025-04-23 09:22:17',
      'address':
          'Hẻm 233, Nguyễn Văn Cừ, phường An Hòa, quận Ninh Kiều, Cần Thơ',
      'level': '94',
      'expiryDate': '2025-05-23',
      'description':
          'Nhà trọ Thiên An với 5 phòng, phù hợp cho sinh viên và người đi làm, gần trường học và khu công nghiệp. Có sẵn bàn ghế, giường, camera 24/24, xem thêm',
      'district': 'Quận Ninh Kiều',
    },
  ];

  // Payment properties data
  final List<Map<String, String>> paymentProperties = [
    {
      'image': 'assets/images/img1.jpg',
      'category': 'Nộp tiền',
      'title': 'NỘP TIỀN THUÊ NHÀ TRỌ CAO CẤP 30M2...',
      'price': '1,000,000 đ',
      'area': '50m²',
      'updateDate': 'Cập nhật: 2025-04-07 10:22:17',
      'address':
          'CT1B2, hẻm 40, đường Võ Trường Toản, phường An Hòa, quận Ninh Kiều, Cần Thơ',
      'level': '95',
      'expiryDate': '2025-04-27',
      'description':
          'Nộp tiền thuê nhà trọ cao cấp, gần trung tâm, đầy đủ tiện nghi. Có sẵn bàn ghế, camera 24/24, xem thêm',
      'district': 'Quận Ninh Kiều',
    },
    {
      'image': 'assets/images/img2.jpg',
      'category': 'Nộp tiền',
      'title': 'NỘP TIỀN NHÀ TRỌ CÓ MÁY LẠNH GẦN ĐẠI HỌC...',
      'price': '1,700,000 đ',
      'area': '40m²',
      'updateDate': 'Cập nhật: 2025-03-07 12:22:17',
      'address':
          'A78, hẻm 42, đường Võ Trường Toản, phường An Hòa, quận Ninh Kiều, Cần Thơ',
      'level': '96',
      'expiryDate': '2025-03-27',
      'description':
          'Nộp tiền nhà trọ có máy lạnh, gần Đại học, khu vực an ninh. Có sẵn bàn ghế, tủ quần áo, camera 24/24, xem thêm',
      'district': 'Quận Ninh Kiều',
    },
  ];

  // Commercial properties data
  final List<Map<String, String>> commercialProperties = [
    {
      'image': 'assets/images/img1.jpg',
      'category': 'Cho thuê mặt bằng',
      'title': 'CHO THUÊ MẶT BẰNG KINH DOANH 70M2...',
      'price': '5,000,000 đ',
      'area': '70m²',
      'updateDate': 'Cập nhật: 2025-05-07 11:22:17',
      'address': 'đường Võ Trường Toản, phường An Hòa, quận Ninh Kiều, Cần Thơ',
      'level': '97',
      'expiryDate': '2025-05-27',
      'description':
          'Mặt bằng kinh doanh rộng 70m², vị trí đắc địa, gần trung tâm, phù hợp mở cửa hàng, văn phòng. Có sẵn camera 24/24, xem thêm',
      'district': 'Quận Ninh Kiều',
    },
    {
      'image': 'assets/images/img2.jpg',
      'category': 'Cho thuê mặt bằng',
      'title': 'MẶT BẰNG ĐẸP GẦN TRUNG TÂM 50M2...',
      'price': '3,500,000 đ',
      'area': '50m²',
      'updateDate': 'Cập nhật: 2025-04-23 09:22:17',
      'address':
          'Hẻm 233, Nguyễn Văn Cừ, phường An Hòa, quận Cái Răng, Cần Thơ',
      'level': '94',
      'expiryDate': '2025-05-23',
      'description':
          'Mặt bằng đẹp, gần trung tâm, diện tích 50m², phù hợp kinh doanh nhỏ. Có sẵn camera 24/24, xem thêm',
      'district': 'Quận Cái Răng',
    },
  ];

  // Combine all properties for search and "View All"
  List<Map<String, String>> getAllProperties() {
    return [
      ...rentalProperties,
      ...paymentProperties,
      ...commercialProperties,
    ];
  }

  // Search properties by keyword
  List<Map<String, String>> searchProperties(String keyword) {
    final allProperties = getAllProperties();
    if (keyword.isEmpty) return allProperties;
    return allProperties.where((property) {
      final title = property['title']?.toLowerCase() ?? '';
      final address = property['address']?.toLowerCase() ?? '';
      final description = property['description']?.toLowerCase() ?? '';
      final searchLower = keyword.toLowerCase();
      return title.contains(searchLower) ||
          address.contains(searchLower) ||
          description.contains(searchLower);
    }).toList();
  }

  // Filter properties by category
  List<Map<String, String>> filterByCategory(String category) {
    final allProperties = getAllProperties();
    if (category == 'ALL') return allProperties;
    final categoryMapping = {
      'Mới bằng': 'Nộp tiền',
      'Nhà ở': 'Cho thuê nhà ở',
      'Thuê trọ': 'Cho thuê phòng trọ',
    };
    final mappedCategory = categoryMapping[category] ?? category;
    return allProperties
        .where((property) => property['category'] == mappedCategory)
        .toList();
  }

  // Filter properties by district
  List<Map<String, String>> filterByDistrict(String district) {
    final allProperties = getAllProperties();
    return allProperties
        .where((property) => property['district'] == district)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 40,
                        width: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.apartment,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'STAYCONNECT\nTHẢ GA LỰA CHỌN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/images/img1.jpg'),
                        child: Icon(
                          Icons.person,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "user!.ten",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
            ListTile(
              leading: const Icon(Icons.apartment, color: Colors.grey),
              title: const Text('Thuê phòng trọ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      title: 'Cho thuê nhà trọ',
                      properties: rentalProperties,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.house, color: Colors.grey),
              title: const Text('Thuê nhà ở'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      title: 'Cho thuê nhà ở',
                      properties: filterByCategory('Nhà ở'),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.store, color: Colors.grey),
              title: const Text('Thuê mặt bằng'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      title: 'Cho thuê mặt bằng',
                      properties: commercialProperties,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.grey),
              title: const Text('Ở ghép'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chuyển đến mục Ở ghép')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.grey),
              title: const Text('Bằng giá'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      title: 'Nộp tiền',
                      properties: paymentProperties,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article, color: Colors.grey),
              title: const Text('Bài viết'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chuyển đến mục Bài viết')),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'XEM TẤT CẢ',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      title: 'Tất cả tin đăng',
                      properties: getAllProperties(),
                    ),
                  ),
                );
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
            ListTile(
              title: const Text(
                'XEM CHI TIẾT',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Xem chi tiết')),
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
                            icon: const Icon(Icons.menu, color: Colors.teal),
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
                                  "user.ten",
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
                      icon: const Icon(Icons.notifications_outlined,
                          color: Colors.teal),
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
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for...',
                    prefixIcon: const Icon(Icons.search, color: Colors.teal),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.teal),
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
                      final searchResults = searchProperties(value);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryPage(
                            title: 'Kết quả tìm kiếm: $value',
                            properties: searchResults,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vui lòng nhập từ khóa tìm kiếm!')),
                      );
                    }
                  },
                ),
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
                            builder: (context) => CategoryPage(
                              title: 'Tất cả danh mục',
                              properties: getAllProperties(),
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
                      children: [
                        _buildCategoryText('Cho thuê nhà trọ', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                title: 'Cho thuê nhà trọ',
                                properties: rentalProperties,
                              ),
                            ),
                          );
                        }),
                        _buildCategoryText('Nộp tiền', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                title: 'Nộp tiền',
                                properties: paymentProperties,
                              ),
                            ),
                          );
                        }),
                        _buildCategoryText('Cho thuê mặt bằng', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                title: 'Cho thuê mặt bằng',
                                properties: commercialProperties,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
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
                            builder: (context) => CategoryPage(
                              title: 'Tin nổi bật',
                              properties: featuredProperties,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Xem chi tiết',
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
                // SizedBox(
                //   height: 40,
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     physics: const ClampingScrollPhysics(),
                //     child: Row(
                //       children: [
                //         const SizedBox(width: 4),
                //         _buildCategoryTab('ALL', _selectedCategory == 'ALL',
                //             () {
                //           setState(() {
                //             _selectedCategory = 'ALL';
                //           });
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => CategoryPage(
                //                 title: 'Tin nổi bật - Tất cả',
                //                 properties: filterByCategory('ALL'),
                //               ),
                //             ),
                //           );
                //         }),
                //         _buildCategoryTab(
                //             'Mới bằng', _selectedCategory == 'Mới bằng', () {
                //           setState(() {
                //             _selectedCategory = 'Mới bằng';
                //           });
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => CategoryPage(
                //                 title: 'Tin nổi bật - Mới bằng',
                //                 properties: filterByCategory('Mới bằng'),
                //               ),
                //             ),
                //           );
                //         }),
                //         _buildCategoryTab('Nhà ở', _selectedCategory == 'Nhà ở',
                //             () {
                //           setState(() {
                //             _selectedCategory = 'Nhà ở';
                //           });
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => CategoryPage(
                //                 title: 'Tin nổi bật - Nhà ở',
                //                 properties: filterByCategory('Nhà ở'),
                //               ),
                //             ),
                //           );
                //         }),
                //         _buildCategoryTab(
                //             'Thuê trọ', _selectedCategory == 'Thuê trọ', () {
                //           setState(() {
                //             _selectedCategory = 'Thuê trọ';
                //           });
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => CategoryPage(
                //                 title: 'Tin nổi bật - Thuê trọ',
                //                 properties: filterByCategory('Thuê trọ'),
                //               ),
                //             ),
                //           );
                //         }),
                //         const SizedBox(width: 4),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 350,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredProperties.length,
                    itemBuilder: (context, index) {
                      final property = featuredProperties[index];
                      return SizedBox(
                        child: _buildPropertyCard(
                          context: context,
                          image: property['image']!,
                          title: property['title']!,
                          address: property['address']!,
                          price: property['price']!,
                          discountedPrice: property['discountedPrice']!,
                          updateDate: property['updateDate']!,
                          category: property['category']!,
                          area: property['area']!,
                          level: property['level']!,
                          expiryDate: property['expiryDate']!,
                          description: property['description']!,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
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
                            builder: (context) => CategoryPage(
                              title: 'Tin đăng mới nhất',
                              properties: latestProperties,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Xem chi tiết',
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
                // SizedBox(
                //   height: 130,
                //   child: FlutterCarousel(
                //     options: CarouselOptions(
                //       height: 130,
                //       autoPlay: true,
                //       autoPlayInterval: const Duration(seconds: 3),
                //       enlargeCenterPage: true,
                //       viewportFraction: 0.9,
                //       showIndicator: true,
                //       slideIndicator: const CircularSlideIndicator(),
                //     ),
                //     items: latestProperties.map((property) {
                //       return GestureDetector(
                //         child: _buildPropertyCard(
                //           context: context,
                //           image: property['image']!,
                //           title: property['title']!,
                //           address: property['address']!,
                //           price: property['price']!,
                //           discountedPrice: property['discountedPrice']!,
                //           updateDate: property['updateDate']!,
                //           category: property['category']!,
                //           area: property['area']!,
                //           level: property['level']!,
                //           expiryDate: property['expiryDate']!,
                //           description: property['description']!,
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                const SizedBox(height: 16),
                const Text(
                  'Khu vực nổi bật',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildAreaCard('Quận Bình Thủy', 'assets/images/img1.jpg', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        title: 'Tin tại Quận Bình Thủy',
                        properties: filterByDistrict('Quận Bình Thủy'),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                _buildAreaCard('Quận Ninh Kiều', 'assets/images/img2.jpg', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        title: 'Tin tại Quận Ninh Kiều',
                        properties: filterByDistrict('Quận Ninh Kiều'),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                _buildAreaCard('Quận Cái Răng', 'assets/images/img3.jpg', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        title: 'Tin tại Quận Cái Răng',
                        properties: filterByDistrict('Quận Cái Răng'),
                      ),
                    ),
                  );
                }),
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

  Widget _buildPropertyCard({
    required BuildContext context,
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
  }) {
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
                  child: Image.asset(
                    image,
                    height: 180,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Color(0xffFF6B00), fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
                  child: Text(
                    address,
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
                            text: "3.000.000 VNĐ",
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
                            text: " 150m", style: theme.textTheme.bodyMedium)
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
        height: 150,
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
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
