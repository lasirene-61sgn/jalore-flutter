class SupportProfile {
  final int id;
  final int adminCustomerId;
  final int adminId;
  final int? villageId;
  final String? area;
  final String name;
  final String? image;
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
  final dynamic isPasswordSet;
  final String status;
  final DateTime? otpExpiresAt;
  final DateTime? dateOfBirth;
  final DateTime? anniversaryDate;
  final String? education;
  final String? occupation;
  final String? bloodGroup;
  final String? hobbies;
  final String? nativePlace;
  final String createdAt;
  final String updatedAt;

  SupportProfile({
    required this.id,
    required this.adminCustomerId,
    required this.adminId,
    this.villageId,
    this.area,
    required this.name,
    this.image,
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
    required this.isPasswordSet,
    required this.status,
    this.otpExpiresAt,
    this.dateOfBirth,
    this.anniversaryDate,
    this.education,
    this.occupation,
    this.bloodGroup,
    this.hobbies,
    this.nativePlace,
    required this.createdAt,
    required this.updatedAt,
  });

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty || value.toString() == 'null') return null;
    return DateTime.tryParse(value.toString());
  }

  factory SupportProfile.fromJson(Map<String, dynamic> json) {
    return SupportProfile(
      id: json['id'] ?? 0,
      adminCustomerId: json['admin_customer_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      villageId: json['village_id'],
      area: json['area'],
      name: json['name'] ?? '',
      image: json['image'],
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
      isPasswordSet: json['is_password_set'] ?? false,
      status: json['status'] ?? '',
      otpExpiresAt: _parseDate(json['otp_expires_at']),
      dateOfBirth: _parseDate(json['date_of_birth']),
      anniversaryDate: _parseDate(json['anniversary_date']),
      education: json['education'],
      occupation: json['occupation'],
      bloodGroup: json['blood_group'],
      hobbies: json['hobbies'],
      nativePlace: json['native_place'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}