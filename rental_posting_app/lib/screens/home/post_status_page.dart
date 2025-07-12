import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/screens/home/property_detail_page.dart';
import 'package:rental_posting_app/screens/home/update_post_page.dart';

import '../../config/format_function.dart';
import '../../providers/post_status_provider.dart';
import '../payment/payment.dart';

class PostStatus {
  static const int khoiTao = 1;
  static const int hetHan = -2;
  static const int daThanhToan = 2;
  static const int dangHienThi = 3;
  static const int daAn = -1;
}

class PostDetailPage extends StatefulWidget {
  final String imageUrl;
  final String ten;
  final String address;
  final String gia;
  final String discountedPrice;
  final String updateDate;
  final String danhMuc;
  final String area; // diện tích
  final String level;
  final String? ngayKetThuc;
  final String description;
  final int star;
  final String chitietdiachi;
  final int postId;
  final String khuVuc;
  final double latitude;
  final double longitude;
  final int trangThai;
  final String? ngayBatDau;
  final String thoiGianTao;
  const PostDetailPage({
    super.key,
    required this.postId,
    required this.trangThai,
    required this.imageUrl,
    required this.ten,
    required this.address,
    required this.gia,
    required this.discountedPrice,
    required this.updateDate,
    required this.danhMuc,
    required this.area,
    required this.level,
    required this.ngayKetThuc,
    required this.description,
    required this.star,
    required this.chitietdiachi,
    required this.khuVuc,
    required this.latitude,
    required this.longitude,
    required this.ngayBatDau,
    required this.thoiGianTao,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final statusProvider =
          Provider.of<PostStatusProvider>(context, listen: false);
      statusProvider.setInitialStatus(
          widget.trangThai, widget.ngayBatDau!, widget.ngayKetThuc!);
    });
  }

  String _mapTrangThaiToText(int trangthai) {
    switch (trangthai) {
      case PostStatus.khoiTao:
        return 'Khởi tạo';
      case PostStatus.hetHan:
        return 'Hết hạn';
      case PostStatus.daThanhToan:
        return 'Đã thanh toán';
      case PostStatus.dangHienThi:
        return 'Hiển thị';
      case PostStatus.daAn:
        return 'Đã ẩn';
      default:
        return 'Không xác định';
    }
  }

  bool _switch = false;
  @override
  Widget build(BuildContext context) {
    final statusProvider = Provider.of<PostStatusProvider>(context);
    final trangThai = statusProvider.trangThaiHienTai;
    print(_switch);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  const Text(
                    'Trạng thái tin đăng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.ten,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        buildInfoRow(
                            Icons.category, "Danh mục", widget.danhMuc),
                        buildInfoRow(Icons.monetization_on, "Giá", widget.gia),
                        buildInfoRow(
                            Icons.date_range,
                            "Ngày bắt đầu",
                            _switch == false
                                ? FormatFunction.formatDate(
                                    widget.ngayBatDau ?? '')
                                : statusProvider.ngayBatDau),
                        buildInfoRow(
                            Icons.date_range_outlined,
                            "Ngày kết thúc",
                            _switch == false
                                ? FormatFunction.formatDate(
                                    widget.ngayKetThuc ?? '')
                                : statusProvider.ngayKetThuc),
                        buildInfoRow(Icons.date_range_outlined, "Ngày tạo tin",
                            FormatFunction.formatDate(widget.thoiGianTao)),
                        buildInfoRow(Icons.info_outline, "Trạng thái",
                            _mapTrangThaiToText(trangThai),
                            valueColor: FormatFunction.formatStatus(
                                statusCode: trangThai)),
                        buildInfoRow(
                            Icons.flag_outlined, "Chi tiết tin", 'Xem tin',
                            valueColor: Colors.blue, onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailScreen(
                                image: widget.imageUrl,
                                category: widget.danhMuc,
                                title: widget.ten,
                                address: widget.chitietdiachi,
                                price: widget.gia,
                                area: widget.area,
                                level: widget.level,
                                updateDate: widget.updateDate,
                                expiryDate: widget.ngayKetThuc ?? '',
                                description: widget.description,
                                idPhong: widget.postId,
                                star: widget.star,
                                khuVuc: widget.khuVuc,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          statusProvider.trangThaiHienTai == 2
                              ? "🎉 Cảm ơn bạn đã thanh toán! Tin đăng của bạn đang chờ được kiểm duyệt bởi quản trị viên. Vui lòng đợi trong giây lát..."
                              : "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 24),
                        statusProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value,
      {Color? valueColor, Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          onPressed == null
              ? Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: valueColor ?? Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: onPressed,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: valueColor ?? Colors.black87,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ))
        ],
      ),
    );
  }

  Widget buildActionButtons() {
    final statusProvider = Provider.of<PostStatusProvider>(context);
    final trangThai = statusProvider.trangThaiHienTai;
    List<Widget> buttons = [];

    void goToThanhToan() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Payment(postId: widget.postId),
        ),
      );

      if (result == true) {
        await statusProvider.updateTrangThai(postId: widget.postId, status: 2);
        setState(() {
          _switch = true;
        });
      }
    }

    if (trangThai == PostStatus.khoiTao) {
      buttons.addAll([
        ElevatedButton.icon(
          onPressed: goToThanhToan,
          icon: const Icon(
            Icons.payment,
            color: Colors.white,
          ),
          label: const Text(
            "Thanh toán tin",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            await statusProvider.updateTrangThai(
              postId: widget.postId,
              status: PostStatus.dangHienThi,
            );
          },
          icon: const Icon(
            Icons.visibility,
            color: Colors.white,
          ),
          label: const Text(
            "Hiển thị tin",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdatePostPage(
                        idPost: widget.postId,
                      )),
            );
          },
          icon: const Icon(Icons.edit),
          label: const Text("Chỉnh sửa"),
        ),
      ]);
    }

    if (trangThai == PostStatus.hetHan) {
      buttons.addAll([
        ElevatedButton.icon(
          onPressed: goToThanhToan,
          icon: const Icon(
            Icons.payment,
            color: Colors.white,
          ),
          label: const Text(
            "Thanh toán tin",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        ),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdatePostPage(
                        idPost: widget.postId,
                      )),
            );
          },
          icon: const Icon(Icons.edit),
          label: const Text("Chỉnh sửa"),
        ),
      ]);
    }

    if (trangThai == PostStatus.dangHienThi) {
      buttons.add(
        ElevatedButton.icon(
          onPressed: () async {
            await statusProvider.updateTrangThai(
              postId: widget.postId,
              status: PostStatus.khoiTao,
            );
          },
          icon: const Icon(Icons.visibility_off),
          label: const Text("Ẩn tin"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: buttons,
    );
  }
}
