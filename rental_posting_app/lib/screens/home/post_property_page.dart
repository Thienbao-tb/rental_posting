import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostPropertyPage extends StatefulWidget {
  const PostPropertyPage({super.key});

  @override
  State<PostPropertyPage> createState() => _PostPropertyPageState();
}

class _PostPropertyPageState extends State<PostPropertyPage> {
  // Controllers cho các TextField
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _exactAddressController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController =
      TextEditingController(text: 'Vũ Tuấn Anh');
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  // Giá trị dropdown
  String? _selectedDistrict;
  String? _selectedWard;
  String? _selectedCategory;

  // Danh sách giả lập cho dropdown
  final List<String> districts = [
    'Quận Ninh Kiều',
    'Quận Bình Thủy',
    'Quận Cái Răng'
  ];
  final List<String> wards = [
    'Phường An Hòa',
    'Phường An Bình',
    'Phường Cái Khế'
  ];
  final List<String> categories = [
    'Cho thuê nhà trọ',
    'Nhà cho thuê',
    'Ở ghép',
    'Một bề bằng'
  ];

  // Biến để lưu ảnh bìa và album ảnh
  File? _coverImage;
  List<File> _albumImages = [];

  // ImagePicker instance
  final ImagePicker _picker = ImagePicker();

  // Hàm chọn ảnh bìa
  Future<void> _pickCoverImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _coverImage = File(image.path);
      });
    }
  }

  // Hàm chọn ảnh cho album (nhiều ảnh)
  Future<void> _pickAlbumImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _albumImages = images.map((image) => File(image.path)).toList();
      });
    }
  }

  @override
  void dispose() {
    // Giải phóng các controller
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.blue),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Thêm mới',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Thông báo
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.yellow[100],
                  child: const Text(
                    'Nếu bạn đã từng đăng tin trên canthohostel.com, hãy sử dụng chức năng ĐẨY TIN/ GIA HẠN/ NÂNG CẤP VIP trong mục QUẢN LÝ TIN ĐĂNG để làm mới, đẩy tin lên cao thay vì đăng tin mới. Tin đăng trùng lặp sẽ không được duyệt.',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 16),
                // Địa chỉ cho thuê
                const Text(
                  'Địa chỉ cho thuê',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Quận/huyện',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedDistrict,
                  items: districts.map((district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(district),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDistrict = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Phường/xã',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedWard,
                  items: wards.map((ward) {
                    return DropdownMenuItem<String>(
                      value: ward,
                      child: Text(ward),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedWard = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _houseNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Số nhà',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _exactAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ chính xác',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Thông tin mô tả
                const Text(
                  'Thông tin mô tả',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Loại chuyên mục',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickCoverImage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _coverImage == null
                              ? 'Chọn ảnh bìa'
                              : 'Đã chọn ảnh bìa',
                          style: TextStyle(
                            color: _coverImage == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        if (_coverImage != null)
                          Image.file(
                            _coverImage!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả nội dung',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bản đồ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'Bản đồ (Chưa triển khai)',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Thông tin liên hệ
                const Text(
                  'Thông tin liên hệ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Họ tên',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickAlbumImages,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _albumImages.isEmpty
                              ? 'Chọn album ảnh'
                              : 'Đã chọn ${_albumImages.length} ảnh',
                          style: TextStyle(
                            color: _albumImages.isEmpty
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
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
                                  child: Image.file(
                                    _albumImages[index],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
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
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Giá cho thuê (Đồng)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _areaController,
                  decoration: const InputDecoration(
                    labelText: 'Diện tích (m²)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                // Nút Đăng tin
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Kiểm tra dữ liệu trước khi đăng tin
                      if (_selectedDistrict == null ||
                          _selectedWard == null ||
                          _houseNumberController.text.isEmpty ||
                          _exactAddressController.text.isEmpty ||
                          _selectedCategory == null ||
                          _titleController.text.isEmpty ||
                          _coverImage == null ||
                          _descriptionController.text.isEmpty ||
                          _nameController.text.isEmpty ||
                          _phoneController.text.isEmpty ||
                          _priceController.text.isEmpty ||
                          _areaController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Vui lòng điền đầy đủ thông tin và chọn ảnh bìa!')),
                        );
                        return;
                      }

                      // Logic xử lý đăng tin (chưa triển khai)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Tin đã được đăng thành công!')),
                      );
                      Navigator.pop(
                          context); // Quay lại trang trước sau khi đăng tin
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
                        Text(
                          'Đăng tin',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
