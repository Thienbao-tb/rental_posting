class PostResponse {
  final bool status;
  final String message;
  final PostPagination posts;

  PostResponse({
    required this.status,
    required this.message,
    required this.posts,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      status: json['status'],
      message: json['message'],
      posts: PostPagination.fromJson(json['posts']),
    );
  }
}

class PostPagination {
  final int currentPage;
  final List<Post> data;

  PostPagination({
    required this.currentPage,
    required this.data,
  });

  factory PostPagination.fromJson(Map<String, dynamic> json) {
    return PostPagination(
      currentPage: json['current_page'],
      data: (json['data'] as List).map((e) => Post.fromJson(e)).toList(),
    );
  }
}

class Post {
  final int id;
  final String ten;
  final String? slug;
  final String? anhdaidien;
  final String? mota;
  final int? qhuyenId;
  final int? phuongxaId;
  final int? gia;
  final Category? category;
  final District? district;
  final Ward? wards;
  final City? city;

  Post({
    required this.id,
    required this.ten,
    this.slug,
    this.anhdaidien,
    this.mota,
    this.qhuyenId,
    this.phuongxaId,
    this.gia,
    this.category,
    this.district,
    this.wards,
    this.city,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      ten: json['ten'],
      slug: json['slug'],
      anhdaidien: json['anhdaidien'],
      mota: json['mota'],
      qhuyenId: json['qhuyen_id'],
      phuongxaId: json['phuongxa_id'],
      gia: json['gia'],
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      district:
          json['district'] != null ? District.fromJson(json['district']) : null,
      wards: json['wards'] != null ? Ward.fromJson(json['wards']) : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
    );
  }
}

class Category {
  final int id;
  final String ten;
  final String? mota;

  Category({
    required this.id,
    required this.ten,
    this.mota,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      ten: json['ten'],
      mota: json['mota'],
    );
  }
}

class District {
  final int id;
  final String ten;

  District({
    required this.id,
    required this.ten,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      ten: json['ten'],
    );
  }
}

class Ward {
  final int id;
  final String ten;

  Ward({
    required this.id,
    required this.ten,
  });

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: json['id'],
      ten: json['ten'],
    );
  }
}

class City {
  final int id;
  final String ten;

  City({
    required this.id,
    required this.ten,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      ten: json['ten'],
    );
  }
}
