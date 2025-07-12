class PostResponse {
  final List<Post> posts;
  final int total;

  PostResponse({required this.posts, required this.total});

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      posts:
          (json['posts'] as List).map((post) => Post.fromJson(post)).toList(),
      total: json['total'] ?? 0,
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
      data: List<Post>.from(json['data'].map((x) => Post.fromJson(x))),
    );
  }
}

class Post {
  final int id;
  final String? ten;
  final String? slug;
  final String? anhdaidien;
  final String? mota;
  final int gia;
  final int khoanggia;
  final int khoangkhuvuc;
  final int trangthai;
  final int khuvuc;
  final String? sophong;
  final String? chitietdiachi;
  final String noidung;
  final int hot;
  final String? lydo;
  final Category category;
  final String? thoigian_batdau;
  final String? thoigian_ketthuc;
  final String xacthuc_id;
  final int dichvu_hot;
  final String? map;
  final int subject_id;
  final String? video_link;
  final District? district;
  final Wards? wards;
  final City? city;
  final String? createdAt;
  final String? updated_at;

  Post({
    required this.id,
    this.ten,
    this.slug,
    this.anhdaidien,
    this.mota,
    required this.gia,
    required this.khoanggia,
    required this.khoangkhuvuc,
    required this.trangthai,
    required this.khuvuc,
    this.sophong,
    this.chitietdiachi,
    required this.noidung,
    required this.hot,
    this.lydo,
    required this.category,
    this.thoigian_batdau,
    this.thoigian_ketthuc,
    required this.xacthuc_id,
    required this.dichvu_hot,
    this.map,
    required this.subject_id,
    this.video_link,
    this.district,
    this.wards,
    this.city,
    this.createdAt,
    this.updated_at,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      ten: json['ten'],
      slug: json['slug'],
      anhdaidien: json['anhdaidien'],
      mota: json['mota'],
      gia: json['gia'] ?? 0,
      khoanggia: json['khoanggia'] ?? 0,
      khoangkhuvuc: json['khoangkhuvuc'] ?? 0,
      trangthai: json['trangthai'] ?? 0,
      khuvuc: json['khuvuc'] ?? 0,
      sophong: json['sophong'],
      chitietdiachi: json['chitietdiachi'],
      noidung: json['noidung'] ?? '',
      hot: json['hot'] ?? 0,
      lydo: json['lydo'],
      category: Category.fromJson(json['category']),
      thoigian_batdau: json['thoigian_batdau'],
      thoigian_ketthuc: json['thoigian_ketthuc'],
      xacthuc_id: json['xacthuc_id'].toString(),
      dichvu_hot: json['dichvu_hot'],
      map: json['map'],
      subject_id: json['subject_id'] ?? 0,
      video_link: json['video_link'],
      district:
          json['district'] != null ? District.fromJson(json['district']) : null,
      wards: json['wards'] != null ? Wards.fromJson(json['wards']) : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      createdAt: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}

class Category {
  final int id;
  final String ten;
  final String slug;

  Category({
    required this.id,
    required this.ten,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      ten: json['ten'],
      slug: json['slug'],
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

class Wards {
  final int id;
  final String ten;

  Wards({
    required this.id,
    required this.ten,
  });

  factory Wards.fromJson(Map<String, dynamic> json) {
    return Wards(
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
