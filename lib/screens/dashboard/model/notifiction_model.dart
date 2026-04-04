import 'dart:convert';

/// ===============================
/// APP NOTIFICATION MODEL
/// ===============================
class AppNotification {
  final int? id;
  final String type;
  final String title;
  final String message;
  final bool isRead; // Root level is_read from your JSON
  final DateTime? readAt;
  final NotificationData? data;
  final DateTime? createdAt;

  const AppNotification({
    this.id,
    required this.type,
    required this.title,
    required this.message,
    this.isRead = false,
    this.readAt,
    this.data,
    this.createdAt,
  });

  /// CopyWith
  AppNotification copyWith({
    int? id,
    String? type,
    String? title,
    String? message,
    bool? isRead,
    DateTime? readAt,
    NotificationData? data,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Date parser
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  /// From JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      isRead: json['is_read'] ?? false, // Maps the root "is_read"
      readAt: _parseDate(json['read_at']),
      data: json['data'] != null ? NotificationData.fromJson(json['data']) : null,
      createdAt: _parseDate(json['created_at']),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'data': data?.toJson(),
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// ===============================
/// NOTIFICATION DATA MODEL
/// ===============================
class NotificationData {
  final int id;
  final int? adminId;
  final String title;
  final String description;
  final List<String> imagePaths;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationData({
    required this.id,
    this.adminId,
    required this.title,
    required this.description,
    required this.imagePaths,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  NotificationData copyWith({
    int? id,
    int? adminId,
    String? title,
    String? description,
    List<String>? imagePaths,
    String? status,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationData(
      id: id ?? this.id,
      adminId: adminId ?? this.adminId,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePaths: imagePaths ?? this.imagePaths,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] ?? 0,
      adminId: json['admin_id'],
      // Note: Data title is used if available, otherwise root handles it
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imagePaths: (json['image_paths'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'title': title,
      'description': description,
      'image_paths': imagePaths,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}