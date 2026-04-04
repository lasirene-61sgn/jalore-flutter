class News {
  final int id;
  final int adminId;
  final String title;
  final String slug;
  final String imagePath;
  final String author;
  final String keywords;
  final String summary;
  final DateTime postedDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  News({
    required this.id,
    required this.adminId,
    required this.title,
    required this.slug,
    required this.imagePath,
    required this.author,
    required this.keywords,
    required this.summary,
    required this.postedDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int,
      adminId: json['admin_id'] as int,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      imagePath: json['image_path_url'] ?? '',
      author: json['author'] ?? '',
      keywords: json['keywords'] ?? '',
      summary: json['summary'] ?? '',
      postedDate: DateTime.parse(json['posted_date']),
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'title': title,
      'slug': slug,
      'image_path': imagePath,
      'author': author,
      'keywords': keywords,
      'summary': summary,
      'posted_date': postedDate.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
