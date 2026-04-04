class Business {
  final String businessName;
  final String msFirmName;
  final String businessType;
  final String productService;
  final String officeAddress;
  final String mobile;
  final String owner;
  final int count;

  Business({
    required this.businessName,
    required this.msFirmName,
    required this.businessType,
    required this.productService,
    required this.officeAddress,
    required this.mobile,
    required this.owner,
    required this.count,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessName: json['business_name'] ?? '',
      msFirmName: json['ms_firm_name'] ?? '',
      businessType: json['business_type'] ?? '',
      productService: json['product_service'] ?? '',
      officeAddress: json['office_address'] ?? '',
      mobile: json['mobile'] ?? '',
      owner: json['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_name': businessName,
      'business_type': businessType,
      'ms_firm_name': msFirmName,
      'product_service': productService,
      'office_address': officeAddress,
      'mobile': mobile,
      'count': count,
    };
  }

  Business copyWith({
    String? businessName,
    String? msFirmName,
    String? businessType,
    String? productService,
    String? officeAddress,
    String? mobile,
    String? owner,
    int? count,
  }) {
    return Business(
      businessName: businessName ?? this.businessName,
      msFirmName: msFirmName ?? this.msFirmName,
      businessType: businessType ?? this.businessType,
      productService: productService ?? this.productService,
      officeAddress: officeAddress ?? this.officeAddress,
      mobile: mobile ?? this.mobile,
      owner: owner ?? this.owner,
      count: count ?? this.count,
    );
  }
}
