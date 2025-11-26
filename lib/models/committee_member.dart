class CommitteeMember {
  final String id;
  final String name;
  final String position;
  final String mobile;
  final String? imageUrl;

  CommitteeMember({
    required this.id,
    required this.name,
    required this.position,
    required this.mobile,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'mobile': mobile,
      'imageUrl': imageUrl,
    };
  }

  factory CommitteeMember.fromJson(Map<String, dynamic> json) {
    return CommitteeMember(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as String,
      mobile: json['mobile'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
