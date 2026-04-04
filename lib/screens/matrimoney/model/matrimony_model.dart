class Matrimoney {
  final int id;
  final int customerId;

  final String name;
  final String mobile;
  final String? fatherName;
  final String? education;
  final DateTime? dateOfBirth;

  // Family member (Matrimony profile)
  final String familyMemberName;
  final String familyMemberRelationship;
  final String? familyMemberEducation;
  final String? familyMemberGender;
  final DateTime? familyMemberDateOfBirth;
  final String? familyMemberMobile;
  final int? familyMemberAge;

  final bool matrimony;

  const Matrimoney({
    required this.id,
    required this.customerId,
    required this.name,
    required this.mobile,
    this.fatherName,
    this.education,
    this.dateOfBirth,
    required this.familyMemberName,
    required this.familyMemberGender,
    required this.familyMemberRelationship,
    this.familyMemberEducation,
    this.familyMemberDateOfBirth,
    this.familyMemberMobile,
    this.familyMemberAge,
    required this.matrimony,
  });

  // -------------------------
  // Helpers
  // -------------------------
  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  static bool _parseBool(dynamic v) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is String) return v == '1' || v.toLowerCase() == 'true';
    return false;
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static String _parseString(dynamic v) {
    if (v == null) return '';
    return v.toString();
  }

  // -------------------------
  // JSON
  // -------------------------
  factory Matrimoney.fromJson(Map<String, dynamic> json) {
    return Matrimoney(
      id: _parseInt(json['id']) ?? 0,
      customerId: _parseInt(json['customer_id']) ?? 0,

      name: _parseString(json['name']),
      mobile: _parseString(json['mobile']),
      fatherName: json['father_name']?.toString(),
      education: json['education']?.toString(),
      familyMemberGender: json['family_member_gender']?.toString(),
      dateOfBirth: _parseDate(json['date_of_birth']),

      familyMemberName:
      _parseString(json['family_member_name']),
      familyMemberRelationship:
      _parseString(json['family_member_relationship']),
      familyMemberEducation:
      json['family_member_education']?.toString(),
      familyMemberDateOfBirth:
      _parseDate(json['family_member_date_of_birth']),
      familyMemberMobile:
      json['family_member_mobile']?.toString(),
      familyMemberAge:
      _parseInt(json['family_member_age']),

      matrimony: _parseBool(json['matrimony']),
    );
  }
}
