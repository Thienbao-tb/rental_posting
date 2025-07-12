class RechargeHistory {
  final int id;
  final String ma;
  final int nguoidungId;
  final int loai;
  final int tien;
  final int giamgia;
  final int tongtien;
  final int trangthai;
  final DateTime createdAt;
  final DateTime updatedAt;

  RechargeHistory({
    required this.id,
    required this.ma,
    required this.nguoidungId,
    required this.loai,
    required this.tien,
    required this.giamgia,
    required this.tongtien,
    required this.trangthai,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RechargeHistory.fromJson(Map<String, dynamic> json) {
    return RechargeHistory(
      id: json['id'],
      ma: json['ma'],
      nguoidungId: json['nguoidung_id'],
      loai: json['loai'],
      tien: json['tien'],
      giamgia: json['giamgia'],
      tongtien: json['tongtien'],
      trangthai: json['trangthai'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ma': ma,
      'nguoidung_id': nguoidungId,
      'loai': loai,
      'tien': tien,
      'giamgia': giamgia,
      'tongtien': tongtien,
      'trangthai': trangthai,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
