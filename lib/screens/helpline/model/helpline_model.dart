class HelplineCategory {
  final String name;
  final List<HelplineModel> headings;

  HelplineCategory({
    required this.name,
    required this.headings,
  });

  factory HelplineCategory.fromJson(Map<String, dynamic> json) {
    return HelplineCategory(
      name: json['name'] ?? '',
      headings: json['headings'] != null
          ? (json['headings'] as List)
              .map((item) => HelplineModel.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'headings': headings.map((item) => item.toJson()).toList(),
    };
  }
}

class HelplineModel {
  final int id;
  final int adminId;
  final String name;
  final String headingName;
  final List<String> mobileNumbers;
  final List<String> whatsappNumbers;
  final List<String> emails;
  final List<String> locations;
  final DateTime createdAt;
  final DateTime updatedAt;

  HelplineModel({
    required this.id,
    required this.adminId,
    required this.name,
    required this.headingName,
    required this.mobileNumbers,
    required this.whatsappNumbers,
    required this.emails,
    required this.locations,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HelplineModel.fromJson(Map<String, dynamic> json) {
    return HelplineModel(
      id: json['id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      name: json['name'] ?? '',
      headingName: json['heading_name'] ?? '',
      mobileNumbers: json['mobile_numbers'] != null
          ? List<String>.from(json['mobile_numbers'])
          : [],
      whatsappNumbers: json['whatsapp_numbers'] != null
          ? List<String>.from(json['whatsapp_numbers'])
          : [],
      emails: json['emails'] != null ? List<String>.from(json['emails']) : [],
      locations:
          json['locations'] != null ? List<String>.from(json['locations']) : [],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'name': name,
      'heading_name': headingName,
      'mobile_numbers': mobileNumbers,
      'whatsapp_numbers': whatsappNumbers,
      'emails': emails,
      'locations': locations,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
