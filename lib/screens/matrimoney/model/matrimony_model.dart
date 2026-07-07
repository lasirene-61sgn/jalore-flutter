import '../../profile/model/family_member_model.dart';

class Matrimoney {
  final int id;
  final int customerId;

  // Customer (main account holder) details
  final String name;
  final String mobile;
  final String? fatherName;
  final String? education;
  final DateTime? dateOfBirth;
  final String? image;
  final String? backgroundImage;
  final String? whatsapp;
  final String? email;
  final String? businessType;
  final String? businessName;
  final String? productService;
  final String? officeAddress;
  final DateTime? anniversaryDate;
  final String? nativePlace;
  final String? gotra;
  final String? bloodGroup;
  final String? occupation;
  final String? hobbies;
  final String? village;

  // Family member (the actual Matrimony profile) details
  final String familyMemberName;
  final String familyMemberRelationship;
  final String? familyMemberEducation;
  final DateTime? familyMemberDateOfBirth;
  final String? familyMemberMobile;
  final int? familyMemberAge;
  final String? gender;
  final String? familyMemberImage;
  final DateTime? familyMemberAnniversaryDate;
  final String? familyMemberGotra;
  final String? familyMemberOccupation;
  final String? familyMemberBloodGroup;
  final String? familyMemberHobbies;
  final String? familyMemberNativePlace;
  final String? familyMemberNotes;
  final bool matrimony;
  final String? matrimonyPdf;
  final String? matrimonyLink;

  final List<FamilyMember> allFamilyMembers;

  const Matrimoney({
    required this.id,
    required this.customerId,
    required this.name,
    required this.mobile,
    this.fatherName,
    this.education,
    this.dateOfBirth,
    this.image,
    this.backgroundImage,
    this.whatsapp,
    this.email,
    this.businessType,
    this.businessName,
    this.productService,
    this.officeAddress,
    this.anniversaryDate,
    this.nativePlace,
    this.gotra,
    this.bloodGroup,
    this.occupation,
    this.hobbies,
    this.village,
    required this.familyMemberName,
    required this.familyMemberRelationship,
    this.familyMemberEducation,
    this.familyMemberDateOfBirth,
    this.familyMemberMobile,
    this.familyMemberAge,
    this.gender,
    this.familyMemberImage,
    this.familyMemberAnniversaryDate,
    this.familyMemberGotra,
    this.familyMemberOccupation,
    this.familyMemberBloodGroup,
    this.familyMemberHobbies,
    this.familyMemberNativePlace,
    this.familyMemberNotes,
    required this.matrimony,
    this.matrimonyPdf,
    this.matrimonyLink,
    required this.allFamilyMembers,
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
    final customer = json['customer_details'] as Map<String, dynamic>? ?? {};
    final familyMember = json['family_member_details'] as Map<String, dynamic>? ?? {};

    // Helper function to build full image URL if needed
    String? parseImageUrl(dynamic val) {
      if (val == null) return null;
      final s = val.toString().trim();
      if (s.isEmpty) return null;
      if (s.startsWith('http://') || s.startsWith('https://')) {
        return s;
      }
      return 'https://sirohi.lasirene.xyz/$s';
    }

    String? parsePdfUrl(dynamic val) {
      if (val == null) return null;
      final s = val.toString().trim();
      if (s.isEmpty) return null;
      if (s.startsWith('http://') || s.startsWith('https://')) {
        return s;
      }
      return 'https://sirohi.lasirene.xyz/$s';
    }

    final familyListRaw = customer['all_family_members'] as List<dynamic>? ?? [];
    final List<FamilyMember> familyList = familyListRaw
        .map((x) => FamilyMember.fromJson(x as Map<String, dynamic>))
        .toList();

    return Matrimoney(
      id: _parseInt(familyMember['id']) ?? _parseInt(json['id']) ?? 0,
      customerId: _parseInt(familyMember['customer_id']) ?? _parseInt(customer['id']) ?? _parseInt(json['customer_id']) ?? 0,

      name: _parseString(customer['name']).isNotEmpty ? _parseString(customer['name']) : _parseString(json['name']),
      mobile: _parseString(customer['mobile']).isNotEmpty ? _parseString(customer['mobile']) : _parseString(json['mobile']),
      fatherName: customer['father_name']?.toString() ?? json['father_name']?.toString(),
      education: customer['education']?.toString() ?? json['education']?.toString(),
      dateOfBirth: _parseDate(customer['date_of_birth']) ?? _parseDate(json['date_of_birth']),
      image: parseImageUrl(customer['image']),
      backgroundImage: parseImageUrl(customer['background_image']),
      whatsapp: customer['whatsapp']?.toString(),
      email: customer['email']?.toString(),
      businessType: customer['business_type']?.toString(),
      businessName: customer['business_name']?.toString(),
      productService: customer['product_service']?.toString(),
      officeAddress: customer['office_address']?.toString(),
      anniversaryDate: _parseDate(customer['anniversary_date']),
      nativePlace: customer['native_place']?.toString(),
      gotra: customer['gotra']?.toString(),
      bloodGroup: customer['blood_group']?.toString(),
      occupation: customer['occupation']?.toString(),
      hobbies: customer['hobbies']?.toString(),
      village: customer['village']?.toString(),

      familyMemberName: _parseString(familyMember['name']).isNotEmpty ? _parseString(familyMember['name']) : _parseString(json['family_member_name']),
      familyMemberRelationship: _parseString(familyMember['relationship']).isNotEmpty ? _parseString(familyMember['relationship']) : _parseString(json['family_member_relationship']),
      familyMemberEducation: familyMember['education']?.toString() ?? json['family_member_education']?.toString(),
      familyMemberDateOfBirth: _parseDate(familyMember['date_of_birth']) ?? _parseDate(json['family_member_date_of_birth']),
      familyMemberMobile: familyMember['mobile']?.toString() ?? json['family_member_mobile']?.toString(),
      familyMemberAge: _parseInt(familyMember['family_member_age']) ?? _parseInt(familyMember['age']) ?? _parseInt(json['family_member_age']),
      gender: familyMember['gender']?.toString() ?? customer['gender']?.toString() ?? json['gender']?.toString() ?? json['family_member_gender']?.toString(),
      familyMemberImage: parseImageUrl(familyMember['image']),
      familyMemberAnniversaryDate: _parseDate(familyMember['anniversary_date']),
      familyMemberGotra: familyMember['gotra']?.toString(),
      familyMemberOccupation: familyMember['occupation']?.toString(),
      familyMemberBloodGroup: familyMember['blood_group']?.toString(),
      familyMemberHobbies: familyMember['hobbies']?.toString(),
      familyMemberNativePlace: familyMember['native_place']?.toString(),
      familyMemberNotes: familyMember['notes']?.toString(),

      matrimony: _parseBool(familyMember['matrimony']) || _parseBool(json['matrimony']),
      matrimonyPdf: parsePdfUrl(familyMember['pdf']) ?? parsePdfUrl(familyMember['matrimony_pdf']) ?? parsePdfUrl(json['pdf']) ?? parsePdfUrl(json['matrimony_pdf']),
      matrimonyLink: familyMember['link']?.toString() ?? familyMember['matrimony_link']?.toString() ?? json['link']?.toString() ?? json['matrimony_link']?.toString(),
      allFamilyMembers: familyList,
    );
  }
}
