class Location {
  final int id;
  final String ten;
  final String slug;
  final String? tieude;
  final String? mota;
  final String? anhdaidien;
  final int trangthai;
  final int hot;
  final int parentId;
  final int loai;
  final String? createdAt;
  final String? updatedAt;
  final int roomsCount;

  Location({
    required this.id,
    required this.ten,
    required this.slug,
    this.tieude,
    this.mota,
    this.anhdaidien,
    required this.trangthai,
    required this.hot,
    required this.parentId,
    required this.loai,
    this.createdAt,
    this.updatedAt,
    required this.roomsCount,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      ten: json['ten'],
      slug: json['slug'],
      tieude: json['tieude'],
      mota: json['mota'],
      anhdaidien: json['anhdaidien'],
      trangthai: json['trangthai'] ?? 0,
      hot: json['hot'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      loai: json['loai'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      roomsCount: json['rooms_count'] ?? 0,
    );
  }
}
