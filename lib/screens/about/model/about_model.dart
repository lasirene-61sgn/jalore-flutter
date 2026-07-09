class AboutModel {
  final String? description;
  final String? vision;
  final String? mission;
  final String? imagePath;

  AboutModel({
    this.description,
    this.vision,
    this.mission,
    this.imagePath,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      description: json['description'] as String?,
      vision: json['vision'] as String?,
      mission: json['mission'] as String?,
      imagePath: json['image_path'] as String?,
    );
  }
}
