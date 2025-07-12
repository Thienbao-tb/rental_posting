import 'package:flutter/material.dart';

class BangGiaScreen extends StatelessWidget {
  const BangGiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(Icons.arrow_back, color: Colors.blue),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Bảng giá tin đăng',
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
              child: const SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PricingCard(
                          title: 'TIN NỔI BẬT',
                          advantages: [
                            'Lượt xem nhiều gấp 50 lần so với tin thường',
                            'Tiếp cận nhiều khách hàng',
                            'Xuất hiện vị trí nổi bật trên trang chủ',
                            'Hiển thị tại tất cả các loại tin rao',
                            'Nổi bật tiêu đề tin ở mục tin mới nhất xuyên suốt khu vực chuyên mục.',
                          ],
                          suitableFor:
                              'Phù hợp khách hàng có nhu cầu tiếp cận nhanh chóng nhiều người xem, cần bán hoặc cho thuê nhanh.',
                          dailyPrice: '80.000đ\n(Tối thiểu 3 ngày)',
                          weeklyPrice: '560.000đ',
                          titleTextColor: Color(0xfffb2c36),
                          adminApprovalRequired: true,
                          highlightTitle: true,
                        ),
                        SizedBox(width: 16.0),
                        PricingCard(
                          title: 'TIN VIP 1',
                          advantages: [
                            'Lượt xem nhiều gấp 10 lần so với tin thường',
                            'Tiếp cận một nhiều khách hàng',
                            'Xuất hiện sau VIP 2, VIP 3, tin thường',
                            'Xuất hiện thêm ở mục tin nổi bật xuyên suốt khu vực chuyên mục.',
                          ],
                          suitableFor:
                              'Phù hợp khách hàng muốn tăng trưởng lượng truy cập, cần cho thuê nhanh.',
                          dailyPrice: '30.000đ\n(Tối thiểu 3 ngày)',
                          weeklyPrice: '210.000đ',
                          titleTextColor: Color(0xfff6339a),
                          adminApprovalRequired: false,
                          highlightTitle: false,
                        ),
                        SizedBox(width: 16.0),
                        PricingCard(
                          title: 'TIN VIP 2',
                          advantages: [
                            'Lượt xem nhiều gấp 5 lần so với tin thường',
                            'Tiếp cận khách hàng tốt',
                            'Xuất hiện sau VIP 3 và trước tin thường',
                            'Xuất hiện thêm ở mục tin nổi bật xuyên suốt khu vực chuyên mục.',
                          ],
                          suitableFor:
                              'Phù hợp khách hàng cần số lượng tương tác ổn định, cần cho thuê nhanh hơn.',
                          dailyPrice: '20.000đ\n(Tối thiểu 3 ngày)',
                          weeklyPrice: '140.000đ',
                          titleTextColor: Color(0xffff5723),
                          adminApprovalRequired: false,
                          highlightTitle: false,
                        ),
                        SizedBox(width: 16.0),
                        PricingCard(
                          title: 'TIN VIP 3',
                          advantages: [
                            'Lượt xem nhiều gấp 3 lần so với tin thường',
                            'Tiếp cận khách hàng tốt',
                            'Xuất hiện sau tin thường',
                          ],
                          suitableFor:
                              'Phù hợp khách hàng muốn tăng trưởng nhẹ lượng truy cập, cần cho thuê nhanh, cần bán nhanh hơn.',
                          dailyPrice: '15.000đ\n(Tối thiểu 3 ngày)',
                          weeklyPrice: '105.000đ',
                          titleTextColor: Color(0xff155dfc),
                          adminApprovalRequired: false,
                          highlightTitle: false,
                        ),
                        SizedBox(width: 16.0),
                        PricingCard(
                          title: 'TIN THƯỜNG',
                          advantages: [
                            'Lượt xem nhiều gấp 1 lần so với tin thường',
                            'Tiếp cận khách hàng tốt',
                            'Xuất hiện sau VIP 3 và trước tin thường.',
                          ],
                          suitableFor:
                              'Phù hợp tất cả các loại hình đăng tin (bán, cho thuê) thường xuyên và cho thuê chậm hơn.',
                          dailyPrice: '2.000đ\n(Tối thiểu 3 ngày)',
                          weeklyPrice: '14.000đ',
                          titleTextColor: Color(0xff0e4db3),
                          adminApprovalRequired: false,
                          highlightTitle: false,
                        ),
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
}

class PricingCard extends StatelessWidget {
  final String title;
  final List<String> advantages;
  final String suitableFor;
  final String dailyPrice;
  final String weeklyPrice;
  final Color titleTextColor;
  final bool adminApprovalRequired;
  final bool highlightTitle;

  const PricingCard({
    super.key,
    required this.title,
    required this.advantages,
    required this.suitableFor,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.titleTextColor,
    this.adminApprovalRequired = false,
    this.highlightTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: titleTextColor,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Ưu điểm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            for (var advantage in advantages)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, color: Colors.green, size: 20.0),
                    const SizedBox(width: 4.0),
                    Expanded(child: Text(advantage)),
                  ],
                ),
              ),
            const SizedBox(height: 8.0),
            const Text(
              'Phù hợp',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(suitableFor),
            const SizedBox(height: 12.0),
            const Text(
              'Giá ngày',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(dailyPrice),
            const SizedBox(height: 8.0),
            const Text(
              'Giá tuần',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(weeklyPrice),
            const SizedBox(height: 12.0),
            const Text(
              'Màu sắc tiêu đề',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              _getTitleColorText(titleTextColor),
              style: TextStyle(color: titleTextColor),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Admin duyệt bài',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(adminApprovalRequired ? 'có' : 'không'),
            const SizedBox(height: 8.0),
            const Text(
              'Huy hiệu nổi bật',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(highlightTitle ? 'có' : 'không'),
          ],
        ),
      ),
    );
  }

  String _getTitleColorText(Color color) {
    if (color == Colors.red) return 'TIÊU ĐỀ MÀU ĐỎ, IN HOA';
    if (color == Colors.blue) return 'TIÊU ĐỀ MÀU XANH, IN HOA';
    if (color == Colors.green) return 'TIÊU ĐỀ MÀU LỤC, IN HOA';
    if (color == Colors.orange) return 'TIÊU ĐỀ MÀU CAM, IN HOA';
    return 'TIÊU ĐỀ MÀU XÁM, IN HOA';
  }
}
