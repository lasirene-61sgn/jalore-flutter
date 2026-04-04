class GalleryModel {
  final int id;
  final int adminId;
  final String title;
  final String description;
  final List<String> imagePaths;
  final List<String> imagePathsurls;
  final String status;
  final List<String> videoPaths;
  final List<String> videoPathsurls;
  final DateTime createdAt;
  final DateTime updatedAt;

  GalleryModel({
    required this.id,
    required this.adminId,
    required this.title,
    required this.description,
    required this.imagePaths,
    required this.imagePathsurls,
    required this.status,
    required this.videoPaths,
    required this.videoPathsurls,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      id: json['id'],
      adminId: json['admin_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imagePaths: json['image_paths'] != null
          ? List<String>.from(json['image_paths'])
          : [],
      imagePathsurls: json['image_paths_url'] != null
          ? List<String>.from(json['image_paths_url'])
          : [],
      status: json['status'] ?? '',
      videoPaths: json['video_paths'] != null
          ? List<String>.from(json['video_paths'])
          : [],
      videoPathsurls: json['video_paths_url'] != null
          ? List<String>.from(json['video_paths_url'])
          : [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'title': title,
      'description': description,
      'image_paths': imagePaths,
      'image_paths_url': imagePathsurls,
      'status': status,
      'video_paths': videoPaths,
      'video_paths_url': videoPathsurls,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
