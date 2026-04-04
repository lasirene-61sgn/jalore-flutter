class UserLoginResponse {
  final String status;
  final String message;
  final String token;
  final Customer customer;

  UserLoginResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.customer,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      customer: Customer.fromJson(json['customer'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
      'customer': customer.toJson(),
    };
  }
}

class Customer {
  final int id;
  final int adminCustomerId;
  final int adminId;
  final int? villageId;

  final String area;
  final String name;
  final String image;
  final String fatherName;
  final String gotra;
  final String labelName;
  final String district;
  final String msFirmName;
  final String dno;
  final String streetRoad;
  final String address2;
  final String city;
  final String pincode;
  final String mobile;
  final String whatsapp;
  final String education;
  final String occupation;
  final String bloodGroup;
  final String hobbies;
  final String nativePlace;

  final bool isPasswordSet;
  final String status;

  final String? dateOfBirth;
  final String? anniversaryDate;
  final String? otpExpiresAt;

  final String createdAt;
  final String updatedAt;

  Customer({
    required this.id,
    required this.adminCustomerId,
    required this.adminId,
    this.villageId,
    required this.area,
    required this.name,
    required this.image,
    required this.fatherName,
    required this.gotra,
    required this.labelName,
    required this.district,
    required this.msFirmName,
    required this.dno,
    required this.streetRoad,
    required this.address2,
    required this.city,
    required this.pincode,
    required this.mobile,
    required this.whatsapp,
    required this.education,
    required this.occupation,
    required this.bloodGroup,
    required this.hobbies,
    required this.nativePlace,
    required this.isPasswordSet,
    required this.status,
    this.dateOfBirth,
    this.anniversaryDate,
    this.otpExpiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    String safe(dynamic v) => v?.toString() ?? '';

    return Customer(
      id: json['id'] ?? 0,
      adminCustomerId: json['admin_customer_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      villageId: json['village_id'],
      area: safe(json['area']),
      name: safe(json['name']),
      image: safe(json['image']),
      fatherName: safe(json['father_name']),
      gotra: safe(json['gotra']),
      labelName: safe(json['label_name']),
      district: safe(json['district']),
      msFirmName: safe(json['ms_firm_name']),
      dno: safe(json['dno']),
      streetRoad: safe(json['street_road']),
      address2: safe(json['address2']),
      city: safe(json['city']),
      pincode: safe(json['pincode']),
      mobile: safe(json['mobile']),
      whatsapp: safe(json['whatsapp']),
      education: safe(json['education']),
      occupation: safe(json['occupation']),
      bloodGroup: safe(json['blood_group']),
      hobbies: safe(json['hobbies']),
      nativePlace: safe(json['native_place']),
      isPasswordSet: json['is_password_set'] ?? false,
      status: safe(json['status']),
      dateOfBirth: json['date_of_birth'],
      anniversaryDate: json['anniversary_date'],
      otpExpiresAt: json['otp_expires_at'],
      createdAt: safe(json['created_at']),
      updatedAt: safe(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_customer_id': adminCustomerId,
      'admin_id': adminId,
      'village_id': villageId,
      'area': area,
      'name': name,
      'image': image,
      'father_name': fatherName,
      'gotra': gotra,
      'label_name': labelName,
      'district': district,
      'ms_firm_name': msFirmName,
      'dno': dno,
      'street_road': streetRoad,
      'address2': address2,
      'city': city,
      'pincode': pincode,
      'mobile': mobile,
      'whatsapp': whatsapp,
      'education': education,
      'occupation': occupation,
      'blood_group': bloodGroup,
      'hobbies': hobbies,
      'native_place': nativePlace,
      'is_password_set': isPasswordSet,
      'status': status,
      'date_of_birth': dateOfBirth,
      'anniversary_date': anniversaryDate,
      'otp_expires_at': otpExpiresAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

