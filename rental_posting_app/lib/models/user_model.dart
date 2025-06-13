class User {
  final int id;
  final String ten;
  final String email;
  final String sodienthoai;
  final String? facebook;
  final String? anhdaidien;
  final int sodukhadung;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.ten,
    required this.email,
    required this.sodienthoai,
    this.facebook,
    this.anhdaidien,
    required this.sodukhadung,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      ten: json['ten'] ?? '',
      email: json['email'] ?? '',
      sodienthoai: json['sodienthoai'] ?? '',
      facebook: json['facebook'] as String?,
      anhdaidien: json['anhdaidien'] as String?,
      sodukhadung: json['sodukhadung'] ?? 0,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
