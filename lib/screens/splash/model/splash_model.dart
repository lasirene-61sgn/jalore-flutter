class SplashResponse {
  final bool success;
  final String message;
  final List<SplashImage> data;

  SplashResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SplashResponse.fromJson(Map<String, dynamic> json) {
    return SplashResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => SplashImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class SplashImage {
  final String url;
  final int seconds;

  SplashImage({
    required this.url,
    required this.seconds,
  });

  factory SplashImage.fromJson(Map<String, dynamic> json) {
    return SplashImage(
      url: json['url'] ?? '',
      seconds: json['seconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'seconds': seconds,
    };
  }
}
