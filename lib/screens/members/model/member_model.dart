import 'package:flutter_app/screens/dashboard/model/dashboard_model.dart';


class FamilyMember {
  final int id;
  final int customerId;
  final String name;
  final String? image;
  final String? relationship;
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
  final String? gender;
  final DateTime createdAt;
  final DateTime updatedAt;

  FamilyMember({
    required this.id,
    required this.customerId,
    required this.name,
    this.image,
    this.relationship,
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
    this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  static DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

  static bool _parseBool(dynamic v) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    return false;
  }

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      relationship: json['relationship'],
      mobile: json['mobile'],
      dateOfBirth: _parseDate(json['date_of_birth']),
      anniversaryDate: _parseDate(json['anniversary_date']),
      gotra: json['gotra'],
      occupation: json['occupation'],
      education: json['education'],
      bloodGroup: json['blood_group'],
      hobbies: json['hobbies'],
      nativePlace: json['native_place'],
      notes: json['notes'],
      matrimony: _parseBool(json['matrimony']),
      gender: json['gender'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// ================= MEMBER MODEL =================

class Member {
  final int id;
  final int adminCustomerId;
  final int adminId;
  final int? villageId;

  final String? area;
  final String name;
  final String? image;
  final String? backgroundImage;
  final String? fatherName;
  final String? gotra;
  final String? labelName;
  final String? district;
  final String? msFirmName;
  final String? dno;
  final String? streetRoad;
  final String? address2;
  final String? city;
  final String? pincode;
  final String mobile;

  final String? whatsapp;
  final String? email;
  final int? age;
  final String? gender;

  final String? businessType;
  final String? businessName;
  final String? productService;
  final String? officeAddress;

  final String? education;
  final String? occupation;
  final String? bloodGroup;
  final String? hobbies;
  final String? nativePlace;

  final bool isPasswordSet;
  final String status;

  final DateTime? otpExpiresAt;
  final DateTime? dateOfBirth;
  final DateTime? anniversaryDate;

  final DateTime createdAt;
  final DateTime updatedAt;

  final String? fcmToken;
  final Village? village;
  final List<FamilyMember> familyMembers;

  Member({
    required this.id,
    required this.adminCustomerId,
    required this.adminId,
    this.villageId,
    this.area,
    required this.name,
    this.image,
    this.backgroundImage,
    this.fatherName,
    this.gotra,
    this.labelName,
    this.district,
    this.msFirmName,
    this.dno,
    this.streetRoad,
    this.address2,
    this.city,
    this.pincode,
    required this.mobile,
    this.whatsapp,
    this.email,
    this.age,
    this.gender,
    this.businessType,
    this.businessName,
    this.productService,
    this.officeAddress,
    this.education,
    this.occupation,
    this.bloodGroup,
    this.hobbies,
    this.nativePlace,
    required this.isPasswordSet,
    required this.status,
    this.otpExpiresAt,
    this.dateOfBirth,
    this.anniversaryDate,
    required this.createdAt,
    required this.updatedAt,
    this.fcmToken,
    this.village,
    this.familyMembers = const [],
  });

  static DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

  static bool _parseBool(dynamic v) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    return false;
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] ?? 0,
      adminCustomerId: json['admin_customer_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      villageId: json['village_id'],

      area: json['area'],
      name: json['name'] ?? '',
      image: json['image'],
      backgroundImage: json['background_image'],
      fatherName: json['father_name'],
      gotra: json['gotra'],
      labelName: json['label_name'],
      district: json['district'],
      msFirmName: json['ms_firm_name'],
      dno: json['dno'],
      streetRoad: json['street_road'],
      address2: json['address2'],
      city: json['city'],
      pincode: json['pincode'],
      mobile: json['mobile'] ?? '',

      whatsapp: json['whatsapp'],
      email: json['email'],
      age: json['age'],
      gender: json['gender'],

      businessType: json['business_type'],
      businessName: json['business_name'],
      productService: json['product_service'],
      officeAddress: json['office_address'],

      education: json['education'],
      occupation: json['occupation'],
      bloodGroup: json['blood_group'],
      hobbies: json['hobbies'],
      nativePlace: json['native_place'],

      isPasswordSet: _parseBool(json['is_password_set']),
      status: json['status'] ?? '',

      otpExpiresAt: _parseDate(json['otp_expires_at']),
      dateOfBirth: _parseDate(json['date_of_birth']),
      anniversaryDate: _parseDate(json['anniversary_date']),

      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),

      fcmToken: json['fcm_token'],

      village: json['village'] != null
          ? Village.fromJson(json['village'])
          : null,

      familyMembers: json['family_members'] != null
          ? (json['family_members'] as List)
          .map((e) => FamilyMember.fromJson(e))
          .toList()
          : [],
    );
  }
}


