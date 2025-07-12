class Category {
  final int id;
  final String ten;
  final String slug;
  final String? tieude;
  final String mota;
  final int trangthai;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.ten,
    required this.slug,
    this.tieude,
    required this.mota,
    required this.trangthai,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      ten: json['ten'],
      slug: json['slug'],
      tieude: json['tieude'],
      mota: json['mota'],
      trangthai: json['trangthai'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': ten,
      'slug': slug,
      'tieude': tieude,
      'mota': mota,
      'trangthai': trangthai,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
