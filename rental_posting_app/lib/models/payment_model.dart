class Payment {
  final int id;
  final int nguoidungId;
  final int loai;
  final int phongId;
  final int dichvuId;
  final int tien;
  final int trangthai;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.nguoidungId,
    required this.loai,
    required this.phongId,
    required this.dichvuId,
    required this.tien,
    required this.trangthai,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      nguoidungId: json['nguoidung_id'],
      loai: json['loai'],
      phongId: json['phong_id'],
      dichvuId: json['dichvu_id'],
      tien: json['tien'],
      trangthai: json['trangthai'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nguoidung_id': nguoidungId,
      'loai': loai,
      'phong_id': phongId,
      'dichvu_id': dichvuId,
      'tien': tien,
      'trangthai': trangthai,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
