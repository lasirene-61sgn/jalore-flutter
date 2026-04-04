// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/services/local_storage/shared_preference.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
//
// class NotificationState {
//   final bool isSaving;
//   final String? error;
//   final bool isSuccess;
//
//   const NotificationState({
//     this.isSaving = false,
//     this.error,
//     this.isSuccess = false,
//   });
//
//   NotificationState copyWith({bool? isSaving, String? error, bool? isSuccess}) {
//     return NotificationState(
//       isSaving: isSaving ?? this.isSaving,
//       error: error,
//       isSuccess: isSuccess ?? this.isSuccess,
//     );
//   }
// }
//
// class NotificationNotifier extends StateNotifier<NotificationState> {
//   NotificationNotifier() : super(const NotificationState());
//
//   final String projectId = "295177509530";
//   final String serverAccessToken = "ya29.a0Aa7pCA_ye241yc6X5wgvmd595N3P7Pdh-CA_k6nE8TdySRySk_0vOX-ijACTy0n9nAw14HicSHXhzKrxZh_3UTrYpV64Xt5DVFcENq0hA0VKDxJMUuRDPsBnhsXpUh0r3WAqNLPL1-lT-s62hXBkDubnPAyXY6v5NCvWXfChFCtpUF6XFMojJADYvpJ_TiXg8pAAFCsaCgYKAW4SARESFQHGX2MiBgdEWGyPBae_wm-d5oDD6A0206";
//
//   Future<void> sendNotification() async {
//     state = state.copyWith(isSaving: true, error: null, isSuccess: false);
//
//     final String url = "https://fcm.googleapis.com/v1/projects/$projectId/messages:send";
//
//     final String? dToken = SharedPreferencesHelper().getString("DToken");
//
//
//     final Map<String, dynamic> payload = {
//       "message": {
//         "token": dToken,
//         "notification": {
//           "title": "heyy this my Test",
//           "body": "hello",
//         },
//         "data": {
//           "click_action": "FLUTTER_NOTIFICATION_CLICK",
//           "id": "1",
//           "status": "done"
//         }
//       }
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $serverAccessToken',
//         },
//         body: jsonEncode(payload),
//       );
//
//       if (response.statusCode == 200) {
//         state = state.copyWith(isSaving: false, isSuccess: true);
//         debugPrint("Notification sent successfully");
//       } else {
//         state = state.copyWith(
//             isSaving: false,
//             error: "Failed: ${response.statusCode} - ${response.body}"
//         );
//         debugPrint("Error: ${response.body}");
//       }
//     } catch (e) {
//       state = state.copyWith(isSaving: false, error: e.toString());
//     }
//   }
// }
//
// final notificationNotifierProvider = StateNotifierProvider<NotificationNotifier, NotificationState>(
//       (ref) => NotificationNotifier(),
// );