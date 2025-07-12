import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/post_payment_provider.dart';

class Payment extends StatefulWidget {
  final int postId;

  const Payment({super.key, required this.postId});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final List<Map<String, dynamic>> postTypes = [
    {'label': 'TIN THƯỜNG (2.000đ/ngày)', 'value': 1, 'price': 2000},
    {'label': 'TIN VIP 3 (20.000đ/ngày)', 'value': 2, 'price': 20000},
    {'label': 'TIN VIP 2 (30.000đ/ngày)', 'value': 3, 'price': 30000},
    {'label': 'TIN VIP 1 (50.000đ/ngày)', 'value': 4, 'price': 50000},
    {'label': 'TIN NỔI BẬT (80.000đ/ngày)', 'value': 5, 'price': 80000},
  ];
  final List<int> daysOptions = List.generate(16, (index) => index + 5);

  int selectedRoomType = 1;
  int selectedDays = 5;
  DateTime? selectedDate;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateAmount();
  }

  void _updateAmount() {
    final selectedType =
        postTypes.firstWhere((type) => type['value'] == selectedRoomType);
    final total = selectedType['price'] * selectedDays;
    amountController.text =
        NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0)
                .format(total) +
            'đ';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _handlePayment() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày bắt đầu')),
      );
      return;
    }

    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
    final provider = Provider.of<PostPaymentProvider>(context, listen: false);

    await provider.payForPost(
      postId: widget.postId,
      roomType: selectedRoomType,
      day: selectedDays,
      startDate: formattedDate,
    );

    if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    } else {
      final result = provider.paymentResult!;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Thanh toán thành công"),
          content: Text("Tin đã được kích hoạt đến ${result['end_date']}"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // đóng dialog
                Navigator.of(context)
                    .pop(true); // đóng Payment & báo thành công
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                    'Thanh toán tin',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.yellow[100],
                      child: const Text(
                        'Nội dung tin đăng không được chứa website, hoặc số\n'
                        'điện thoại, nếu đăng vi phạm sẽ bị xóa ngay lập tức\n'
                        'trong mọi trường hợp. QUAN TRỌNG ĐẦU TIÊN là mỗi tin\n'
                        'đăng chỉ được đăng 1 lần, mọi đăng trùng nhau đều\n'
                        'bị xóa ngay lập tức. Tin đăng trong nhu cầu sẽ khó '
                        'được duyệt.\n\n'
                        'XIN CẢM ƠN!',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Chọn loại tin:',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: selectedRoomType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                      items: postTypes.map((type) {
                        return DropdownMenuItem<int>(
                          value: type['value'],
                          child: Text(type['label']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRoomType = value!;
                          _updateAmount();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Số ngày:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: selectedDays,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                      items: daysOptions.map((day) {
                        return DropdownMenuItem<int>(
                          value: day,
                          child: Text('$day ngày'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDays = value!;
                          _updateAmount();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Ngày bắt đầu:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    TextFormField(
                      readOnly: true,
                      controller: dateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        hintText: 'dd/MM/yyyy',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),
                    const Text('Thành tiền:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    TextFormField(
                      readOnly: true,
                      controller: amountController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        icon: const Icon(Icons.payment),
                        label: const Text(
                          'THANH TOÁN',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: _handlePayment,
                      ),
                    ),
                    const SizedBox(height: 100),
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
