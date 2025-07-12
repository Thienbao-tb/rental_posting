import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../../providers/location_provider.dart';
import 'category_page.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  Map<int, bool> selectedCategories = {};
  Map<int, bool> selectedQhuyen = {};
  Map<int, bool> selectedPhuongxa = {};

  Map<String, bool> selectedPriceRanges = {};
  Map<String, bool> selectedAreaRanges = {};

  Map<String, bool> expandedSections = {
    'Mức giá': false,
    'Diện tích': false,
    'Phường xã': false,
  };

  final Map<String, int> priceRanges = {
    'Dưới 1 triệu': 1,
    '1-2 triệu': 2,
    '2-3 triệu': 3,
    '3-5 triệu': 4,
    '5-7 triệu': 5,
    '7-10 triệu': 6,
    '10-15 triệu': 7,
    'Trên 15 triệu': 8,
  };

  final Map<String, int> areaRanges = {
    'Dưới 20m²': 1,
    '20-30m²': 2,
    '30-50m²': 3,
    '50-60m²': 4,
    '60-70m²': 5,
    '70-80m²': 6,
    '80-100m²': 7,
    '100-120m²': 8,
    '120-150m²': 9,
    'Trên 150m²': 10,
  };

  @override
  void initState() {
    super.initState();
    for (var key in priceRanges.keys) {
      selectedPriceRanges[key] = false;
    }
    for (var key in areaRanges.keys) {
      selectedAreaRanges[key] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final categorys = categoryProvider.categorys;
    final qhuyen = locationProvider.qhuyen;
    final phuongxa = locationProvider.phuongxa;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Bộ lọc tìm kiếm',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedCategories.clear();
                        selectedQhuyen.clear();
                        selectedPhuongxa.clear();
                        selectedPriceRanges.updateAll((key, value) => false);
                        selectedAreaRanges.updateAll((key, value) => false);
                      });
                    },
                    child: const Text('Clear',
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                  ),
                ],
              ),
            ),

            // === NỘI DUNG ===
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Danh mục cho thuê',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...categorys.map((category) {
                      final id = category.id!;
                      return CheckboxListTile(
                        title: Text(category.ten ?? 'Không tên'),
                        value: selectedCategories[id] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedCategories[id] = value ?? false;
                          });
                        },
                        activeColor: Colors.green,
                      );
                    }).toList(),

                    const Divider(),

                    const Text('Quận/Huyện',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...qhuyen.map((item) {
                      final id = item.id!;
                      return CheckboxListTile(
                        title: Text(item.ten ?? 'Không tên'),
                        value: selectedQhuyen[id] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedQhuyen[id] = value ?? false;
                          });
                        },
                        activeColor: Colors.green,
                      );
                    }).toList(),

                    const Divider(),

                    // === PHƯỜNG/XÃ ===
                    ListTile(
                      title: const Text('Phường/Xã',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      trailing: Icon(expandedSections['Phường xã']!
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                      onTap: () {
                        setState(() {
                          expandedSections['Phường xã'] =
                              !expandedSections['Phường xã']!;
                        });
                      },
                    ),
                    if (expandedSections['Phường xã']!)
                      ...phuongxa.map((item) {
                        final id = item.id!;
                        return CheckboxListTile(
                          title: Text(item.ten ?? 'Không tên'),
                          value: selectedPhuongxa[id] ?? false,
                          onChanged: (bool? value) {
                            setState(() {
                              selectedPhuongxa[id] = value ?? false;
                            });
                          },
                          activeColor: Colors.green,
                        );
                      }).toList(),

                    const Divider(),

                    // === MỨC GIÁ ===
                    ListTile(
                      title: const Text('Mức giá',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      trailing: Icon(expandedSections['Mức giá']!
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                      onTap: () {
                        setState(() {
                          expandedSections['Mức giá'] =
                              !expandedSections['Mức giá']!;
                        });
                      },
                    ),
                    if (expandedSections['Mức giá']!)
                      ...priceRanges.keys.map((key) {
                        return CheckboxListTile(
                          title: Text(key),
                          value: selectedPriceRanges[key] ?? false,
                          onChanged: (bool? value) {
                            setState(() {
                              selectedPriceRanges[key] = value ?? false;
                            });
                          },
                          activeColor: Colors.green,
                        );
                      }).toList(),

                    const Divider(),

                    // === DIỆN TÍCH ===
                    ListTile(
                      title: const Text('Diện tích',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      trailing: Icon(expandedSections['Diện tích']!
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                      onTap: () {
                        setState(() {
                          expandedSections['Diện tích'] =
                              !expandedSections['Diện tích']!;
                        });
                      },
                    ),
                    if (expandedSections['Diện tích']!)
                      ...areaRanges.keys.map((key) {
                        return CheckboxListTile(
                          title: Text(key),
                          value: selectedAreaRanges[key] ?? false,
                          onChanged: (bool? value) {
                            setState(() {
                              selectedAreaRanges[key] = value ?? false;
                            });
                          },
                          activeColor: Colors.green,
                        );
                      }).toList(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // === NÚT TÌM KIẾM ===
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  final selectedCategoryIds = selectedCategories.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .toList();

                  final selectedQhuyenIds = selectedQhuyen.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .toList();

                  final selectedPhuongxaIds = selectedPhuongxa.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .toList();

                  // final selectedPriceIds = selectedPriceRanges.entries
                  //     .where((e) => e.value)
                  //     .map((e) => priceRanges[e.key])
                  //     .toList();
                  //
                  // final selectedAreaIds = selectedAreaRanges.entries
                  //     .where((e) => e.value)
                  //     .map((e) => areaRanges[e.key])
                  //     .toList();

                  final selectedPriceIds = selectedPriceRanges.entries
                      .where((e) => e.value)
                      .map((e) => priceRanges[e.key])
                      .whereType<int>()
                      .toList();

                  final selectedAreaIds = selectedAreaRanges.entries
                      .where((e) => e.value)
                      .map((e) => areaRanges[e.key])
                      .whereType<int>()
                      .toList();

                  print('Danh mục: $selectedCategoryIds');
                  print('Quận/Huyện: $selectedQhuyenIds');
                  print('Phường/Xã: $selectedPhuongxaIds');
                  print('Mức giá (ID): $selectedPriceIds');
                  print('Diện tích (ID): $selectedAreaIds');

                  setState(() {
                    selectedCategories.clear();
                    selectedQhuyen.clear();
                    selectedPhuongxa.clear();
                    selectedPriceRanges.updateAll((key, value) => false);
                    selectedAreaRanges.updateAll((key, value) => false);
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(
                          title: 'Kết quả lọc',
                          categoryId: selectedCategoryIds,
                          keyWord: '',
                          dientich: selectedAreaIds,
                          mucgia: selectedPriceIds,
                          phuongxa: selectedPhuongxaIds,
                          qhuyen: selectedQhuyenIds,
                          moiNhat: false,
                          noiBat: false,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tìm kiếm',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
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
