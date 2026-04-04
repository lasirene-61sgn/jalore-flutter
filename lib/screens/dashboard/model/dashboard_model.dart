class BirthdayModel {
  final int id;
  final String name;
  final String mobile;
  final String? whatsapp;
  final DateTime? anniversaryDate;
  final int? villageId;
  final String? area;
  final Village? village;

  BirthdayModel({
    required this.id,
    required this.name,
    required this.mobile,
    this.whatsapp,
    this.anniversaryDate,
    this.villageId,
    this.area,
    this.village,
  });

  factory BirthdayModel.fromJson(Map<String, dynamic> json) {
    return BirthdayModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      whatsapp: json['whatsapp'],
      anniversaryDate: json['anniversary_date'] != null
          ? DateTime.tryParse(json['anniversary_date'])
          : null,
      villageId: json['village_id'],
      area: json['area'],
      village:
      json['village'] != null ? Village.fromJson(json['village']) : null,
    );
  }

  BirthdayModel copyWith({
    int? id,
    String? name,
    String? mobile,
    String? whatsapp,
    DateTime? anniversaryDate,
    int? villageId,
    String? area,
    Village? village,
  }) {
    return BirthdayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      whatsapp: whatsapp ?? this.whatsapp,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      villageId: villageId ?? this.villageId,
      area: area ?? this.area,
      village: village ?? this.village,
    );
  }
}
class Village {
  final int id;
  final String name;

  Village({
    required this.id,
    required this.name,
  });

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Village copyWith({
    int? id,
    String? name,
  }) {
    return Village(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
