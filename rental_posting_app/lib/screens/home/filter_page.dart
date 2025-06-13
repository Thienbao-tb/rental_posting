import 'package:flutter/material.dart';

import 'category_page.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // Trạng thái của các checkbox cho "Danh mục cho thuê"
  Map<String, bool> rentalCategories = {
    'Nhà trọ': false,
    'Mặt bằng': true,
    'Nhà cho thuê': true,
    'Pass đồ cũ': false,
    'Ở ghép': false,
  };

  // Trạng thái của các checkbox cho "Quận"
  Map<String, bool> districts = {
    'Tất cả': false,
    'Quận Ninh Kiều': true,
    'Quận Cái Răng': true,
    'Quận Bình Thủy': false,
    'Quận Ô Môn': true,
    'Quận Thốt Nốt': false,
    'Quận Cờ Đỏ': false,
    'Quận Phong Điền': false,
    'Quận Thới Lai': true,
    'Quận Vĩnh Thạnh': false,
  };

  // Trạng thái của các checkbox cho "Phường xã"
  Map<String, bool> wards = {
    'Phường An Bình': false,
    'Phường An Hòa': false,
    'Phường Cái Khế': false,
    'Phường Xuân Khánh': false,
  };

  // Trạng thái của các checkbox cho "Mức giá"
  Map<String, bool> priceRanges = {
    'Dưới 1 triệu': false,
    '1-2 triệu': false,
    '2-3 triệu': false,
    '3-5 triệu': false,
    'Trên 5 triệu': false,
  };

  // Trạng thái của các checkbox cho "Diện tích"
  Map<String, bool> areaRanges = {
    'Dưới 20m²': false,
    '20-30m²': false,
    '30-50m²': false,
    '50-80m²': false,
    'Trên 80m²': false,
  };

  // Trạng thái mở rộng/thu gọn cho các mục
  Map<String, bool> expandedSections = {
    'Phường xã': false,
    'Mức giá': false,
    'Diện tích': false,
  };

  // Hàm lọc dữ liệu dựa trên các lựa chọn
  List<Map<String, String>> filterProperties(
      List<Map<String, String>> allProperties) {
    return allProperties.where((property) {
      bool matchesCategory = rentalCategories.entries.any((entry) {
        if (!entry.value) return true; // Nếu không chọn, bỏ qua
        String categoryKey = entry.key;
        String mappedCategory = {
              'Nhà trọ': 'Cho thuê phòng trọ',
              'Mặt bằng': 'Cho thuê mặt bằng',
              'Nhà cho thuê': 'Cho thuê nhà ở',
              'Pass đồ cũ': 'Pass đồ cũ',
              'Ở ghép': 'Ở ghép',
            }[categoryKey] ??
            categoryKey;
        return property['category'] == mappedCategory;
      });

      bool matchesDistrict = districts.entries.any((entry) {
        if (!entry.value) return true; // Nếu không chọn, bỏ qua
        if (entry.key == 'Tất cả') return true;
        return property['district'] == entry.key;
      });

      bool matchesWard = wards.entries.any((entry) {
        if (!entry.value) return true; // Nếu không chọn, bỏ qua
        return property['address']?.contains(entry.key) ?? false;
      });

      bool matchesPrice = priceRanges.entries.any((entry) {
        if (!entry.value) return true; // Nếu không chọn, bỏ qua
        String priceStr =
            property['price']?.replaceAll(RegExp(r'[^\d]'), '') ?? '0';
        int price = int.tryParse(priceStr) ?? 0;
        switch (entry.key) {
          case 'Dưới 1 triệu':
            return price < 1000000;
          case '1-2 triệu':
            return price >= 1000000 && price <= 2000000;
          case '2-3 triệu':
            return price > 2000000 && price <= 3000000;
          case '3-5 triệu':
            return price > 3000000 && price <= 5000000;
          case 'Trên 5 triệu':
            return price > 5000000;
          default:
            return false;
        }
      });

      bool matchesArea = areaRanges.entries.any((entry) {
        if (!entry.value) return true; // Nếu không chọn, bỏ qua
        String areaStr = property['area']?.replaceAll('m²', '') ?? '0';
        int area = int.tryParse(areaStr) ?? 0;
        switch (entry.key) {
          case 'Dưới 20m²':
            return area < 20;
          case '20-30m²':
            return area >= 20 && area <= 30;
          case '30-50m²':
            return area > 30 && area <= 50;
          case '50-80m²':
            return area > 50 && area <= 80;
          case 'Trên 80m²':
            return area > 80;
          default:
            return false;
        }
      });

      return matchesCategory &&
          matchesDistrict &&
          matchesWard &&
          matchesPrice &&
          matchesArea;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Giả định lấy dữ liệu từ HomePage (cần truyền hoặc quản lý chung)
    final allProperties = [
      // Dữ liệu mẫu từ HomePage (rentalProperties, paymentProperties, v.v.)
      {
        'image': 'assets/images/property1.jpg',
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
        'image': 'assets/images/property2.jpg',
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
        'image': 'assets/images/property3.jpg',
        'category': 'Cho thuê mặt bằng',
        'title': 'CHO THUÊ MẶT BẰNG KINH DOANH 70M2...',
        'price': '5,000,000 đ',
        'area': '70m²',
        'updateDate': 'Cập nhật: 2025-05-07 11:22:17',
        'address':
            'đường Võ Trường Toản, phường An Hòa, quận Ninh Kiều, Cần Thơ',
        'level': '97',
        'expiryDate': '2025-05-27',
        'description':
            'Mặt bằng kinh doanh rộng 70m², vị trí đắc địa, gần trung tâm, phù hợp mở cửa hàng, văn phòng. Có sẵn camera 24/24, xem thêm',
        'district': 'Quận Ninh Kiều',
      },
      // Thêm các dữ liệu khác nếu cần
    ];

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
                      const Text(
                        'Bộ lọc tìm kiếm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Reset tất cả checkbox
                      setState(() {
                        rentalCategories.updateAll((key, value) => false);
                        districts.updateAll((key, value) => false);
                        wards.updateAll((key, value) => false);
                        priceRanges.updateAll((key, value) => false);
                        areaRanges.updateAll((key, value) => false);
                      });
                    },
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Danh mục cho thuê
                      const Text(
                        'Danh mục cho thuê',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...rentalCategories.keys.map((category) {
                        return CheckboxListTile(
                          title: Text(category),
                          value: rentalCategories[category],
                          activeColor: Colors.green,
                          onChanged: (bool? value) {
                            setState(() {
                              rentalCategories[category] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                      const Divider(),
                      // Quận
                      const Text(
                        'Quận',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...districts.keys.map((district) {
                        return CheckboxListTile(
                          title: Text(district),
                          value: districts[district],
                          activeColor: Colors.green,
                          onChanged: (bool? value) {
                            setState(() {
                              districts[district] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                      const Divider(),
                      // Phường xã
                      ListTile(
                        title: const Text(
                          'Phường xã',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          expandedSections['Phường xã']!
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                        ),
                        onTap: () {
                          setState(() {
                            expandedSections['Phường xã'] =
                                !expandedSections['Phường xã']!;
                          });
                        },
                      ),
                      if (expandedSections['Phường xã']!)
                        Column(
                          children: wards.keys.map((ward) {
                            return CheckboxListTile(
                              title: Text(ward),
                              value: wards[ward],
                              activeColor: Colors.green,
                              onChanged: (bool? value) {
                                setState(() {
                                  wards[ward] = value ?? false;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      const Divider(),
                      // Mức giá
                      ListTile(
                        title: const Text(
                          'Mức giá',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          expandedSections['Mức giá']!
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                        ),
                        onTap: () {
                          setState(() {
                            expandedSections['Mức giá'] =
                                !expandedSections['Mức giá']!;
                          });
                        },
                      ),
                      if (expandedSections['Mức giá']!)
                        Column(
                          children: priceRanges.keys.map((price) {
                            return CheckboxListTile(
                              title: Text(price),
                              value: priceRanges[price],
                              activeColor: Colors.green,
                              onChanged: (bool? value) {
                                setState(() {
                                  priceRanges[price] = value ?? false;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      const Divider(),
                      // Diện tích
                      ListTile(
                        title: const Text(
                          'Diện tích',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          expandedSections['Diện tích']!
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                        ),
                        onTap: () {
                          setState(() {
                            expandedSections['Diện tích'] =
                                !expandedSections['Diện tích']!;
                          });
                        },
                      ),
                      if (expandedSections['Diện tích']!)
                        Column(
                          children: areaRanges.keys.map((area) {
                            return CheckboxListTile(
                              title: Text(area),
                              value: areaRanges[area],
                              activeColor: Colors.green,
                              onChanged: (bool? value) {
                                setState(() {
                                  areaRanges[area] = value ?? false;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            // Nút Tìm kiếm
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  List<Map<String, String>> filteredProperties =
                      filterProperties(allProperties);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        title: 'Kết quả bộ lọc',
                        properties: filteredProperties,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tìm kiếm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
