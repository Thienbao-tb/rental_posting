import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/screens/home/home_page.dart';

import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/post_provider.dart';

class UpdatePostPage extends StatefulWidget {
  final int idPost;
  const UpdatePostPage({super.key, required this.idPost});

  @override
  State<UpdatePostPage> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  bool _isInitialized = false;

  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _exactAddressController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  LatLng? _selectedLocation;
  int? _selectedCategory;
  int? _selectedDistrict;
  int? _selectedWard;

  File? _coverImage;
  List<File> _albumImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickCoverImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _coverImage = File(image.path);
      });
    }
  }

  Future<void> _pickAlbumImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _albumImages = images.map((image) => File(image.path)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);

      await Future.wait([
        categoryProvider.fetchCategory(),
        locationProvider.fetchQhuyenLocation(),
        postProvider.fetchPostById(idPost: widget.idPost),
      ]);

      final postDetail = postProvider.postDetail;
      if (postDetail != null) {
        _titleController.text = postDetail.ten ?? '';
        _descriptionController.text = postDetail.mota ?? '';
        _houseNumberController.text = postDetail.sophong ?? '';
        _exactAddressController.text = postDetail.chitietdiachi ?? '';
        _priceController.text = postDetail.gia.toString();
        _areaController.text = postDetail.khuvuc.toString();
        _selectedCategory = postDetail.category.id;
        _selectedDistrict = postDetail.district?.id;
        _selectedWard = postDetail.wards?.id;

        if (postDetail.map?.isNotEmpty == true) {
          final parts = postDetail.map!.split(',');
          if (parts.length == 2) {
            final lng = double.tryParse(parts[0]);
            final lat = double.tryParse(parts[1]);
            if (lat != null && lng != null) {
              _selectedLocation = LatLng(lat, lng);
            }
          }
        }

        if (postDetail.district?.id != null) {
          await locationProvider.fetchPhuongXaByQhuyen(postDetail.district!.id);
        }

        setState(() => _isInitialized = true);
      }
    });
  }

  @override
  void dispose() {
    _houseNumberController.dispose();
    _exactAddressController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);
    final postDetail = postProvider.postDetail;

    if (postProvider.isLoading || postDetail == null || !_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    _nameController.text = authProvider.user?.ten ?? '';
    _phoneController.text = authProvider.user?.sodienthoai ?? '';

    final categorys = categoryProvider.categorys;
    final qhuyens = locationProvider.qhuyen;
    final phuongxas = locationProvider.phuongxaByQhuyen;

    return Scaffold(
      appBar: AppBar(title: const Text('Cập nhật tin')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Địa chỉ cho thuê',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedDistrict,
                items: qhuyens
                    .map((qh) => DropdownMenuItem<int>(
                          value: qh.id,
                          child: Text(qh.ten),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value;
                    _selectedWard = null;
                  });
                  if (value != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      locationProvider.fetchPhuongXaByQhuyen(value);
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Quận/huyện',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedWard,
                items: phuongxas
                    .map((px) => DropdownMenuItem<int>(
                          value: px.id,
                          child: Text(px.ten),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedWard = value);
                },
                decoration: const InputDecoration(
                  labelText: 'Phường/xã',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),
              TextField(
                  controller: _houseNumberController,
                  decoration: const InputDecoration(
                      labelText: 'Số nhà', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(
                  controller: _exactAddressController,
                  decoration: const InputDecoration(
                      labelText: 'Địa chỉ chính xác',
                      border: OutlineInputBorder())),
              const SizedBox(height: 16),
              const Text('Thông tin mô tả',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedCategory,
                items: categorys
                    .map((dm) => DropdownMenuItem<int>(
                          value: dm.id,
                          child: Text(dm.ten),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
                decoration: const InputDecoration(
                  labelText: 'Loại chuyên mục',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                      labelText: 'Tiêu đề', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickCoverImage,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_coverImage == null
                          ? 'Chọn ảnh bìa'
                          : 'Đã chọn ảnh bìa'),
                      if (_coverImage != null)
                        Image.file(_coverImage!,
                            width: 50, height: 50, fit: BoxFit.cover),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      labelText: 'Mô tả nội dung',
                      border: OutlineInputBorder())),
              // thêm một biến luu giá trị kinh độ, vĩ độ, sử dụng open stret map tạo một bản đồ và người dùng đánh dấu và nhân lưu kinh độ vĩ độ lại,
              const SizedBox(height: 16),
              const Text('Vị trí trên bản đồ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              const SizedBox(height: 8),
              SizedBox(
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(10.7769, 106.7009),
                    initialZoom: 13,
                    onTap: (tapPosition, point) {
                      setState(() {
                        _selectedLocation = point;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.yourapp',
                    ),
                    if (_selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80,
                            height: 80,
                            point: _selectedLocation!,
                            child: const Icon(Icons.location_pin,
                                size: 40, color: Colors.red),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(_selectedLocation == null
                  ? 'Chưa chọn vị trí'
                  : 'Vị trí đã chọn: ${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)}'),
              const SizedBox(height: 16),
              const Text('Thông tin liên hệ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              const SizedBox(height: 8),
              TextField(
                  readOnly: true,
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Họ tên', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(
                  readOnly: true,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      labelText: 'Điện thoại', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickAlbumImages,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_albumImages.isEmpty
                          ? 'Chọn album ảnh'
                          : 'Đã chọn ${_albumImages.length} ảnh'),
                      if (_albumImages.isNotEmpty)
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _albumImages.length > 1 ? 2 : 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Image.file(_albumImages[index],
                                    width: 50, height: 50, fit: BoxFit.cover),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Giá cho thuê (Đồng)',
                      border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(
                  controller: _areaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Diện tích (m²)',
                      border: OutlineInputBorder())),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final errors = <String>[];

                  // Validate quận/huyện và phường/xã
                  if (_selectedDistrict == null)
                    errors.add("Vui lòng chọn quận/huyện.");
                  if (_selectedWard == null)
                    errors.add("Vui lòng chọn phường/xã.");

                  // Validate địa chỉ
                  if (_houseNumberController.text.trim().isEmpty) {
                    errors.add("Vui lòng nhập số nhà.");
                  }
                  if (_exactAddressController.text.trim().isEmpty) {
                    errors.add("Vui lòng nhập địa chỉ chính xác.");
                  }

                  // Validate chuyên mục
                  if (_selectedCategory == null)
                    errors.add("Vui lòng chọn chuyên mục.");

                  // Validate tiêu đề
                  final title = _titleController.text.trim();
                  if (title.isEmpty) {
                    errors.add("Vui lòng nhập tiêu đề.");
                  } else if (title.length < 10) {
                    errors.add("Tiêu đề phải từ 10 ký tự trở lên.");
                  }

                  // Validate mô tả
                  if (_descriptionController.text.trim().isEmpty) {
                    errors.add("Vui lòng nhập mô tả nội dung.");
                  }

                  // Validate số điện thoại (nếu có)
                  final phone = _phoneController.text.trim();
                  if (phone.isNotEmpty &&
                      !RegExp(r'^0[0-9]{9}$').hasMatch(phone)) {
                    errors.add(
                        "Số điện thoại phải có 10 chữ số và bắt đầu bằng 0.");
                  }

                  // Validate giá và diện tích
                  final price = num.tryParse(_priceController.text.trim());
                  if (price == null || price < 0) {
                    errors.add("Giá cho thuê phải là số hợp lệ.");
                  }
                  final area = num.tryParse(_areaController.text.trim());
                  if (area == null || area < 0) {
                    errors.add("Diện tích phải là số hợp lệ.");
                  }

                  if (_selectedLocation == null) {
                    errors.add("Vui lòng chọn vị trí trên bản đồ.");
                  }

                  // Nếu có lỗi thì hiển thị và dừng lại
                  if (errors.isNotEmpty) {
                    final errorMessage = errors.join("\n");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  // Gọi API đăng tin
                  final result = await postProvider.updatePost(
                    idPost: widget.idPost,
                    ten: title,
                    motat: _descriptionController.text.trim(),
                    qhuyenId: _selectedDistrict!,
                    phuongxaId: _selectedWard!,
                    gia: price!.toInt(),
                    dientich: area!.toInt(),
                    danhmucId: _selectedCategory!,
                    sophong: _houseNumberController.text.trim(),
                    chitietdiachi: _exactAddressController.text.trim(),
                    map:
                        '${_selectedLocation!.longitude},${_selectedLocation!.latitude}',
                    anhdaidien: _coverImage,
                    albumFiles: _albumImages,
                  );
                  if (result['status'] == true) {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // không cho bấm ra ngoài để tắt
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: const Row(
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color: Colors.green),
                              SizedBox(width: 8),
                              Text('Thành công'),
                            ],
                          ),
                          content: const Text(
                            'Cập nhật tin thành công!\nBạn có thể xem chi tiết trong phần tin đã đăng trong mục cá nhân.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavScreen()),
                                );
                              },
                              child: const Text('Oke'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(result['message'] ?? 'Đăng tin thất bại.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cập nhật',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
