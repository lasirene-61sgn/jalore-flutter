class Profile {
  final int id;
  final int adminCustomerId;
  final int adminId;
  final int? villageId;
  final String? villageName;
  final Village? village;

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
  final String? area;
  final String? pincode;

  final String mobile;
  final String? whatsapp;
  final String? email;

  final bool isPasswordSet;
  final String status;

  final DateTime? otpExpiresAt;
  final DateTime? dateOfBirth;
  final DateTime? anniversaryDate;

  final String? age;
  final String? gender;
  final String? education;
  final String? occupation;
  final String? bloodGroup;
  final String? hobbies;
  final String? nativePlace;

  final String? businessType;
  final String? businessName;
  final String? productService;
  final String? officeAddress;

  final String createdAt;
  final String updatedAt;

  Profile({
    required this.id,
    required this.adminCustomerId,
    required this.adminId,
    this.villageId,
    this.villageName,
    this.village,
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
    this.area,
    this.pincode,
    required this.mobile,
    this.whatsapp,
    this.email,
    required this.isPasswordSet,
    required this.status,
    this.otpExpiresAt,
    this.dateOfBirth,
    this.anniversaryDate,
    this.age,
    this.gender,
    this.education,
    this.occupation,
    this.bloodGroup,
    this.hobbies,
    this.nativePlace,
    this.businessType,
    this.businessName,
    this.productService,
    this.officeAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ copyWith
  Profile copyWith({
    int? id,
    int? adminCustomerId,
    int? adminId,
    int? villageId,
    String? villageName,
    Village? village,
    String? name,
    String? image,
    String? fatherName,
    String? gotra,
    String? labelName,
    String? district,
    String? msFirmName,
    String? dno,
    String? streetRoad,
    String? address2,
    String? city,
    String? area,
    String? pincode,
    String? mobile,
    String? whatsapp,
    String? email,
    bool? isPasswordSet,
    String? status,
    DateTime? otpExpiresAt,
    DateTime? dateOfBirth,
    DateTime? anniversaryDate,
    String? age,
    String? gender,
    String? education,
    String? occupation,
    String? bloodGroup,
    String? hobbies,
    String? nativePlace,
    String? businessType,
    String? businessName,
    String? productService,
    String? officeAddress,
    String? createdAt,
    String? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      adminCustomerId: adminCustomerId ?? this.adminCustomerId,
      adminId: adminId ?? this.adminId,
      villageId: villageId ?? this.villageId,
      villageName: villageName ?? this.villageName,
      village: village ?? this.village,
      name: name ?? this.name,
      image: image ?? this.image,
      fatherName: fatherName ?? this.fatherName,
      gotra: gotra ?? this.gotra,
      labelName: labelName ?? this.labelName,
      district: district ?? this.district,
      msFirmName: msFirmName ?? this.msFirmName,
      dno: dno ?? this.dno,
      streetRoad: streetRoad ?? this.streetRoad,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      area: area ?? this.area,
      pincode: pincode ?? this.pincode,
      mobile: mobile ?? this.mobile,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      isPasswordSet: isPasswordSet ?? this.isPasswordSet,
      status: status ?? this.status,
      otpExpiresAt: otpExpiresAt ?? this.otpExpiresAt,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      hobbies: hobbies ?? this.hobbies,
      nativePlace: nativePlace ?? this.nativePlace,
      businessType: businessType ?? this.businessType,
      businessName: businessName ?? this.businessName,
      productService: productService ?? this.productService,
      officeAddress: officeAddress ?? this.officeAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    return DateTime.tryParse(value.toString());
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? 0,
      adminCustomerId: json['admin_customer_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      villageId: json['village_id'],
      villageName: json['village_name'],
      village: json['village'] != null ? Village.fromJson(json['village']) : null,
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
      area: json['area'],
      pincode: json['pincode'],
      mobile: json['mobile'] ?? '',
      whatsapp: json['whatsapp'],
      email: json['email'],
      isPasswordSet: json['is_password_set'] ?? false,
      status: json['status'] ?? '',
      otpExpiresAt: _parseDate(json['otp_expires_at']),
      dateOfBirth: _parseDate(json['date_of_birth']),
      anniversaryDate: _parseDate(json['anniversary_date']),
      age: json['age']?.toString(),
      gender: json['gender'],
      education: json['education'],
      occupation: json['occupation'],
      bloodGroup: json['blood_group'],
      hobbies: json['hobbies'],
      nativePlace: json['native_place'],
      businessType: json['business_type'],
      businessName: json['business_name'],
      productService: json['product_service'],
      officeAddress: json['office_address'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}


class Village {
  final int id;
  final String name;

  Village({required this.id, required this.name});

  Village copyWith({
    int? id,
    String? name,
  }) {
    return Village(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
