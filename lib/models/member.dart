class Member {
  String id;
  String name;
  String mobile;
  String? secondaryMobile;
  String? email;
  String? fatherName;
  String? businessType;
  String? businessProducts;
  String? officeAddress;
  String? officeNumber;
  String? residenceAddress;
  String? residenceMobile;
  String? jaloreAddress;
  String? jaloreContactNumber;
  String? gender;
  int? age;
  String? education;
  DateTime? dateOfBirth;
  DateTime? dateOfAnniversary;
  String? familyImageUrl;
  String? profileImageUrl;

  Member({
    required this.id,
    required this.name,
    required this.mobile,
    this.secondaryMobile,
    this.email,
    this.fatherName,
    this.businessType,
    this.businessProducts,
    this.officeAddress,
    this.officeNumber,
    this.residenceAddress,
    this.residenceMobile,
    this.jaloreAddress,
    this.jaloreContactNumber,
    this.gender,
    this.age,
    this.education,
    this.dateOfBirth,
    this.dateOfAnniversary,
    this.familyImageUrl,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'secondaryMobile': secondaryMobile,
      'email': email,
      'fatherName': fatherName,
      'businessType': businessType,
      'businessProducts': businessProducts,
      'officeAddress': officeAddress,
      'officeNumber': officeNumber,
      'residenceAddress': residenceAddress,
      'residenceMobile': residenceMobile,
      'jaloreAddress': jaloreAddress,
      'jaloreContactNumber': jaloreContactNumber,
      'gender': gender,
      'age': age,
      'education': education,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'dateOfAnniversary': dateOfAnniversary?.toIso8601String(),
      'familyImageUrl': familyImageUrl,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      secondaryMobile: json['secondaryMobile'] as String?,
      email: json['email'] as String?,
      fatherName: json['fatherName'] as String?,
      businessType: json['businessType'] as String?,
      businessProducts: json['businessProducts'] as String?,
      officeAddress: json['officeAddress'] as String?,
      officeNumber: json['officeNumber'] as String?,
      residenceAddress: json['residenceAddress'] as String?,
      residenceMobile: json['residenceMobile'] as String?,
      jaloreAddress: json['jaloreAddress'] as String?,
      jaloreContactNumber: json['jaloreContactNumber'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      education: json['education'] as String?,
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      dateOfAnniversary: json['dateOfAnniversary'] != null
          ? DateTime.parse(json['dateOfAnniversary'] as String)
          : null,
      familyImageUrl: json['familyImageUrl'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}
