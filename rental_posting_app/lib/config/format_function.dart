import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'api_config.dart';

class FormatFunction {
  static String formatPrice(dynamic amount) {
    try {
      int value = amount is String ? int.parse(amount) : amount;
      final formatter = NumberFormat.currency(
          locale: 'vi_VN', symbol: 'VNĐ', decimalDigits: 0);
      return formatter.format(value);
    } catch (_) {
      return '0 VNĐ';
    }
  }

  static String buildAvatarUrl(String fileName) {
    final datePart = fileName.split('__').first.split('-');
    if (datePart.length < 3) return ''; // Không hợp lệ
    final year = datePart[0];
    final month = datePart[1];
    final day = datePart[2];
    return '${ApiConfig.baseUrl}/uploads/$year/$month/$day/$fileName';
  }

  static String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return 'Chưa gia hạn tin';
    }
  }

  static Color formatTitle(int dichvu_hot) {
    if (dichvu_hot == 5) {
      return const Color(0xfffb2c36);
    } else if (dichvu_hot == 4) {
      return const Color(0xfff6339a);
    } else if (dichvu_hot == 3) {
      return const Color(0xffff5723);
    } else if (dichvu_hot == 2) {
      return const Color(0xff155dfc);
    } else {
      return const Color(0xff0e4db3);
    }
  }

  static Widget formatPostType(int dichvu_hot) {
    if (dichvu_hot == 5) {
      return const Text(
        "Tin VIP Nổi Bật",
        style: TextStyle(
            color: Color(0xfffb2c36),
            fontSize: 14,
            fontWeight: FontWeight.w500),
      );
    } else if (dichvu_hot == 4) {
      return const Text(
        "Tin VIP 1",
        style: TextStyle(
            color: Color(0xfff6339a),
            fontSize: 14,
            fontWeight: FontWeight.w500),
      );
    } else if (dichvu_hot == 3) {
      return const Text(
        "Tin VIP 2",
        style: TextStyle(
            color: Color(0xffff5723),
            fontSize: 14,
            fontWeight: FontWeight.w500),
      );
    } else if (dichvu_hot == 2) {
      return const Text(
        "Tin VIP 3",
        style: TextStyle(
            color: Color(0xff155dfc),
            fontSize: 14,
            fontWeight: FontWeight.w500),
      );
    } else {
      return const Text(
        "Tin thường",
        style: TextStyle(
            color: Color(0xff0e4db3),
            fontSize: 14,
            fontWeight: FontWeight.w500),
      );
    }
  }

  static LatLng parseCoordinates(String input) {
    final parts = input.split(',');
    if (parts.length != 2) {
      throw FormatException("Không đúng định dạng: latitude,longitude");
    }

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());

    if (lat == null ||
        lng == null ||
        lat.isNaN ||
        lng.isNaN ||
        !lat.isFinite ||
        !lng.isFinite) {
      throw FormatException(
          "Toạ độ không hợp lệ hoặc không thể chuyển đổi sang số thực");
    }

    return LatLng(lat, lng);
  }

  static Color formatStatus({int statusCode = 0}) {
    if (statusCode == 1) {
      return const Color(0xff6c757d);
    } else if (statusCode == 2) {
      return const Color(0xff007bff);
    } else if (statusCode == -2) {
      return const Color(0xffdc3545);
    } else if (statusCode == 3) {
      return const Color(0xff28a745);
    } else if (statusCode == -1) {
      return const Color(0xff6c757d).withOpacity(0.6);
    } else {
      return const Color(0xff6c757d);
    }
  }

  static Widget buildCustomAppBar({
    required String title,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: onPressed,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

}
