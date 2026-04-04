class Category {
  final int id;
  final String categoryName;

  Category({
    required this.id,
    required this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      categoryName: json['category_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
    };
  }

  Category copyWith({
    int? id,
    String? categoryName,
  }) {
    return Category(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
