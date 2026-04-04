import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_app/services/local_storage/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mime/mime.dart';

class ApiClient {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late final String baseUrl;

  ApiClient() {
    if (kIsWeb) {
      baseUrl = "https://jalore.lasirene.xyz";
    } else {
      baseUrl = "https://jalore.lasirene.xyz";
    }
    debugPrint('ApiClient initialized → baseUrl: $baseUrl');
  }

  Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<String> getToken() async {
    await SharedPreferencesHelper().init();
    final isLoggedIn = SharedPreferencesHelper().getBool("isLoggedIn") ?? false;
    final token = SharedPreferencesHelper().getString("token") ?? "";
    debugPrint('getToken() → isLoggedIn: $isLoggedIn, token: ${token.isNotEmpty ? "present" : "empty"}');
    return isLoggedIn && token.isNotEmpty ? token : "";
  }

  // ------------ Public Methods ------------

  Future<dynamic> get(String endpoint) async {
    final token = await getToken();
    final url = '$baseUrl/$endpoint';
    debugPrint('GET → $url');

    if (token.isEmpty) {
      debugPrint('Token is empty. Skipping authenticated request.');
      return {
        "status": 2,
        "message": "Unauthenticated. Please log in again."
      };
    }

    final headers = {
      ...defaultHeaders,
      'Authorization': 'Bearer $token',
    };
    debugPrint('Headers → $headers');

    final response = await http.get(Uri.parse(url), headers: headers);
    debugPrint('GET Response ← ${response.statusCode}');
    return _handleResponse(response);
  }

  Future<dynamic> put({required String url, Map? map}) async {
    final token = await getToken();
    final fullUrl = '$baseUrl/$url';
    debugPrint('PUT → $fullUrl');
    debugPrint('Body → ${json.encode(map ?? {})}');

    final headers = {
      ...defaultHeaders,
    };
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    debugPrint('Headers → $headers');

    try {
      final response = await http.put(
        Uri.parse(fullUrl),
        headers: headers,
        body: json.encode(map ?? {}),
      );
      debugPrint('PUT Response ← ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      debugPrint('PUT Exception → $e');
      return {
        "status": 0,
        "message": "An unexpected error occurred: $e"
      };
    }
  }

  Future<dynamic> post({required String url, Map? map}) async {
    final token = await getToken();
    final fullUrl = '$baseUrl/$url';
    debugPrint('POST → $fullUrl');
    debugPrint('Body → ${json.encode(map ?? {})}');

    final headers = {
      ...defaultHeaders,
    };
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    debugPrint('Headers → $headers');

    try {
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: headers,
        body: json.encode(map ?? {}),
      );
      debugPrint('POST Response ← ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      debugPrint('POST Exception → $e');
      return {
        "status": 0,
        "message": "An unexpected error occurred: $e"
      };
    }
  }

  Future<dynamic> headerLessPost({required String url, Map? map}) async {
    final fullUrl = '$baseUrl/$url';
    debugPrint('headerLessPost → $fullUrl');
    debugPrint('Body → ${json.encode(map ?? {})}');

    final response = await http.post(
      Uri.parse(fullUrl),
      headers: defaultHeaders,
      body: json.encode(map ?? {}),
    );
    debugPrint('headerLessPost Response ← ${response.statusCode}');
    return _handleResponse(response);
  }

  Future<dynamic> postWithFiles({
    required String url,
    Map<String, dynamic>? map,
    Map<String, dynamic> files = const {},   // ← flexible map
  }) async {
    final token = await getToken();
    final fullUrl = '$baseUrl/$url';
    final request = http.MultipartRequest('POST', Uri.parse(fullUrl));

    // ----- headers -------------------------------------------------
    final headers = {'Accept': 'application/json'};
    if (token.isNotEmpty) headers['Authorization'] = 'Token $token';
    request.headers.addAll(headers);
 print(headers['Authorization']);
    // ----- form fields ---------------------------------------------
    map?.forEach((key, value) {
      if (value != null) request.fields[key] = value.toString();
    });

    // ----- files (any number, any key) -----------------------------
    for (final entry in files.entries) {
      final fieldName = entry.key;
      final fileData = entry.value;

      // Resolve to List<PlatformFile>
      final List<PlatformFile> fileList = fileData is PlatformFile
          ? [fileData]
          : fileData is List<PlatformFile>
          ? fileData
          : [];

      for (final file in fileList) {
        final mime = lookupMimeType(file.name) ?? 'application/octet-stream';
        final contentType = MediaType.parse(mime);

        if (kIsWeb) {
          // ----- WEB -----
          if (file.bytes != null) {
            request.files.add(http.MultipartFile.fromBytes(
              fieldName,
              file.bytes!,
              filename: file.name,
              contentType: contentType,
            ));
          }
        } else {
          // ----- MOBILE -----
          if (file.path != null) {
            final diskFile = File(file.path!);
            if (await diskFile.exists()) {
              request.files.add(await http.MultipartFile.fromPath(
                fieldName,
                file.path!,
                filename: file.name,
                contentType: contentType,
              ));
            }
          }
        }
      }
    }

    // ----- send ----------------------------------------------------
    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      try {
        return _handleResponse(resp);
      } catch (_) {
        return resp.body;
      }
    } else {
      throw Exception('Upload failed (${resp.statusCode}) – ${resp.body}');
    }
  }
  Future<dynamic> putWithFiles({
    required String url,
    required String method, // PUT
    Map<String, dynamic>? map,
    Map<String, dynamic> files = const {},
  }) async {
    final token = await getToken();
    final fullUrl = '$baseUrl/$url';

    // 🔥 IMPORTANT: Always POST for multipart
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(fullUrl),
    );

    print('PUT WITH FILES → $fullUrl');
    print('PUT WITH payload → $map');

    // ---------------- HEADERS ----------------
    final headers = {'Accept': 'application/json'};
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    request.headers.addAll(headers);

    // ---------------- METHOD OVERRIDE ----------------
    request.fields['_method'] = method; // PUT

    // ---------------- FORM FIELDS ----------------
    map?.forEach((key, value) {
      if (value == null) return;

      final v = value.toString().trim();
      if (v.isEmpty) return;

      request.fields[key] = v;
    });

    // ---------------- FILES ----------------
    for (final entry in files.entries) {
      final fieldName = entry.key;
      final fileData = entry.value;

      if (fileData == null) continue;

      // ✅ FILE from ImagePicker
      if (fileData is File) {
        final mime = lookupMimeType(fileData.path) ?? 'image/jpeg';
        request.files.add(
          await http.MultipartFile.fromPath(
            fieldName,
            fileData.path,
            contentType: MediaType.parse(mime),
          ),
        );
        print('DEBUG: File added → $fieldName');
        continue;
      }
    }

    print(
        'DEBUG: Sending request with ${request.fields.length} fields and ${request.files.length} files');

    // ---------------- SEND ----------------
    final streamed = await request.send().timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException('Upload timed out');
      },
    );

    final response = await http.Response.fromStream(streamed);

    print('STATUS → ${response.statusCode}');
    print('BODY → ${response.body}');

    return jsonDecode(response.body);
  }


  Future<dynamic> putWithFilesAdvanced({
    required String url,
    required String method,
    Map<String, dynamic>? map,
    Map<String, dynamic> files = const {},
  }) async {
    try {
      final token = await getToken();
      final fullUrl = '$baseUrl/$url';
      final request = http.MultipartRequest(method, Uri.parse(fullUrl));

      // -------- HEADERS --------
      final headers = {'Accept': 'application/json'};
      if (token.isNotEmpty) headers['Authorization'] = 'Token $token';
      request.headers.addAll(headers);
      print("----------------------------------------------------------------$map");

      // -------- FIELDS (FIXED: Properly serialize nested objects) --------
      map?.forEach((key, value) {
        if (value != null) {
          // Check if value is a Map or List - serialize to JSON
          if (value is Map || value is List) {
            request.fields[key] = jsonEncode(value);
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      // -------- FILES (SAFE HANDLING + ERROR LOGS) --------
      for (final entry in files.entries) {
        final key = entry.key;
        final value = entry.value;
        List<dynamic> list;

        if (value is File || value is PlatformFile) {
          list = [value];
        } else if (value is List) {
          list = value;
        } else {
          print("⚠️ Invalid file type for key '$key'");
          list = [];
        }

        for (final item in list) {
          try {
            if (item is PlatformFile) {
              final mime = lookupMimeType(item.name) ?? 'application/octet-stream';
              final contentType = MediaType.parse(mime);

              if (kIsWeb && item.bytes != null) {
                request.files.add(
                  http.MultipartFile.fromBytes(
                    key,
                    item.bytes!,
                    filename: item.name,
                    contentType: contentType,
                  ),
                );
              } else if (!kIsWeb && item.path != null) {
                request.files.add(
                  await http.MultipartFile.fromPath(
                    key,
                    item.path!,
                    filename: item.name,
                    contentType: contentType,
                  ),
                );
              }
            }

            if (item is File) {
              final filename = item.path.split('/').last;
              final mime = lookupMimeType(filename) ?? 'application/octet-stream';
              final contentType = MediaType.parse(mime);

              request.files.add(
                await http.MultipartFile.fromPath(
                  key,
                  item.path,
                  filename: filename,
                  contentType: contentType,
                ),
              );
            }
          } catch (e, s) {
            print("❌ FILE ERROR for key '$key': $e");
            print("STACK: $s");
          }
        }
      }

      // -------- SEND REQUEST --------
      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);

      print("📌 RESPONSE STATUS: ${resp.statusCode}");
      print("📌 RESPONSE BODY: ${resp.body}");

      return _handleResponse(resp);
    } catch (e, s) {
      print("❌ GLOBAL ERROR in putWithFilesAdvanced()");
      print("ERROR: $e");
      print("STACK: $s");
      throw Exception("Upload failed: $e");
    }
  }

  // ------------ Private Method ------------
  dynamic _handleResponse(http.Response response) {
    debugPrint('Handling response → ${response.statusCode}');
    debugPrint('Response Body → ${response.body}');

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decoded = json.decode(response.body);
          debugPrint('Success → Parsed JSON');
        return {
            "status": 1,
            "data": decoded
          };
        } on FormatException catch (e) {
          debugPrint('JSON Decode Error → $e');
          return {
            "status": 0,
            "message": "Invalid response format from server."
          };
        }
      }

      else if (response.statusCode == 422) {
        try {
          final decoded = json.decode(response.body);
          final errorMsg = decoded is Map && decoded.containsKey("errors")
              ? decoded['errors'].values.first[0]
              : "Validation error occurred.";
          debugPrint('Validation Error (422) → $errorMsg');
          return {"status": 0, "message": decoded};
        } catch (e) {
          debugPrint('422 Decode Failed → $e');
          return {"status": 0, "message": "Invalid 422 response format."};
        }
      }

      else if (response.statusCode == 401) {
        debugPrint('Unauthorized (401)');
        try {
          final decoded = json.decode(response.body);
          final msg = decoded is Map && decoded.containsKey("detail")
              ? decoded['detail']
              : "Unauthenticated. Please log in again.";
          return {"status": 2, "message": msg};
        } catch (e) {
          return {"status": 2, "message": "Unauthenticated. Please log in again."};
        }
      }

      else if (response.statusCode == 500) {
        debugPrint('Server Error (500)');
        return {"status": 0, "message": "Internal server error. Please try again later."};
      }

      else if (response.statusCode == 400) {
        final decoded = json.decode(response.body);
        debugPrint('Bad Request(400)');
        return {"status": 0, "message": decoded};
      }

      else if (response.statusCode == 404) {
        debugPrint('Not Found (404)');
        return {"status": 0, "message": "Requested resource not found."};
      }

      else if (response.statusCode == 403) {
        debugPrint('Forbidden (403)');
        return {"status": 0, "message": "You don't have permission to access this resource."};
      }

      else {
        debugPrint('Unexpected Status → ${response.statusCode}');
        return {
          "status": 0,
          "message": "Unexpected error (${response.statusCode}): ${response.reasonPhrase}",
          "body": response.body,
        };
      }
    } catch (e, stackTrace) {
      debugPrint('FATAL in _handleResponse → $e\n$stackTrace');
      return {
        "status": 0,
        "message": "An unexpected error occurred while handling the response.",
      };
    }
  }
}
