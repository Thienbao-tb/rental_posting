class DetailImage {
  final String duongdan;
  DetailImage({required this.duongdan});
  factory DetailImage.fromJson(Map<String, dynamic> json) {
    return DetailImage(
      duongdan: json['duongdan'],
    );
  }
}
