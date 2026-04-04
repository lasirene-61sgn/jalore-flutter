class FamilyMember {
  final int id;
  final int customerId;
  final String name;
  final String? image;
  final String relationship;
  final String? mobile;
  final DateTime? dateOfBirth;
  final DateTime? anniversaryDate;
  final String? gotra;
  final String? occupation;
  final String? education;
  final String? bloodGroup;
  final String? hobbies;
  final String? nativePlace;
  final String? notes;
  final bool matrimony;
  final String gender;
  final String? createdAt;
  final String? updatedAt;

  FamilyMember({
    required this.id,
    required this.customerId,
    required this.name,
    this.image,
    required this.relationship,
    this.mobile,
    this.dateOfBirth,
    this.anniversaryDate,
    this.gotra,
    this.occupation,
    this.education,
    this.bloodGroup,
    this.hobbies,
    this.nativePlace,
    this.notes,
    required this.matrimony,
    required this.gender,
    this.createdAt,
    this.updatedAt,
  });

  /// ✅ Factory for JSON parsing
  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      relationship: json['relationship'] ?? '',
      mobile: json['mobile'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'].toString())
          : null,
      anniversaryDate: json['anniversary_date'] != null
          ? DateTime.tryParse(json['anniversary_date'].toString())
          : null,
      gotra: json['gotra'],
      occupation: json['occupation'],
      education: json['education'],
      bloodGroup: json['blood_group'],
      hobbies: json['hobbies'],
      nativePlace: json['native_place'],
      notes: json['notes'],
      matrimony: json['matrimony'] == true || json['matrimony'] == 1,
      gender: json['gender'] ?? 'male',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  /// ✅ copyWith method
  FamilyMember copyWith({
    int? id,
    int? customerId,
    String? name,
    String? image,
    String? relationship,
    String? mobile,
    DateTime? dateOfBirth,
    DateTime? anniversaryDate,
    String? gotra,
    String? occupation,
    String? education,
    String? bloodGroup,
    String? hobbies,
    String? nativePlace,
    String? notes,
    bool? matrimony,
    String? gender,
    String? createdAt,
    String? updatedAt,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      image: image ?? this.image,
      relationship: relationship ?? this.relationship,
      mobile: mobile ?? this.mobile,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      gotra: gotra ?? this.gotra,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      hobbies: hobbies ?? this.hobbies,
      nativePlace: nativePlace ?? this.nativePlace,
      notes: notes ?? this.notes,
      matrimony: matrimony ?? this.matrimony,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// ✅ Convert back to Map for API calls
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customer_id": customerId,
      "name": name,
      "image": image,
      "relationship": relationship,
      "mobile": mobile,
      "date_of_birth": dateOfBirth?.toIso8601String(),
      "anniversary_date": anniversaryDate?.toIso8601String(),
      "gotra": gotra,
      "occupation": occupation,
      "education": education,
      "blood_group": bloodGroup,
      "hobbies": hobbies,
      "native_place": nativePlace,
      "notes": notes,
      "matrimony": matrimony,
      "gender": gender,
    };
  }
}