class Event {
  final int id;
  final int adminId;
  final String name;
  final String description;
  final List<String> imagePaths;
  final DateTime postedDate; // ✅ MUST be DateTime
  final String status;
  final String srcfStatus;
  final String createdAt;
  final String updatedAt;
  final String imagePath;

  Event({
    required this.id,
    required this.adminId,
    required this.name,
    required this.description,
    required this.imagePaths,
    required this.postedDate,
    required this.status,
    required this.srcfStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.imagePath,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imagePaths: (json['image_paths_url'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      postedDate: DateTime.parse(json['posted_date']), // ✅ PARSE HERE
      status: json['status'] ?? '',
      srcfStatus: json['rsvp_status'] ?? '',
      imagePath: json['image_path_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
