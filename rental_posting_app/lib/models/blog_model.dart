class Blog {
  final int id;
  final int menuId;
  final String ten;
  final String slug;
  final String mota;
  final String anhdaidien;
  final String noidung;
  final DateTime createdAt;
  final DateTime updatedAt;

  Blog({
    required this.id,
    required this.menuId,
    required this.ten,
    required this.slug,
    required this.mota,
    required this.anhdaidien,
    required this.noidung,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      menuId: json['menu_id'],
      ten: json['ten'],
      slug: json['slug'],
      mota: json['mota'],
      anhdaidien: json['anhdaidien'],
      noidung: json['noidung'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_id': menuId,
      'ten': ten,
      'slug': slug,
      'mota': mota,
      'anhdaidien': anhdaidien,
      'noidung': noidung,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
