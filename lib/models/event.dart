class Event {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String location;
  final String? imageUrl;
  final String? category;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.location,
    this.imageUrl,
    this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'location': location,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
    );
  }
}
