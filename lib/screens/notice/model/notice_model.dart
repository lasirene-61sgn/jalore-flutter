class Notice {
  final int id;
  final int adminId;
  final String name;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notice({
    required this.id,
    required this.adminId,
    required this.name,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as int,
      adminId: json['admin_id'] as int,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'name': name,
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
