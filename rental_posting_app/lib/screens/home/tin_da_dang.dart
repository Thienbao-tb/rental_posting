import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/config/format_function.dart';
import 'package:rental_posting_app/providers/auth_provider.dart';
import 'package:rental_posting_app/screens/home/post_status_page.dart';

import '../../config/api_config.dart';
import '../../providers/get_post_byUser_provider.dart';
import '../../providers/post_status_provider.dart';

class TinDaDang extends StatefulWidget {
  const TinDaDang({super.key});

  @override
  State<TinDaDang> createState() => _TinDaDangState();
}

class _TinDaDangState extends State<TinDaDang> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();

      // Đợi đến khi user != null thì mới gọi API lấy bài đăng
      while (authProvider.user == null) {
        await Future.delayed(Duration(milliseconds: 100));
      }

      final userId = authProvider.user!.id;
      context.read<GetPostByUserProvider>().fetchInitialPosts(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<GetPostByUserProvider>();
    final listPosts = postProvider.posts;
    String _mapTrangThaiToText(int trangthai) {
      switch (trangthai) {
        case 1:
          return 'Khởi tạo';
        case -2:
          return 'Hết hạn';
        case 2:
          return 'Đã thanh toán';
        case 3:
          return 'Hiển thị';
        case -1:
          return 'Đã huỷ';
        default:
          return 'Khác';
      }
    }

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
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Danh sách tin đã đăng',
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
              child: Container(
                color: Colors.blue[50],
                child: listPosts.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: listPosts.length,
                        itemBuilder: (context, index) {
                          final post = listPosts[index];
                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) => PostStatusProvider(),
                                    child: PostDetailPage(
                                      imageUrl: post.anhdaidien != null
                                          ? FormatFunction.buildAvatarUrl(
                                              post.anhdaidien ?? "")
                                          : "${ApiConfig.baseUrl}/images/news-1.jpg",
                                      ten: post.ten ?? '',
                                      address: post.city?.ten ?? '',
                                      gia: post.gia.toString(),
                                      discountedPrice: "",
                                      updateDate: FormatFunction.formatDate(
                                          post.createdAt.toString()),
                                      danhMuc: post.category.ten,
                                      area: post.khuvuc.toString(),
                                      level: "#${post.id}",
                                      ngayBatDau: post.thoigian_batdau ?? '',
                                      ngayKetThuc: FormatFunction.formatDate(
                                          post.thoigian_ketthuc ?? ''),
                                      description: post.mota ?? "",
                                      star: post.dichvu_hot,
                                      chitietdiachi: post.chitietdiachi ?? "",
                                      khuVuc:
                                          "${post.wards?.ten} / ${post.district?.ten}",
                                      latitude: FormatFunction.parseCoordinates(
                                              post.map ?? '')
                                          .latitude,
                                      longitude:
                                          FormatFunction.parseCoordinates(
                                                  post.map ?? '')
                                              .longitude,
                                      postId: post.id,
                                      thoiGianTao: post.createdAt!,
                                      trangThai: post.trangthai,
                                    ),
                                  ),
                                ),
                              );

                              if (result == true) {
                                final authProvider =
                                    context.read<AuthProvider>();

                                // Đợi user != null rồi mới fetch lại
                                while (authProvider.user == null) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
                                }

                                final userId = authProvider.user!.id;
                                context
                                    .read<GetPostByUserProvider>()
                                    .fetchInitialPosts(userId);
                              }
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        post.anhdaidien != null
                                            ? FormatFunction.buildAvatarUrl(
                                                post.anhdaidien!)
                                            : "${ApiConfig.baseUrl}/images/news-1.jpg",
                                        width: 126,
                                        height: 155,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                post.category.ten,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              post.ten ?? '',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    FormatFunction.formatTitle(
                                                        post.dichvu_hot),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            _buildInfoRow(
                                                'Giá: ',
                                                FormatFunction.formatPrice(
                                                    post.gia)),
                                            _buildInfoRow(
                                                'Ngày bắt đầu: ',
                                                FormatFunction.formatDate(
                                                    post.thoigian_batdau ??
                                                        '')),
                                            _buildInfoRow(
                                                'Ngày kết thúc: ',
                                                FormatFunction.formatDate(
                                                    post.thoigian_ketthuc ??
                                                        '')),
                                            _buildInfoRow(
                                                'Trạng thái: ',
                                                _mapTrangThaiToText(
                                                    post.trangthai),
                                                color:
                                                    FormatFunction.formatStatus(
                                                        statusCode:
                                                            post.trangthai)),
                                            _buildInfoRow(
                                                'Ngày tạo: ',
                                                FormatFunction.formatDate(
                                                    post.createdAt ?? '')),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoRow(String label, String value, {Color color = Colors.black}) {
  return RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 14, color: Colors.black),
      children: [
        TextSpan(
          text: label,
          style: const TextStyle(color: Colors.grey),
        ),
        TextSpan(
          text: value,
          style: TextStyle(color: color),
        ),
      ],
    ),
  );
}
