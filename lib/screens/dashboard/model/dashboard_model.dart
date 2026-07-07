import '../../profile/model/family_member_model.dart';

class BirthdayModel {
  final int id;
  final String name;
  final String mobile;
  final String? whatsapp;
  final DateTime? anniversaryDate;
  final DateTime? dateOfBirth;
  final int? villageId;
  final String? area;
  final Village? village;
  final String? image;
  final String? backgroundImage;
  final String? fatherName;
  final String? gotra;
  final String? msFirmName;
  final String? city;
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
  final bool isToday;
  final List<FamilyMember> allFamilyMembers;

  BirthdayModel({
    required this.id,
    required this.name,
    required this.mobile,
    this.whatsapp,
    this.anniversaryDate,
    this.dateOfBirth,
    this.villageId,
    this.area,
    this.village,
    this.image,
    this.backgroundImage,
    this.fatherName,
    this.gotra,
    this.msFirmName,
    this.city,
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
    this.isToday = false,
    required this.allFamilyMembers,
  });

  factory BirthdayModel.fromJson(Map<String, dynamic> json) {
    final familyListRaw = json['all_family_members'] as List<dynamic>? ?? [];
    final List<FamilyMember> familyList = familyListRaw
        .map((x) => FamilyMember.fromJson(x as Map<String, dynamic>))
        .toList();

    return BirthdayModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      whatsapp: json['whatsapp'],
      anniversaryDate: json['anniversary_date'] != null
          ? DateTime.tryParse(json['anniversary_date'])
          : null,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      villageId: json['village_id'],
      area: json['area'],
      village: json['village'] != null ? Village.fromJson(json['village']) : null,
      image: json['image'],
      backgroundImage: json['background_image'],
      fatherName: json['father_name'],
      gotra: json['gotra'],
      msFirmName: json['ms_firm_name'],
      city: json['city'],
      email: json['email'],
      age: json['age'] is int ? json['age'] : (json['age'] != null ? int.tryParse(json['age'].toString()) : null),
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
      isToday: json['is_birthday_today'] == true || json['is_anniversary_today'] == true,
      allFamilyMembers: familyList,
    );
  }

  BirthdayModel copyWith({
    int? id,
    String? name,
    String? mobile,
    String? whatsapp,
    DateTime? anniversaryDate,
    DateTime? dateOfBirth,
    int? villageId,
    String? area,
    Village? village,
    String? image,
    String? backgroundImage,
    String? fatherName,
    String? gotra,
    String? msFirmName,
    String? city,
    String? email,
    int? age,
    String? gender,
    String? businessType,
    String? businessName,
    String? productService,
    String? officeAddress,
    String? education,
    String? occupation,
    String? bloodGroup,
    String? hobbies,
    String? nativePlace,
    bool? isToday,
    List<FamilyMember>? allFamilyMembers,
  }) {
    return BirthdayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      whatsapp: whatsapp ?? this.whatsapp,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      villageId: villageId ?? this.villageId,
      area: area ?? this.area,
      village: village ?? this.village,
      image: image ?? this.image,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      fatherName: fatherName ?? this.fatherName,
      gotra: gotra ?? this.gotra,
      msFirmName: msFirmName ?? this.msFirmName,
      city: city ?? this.city,
      email: email ?? this.email,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      businessType: businessType ?? this.businessType,
      businessName: businessName ?? this.businessName,
      productService: productService ?? this.productService,
      officeAddress: officeAddress ?? this.officeAddress,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      hobbies: hobbies ?? this.hobbies,
      nativePlace: nativePlace ?? this.nativePlace,
      isToday: isToday ?? this.isToday,
      allFamilyMembers: allFamilyMembers ?? this.allFamilyMembers,
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

class DashboardCountersModel {
  final int newGalleryCount;
  final int newEventCount;
  final int newNewsCount;
  final int newCommitteeCount;
  final int newCustomerCount;

  DashboardCountersModel({
    required this.newGalleryCount,
    required this.newEventCount,
    required this.newNewsCount,
    required this.newCommitteeCount,
    required this.newCustomerCount,
  });

  factory DashboardCountersModel.fromJson(Map<String, dynamic> json) {
    return DashboardCountersModel(
      newGalleryCount: json['new_gallery_count'] ?? 0,
      newEventCount: json['new_event_count'] ?? 0,
      newNewsCount: json['new_news_count'] ?? 0,
      newCommitteeCount: json['new_committee_count'] ?? 0,
      newCustomerCount: json['new_customer_count'] ?? 0,
    );
  }

  DashboardCountersModel copyWith({
    int? newGalleryCount,
    int? newEventCount,
    int? newNewsCount,
    int? newCommitteeCount,
    int? newCustomerCount,
  }) {
    return DashboardCountersModel(
      newGalleryCount: newGalleryCount ?? this.newGalleryCount,
      newEventCount: newEventCount ?? this.newEventCount,
      newNewsCount: newNewsCount ?? this.newNewsCount,
      newCommitteeCount: newCommitteeCount ?? this.newCommitteeCount,
      newCustomerCount: newCustomerCount ?? this.newCustomerCount,
    );
  }
}
class SocialLinksModel {
  final int id;
  final int adminId;
  final String? whatsappLink;
  final String? facebookLink;
  final String? emailLink;
  final String? twitterLink;
  final String? instagramLink;
  final String? linkedinLink;

  SocialLinksModel({
    required this.id,
    required this.adminId,
    this.whatsappLink,
    this.facebookLink,
    this.emailLink,
    this.twitterLink,
    this.instagramLink,
    this.linkedinLink,
  });

  factory SocialLinksModel.fromJson(Map<String, dynamic> json) {
    return SocialLinksModel(
      id: json['id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      whatsappLink: json['whatsapp_link'],
      facebookLink: json['facebook_link'],
      emailLink: json['email_link'],
      twitterLink: json['twitter_link'],
      instagramLink: json['instagram_link'],
      linkedinLink: json['linkedin_link'],
    );
  }

  SocialLinksModel copyWith({
    int? id,
    int? adminId,
    String? whatsappLink,
    String? facebookLink,
    String? emailLink,
    String? twitterLink,
    String? instagramLink,
    String? linkedinLink,
  }) {
    return SocialLinksModel(
      id: id ?? this.id,
      adminId: adminId ?? this.adminId,
      whatsappLink: whatsappLink ?? this.whatsappLink,
      facebookLink: facebookLink ?? this.facebookLink,
      emailLink: emailLink ?? this.emailLink,
      twitterLink: twitterLink ?? this.twitterLink,
      instagramLink: instagramLink ?? this.instagramLink,
      linkedinLink: linkedinLink ?? this.linkedinLink,
    );
  }
}
