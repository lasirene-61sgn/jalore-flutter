class NewsItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime publishDate;
  final String? category;

  NewsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishDate,
    this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'publishDate': publishDate.toIso8601String(),
      'category': category,
    };
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      publishDate: DateTime.parse(json['publishDate'] as String),
      category: json['category'] as String?,
    );
  }
}
