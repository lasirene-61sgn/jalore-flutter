import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/api/api_client/api_client.dart';
import 'package:flutter_app/services/api/repo/repo.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/screens/members/model/member_model.dart';

/// ======================
/// STATE
/// ======================
// Update in member_notifier.dart

class MembersState {
  final bool isLoading;
  final List<Member> allMembers;
  final List<Member> membersList;
  final List<Member> filteredList; // Add this to hold the viewable list
  final String? error;

  const MembersState({
    this.isLoading = false,
    this.allMembers = const [],
    this.membersList = const [],
    this.filteredList = const [],
    this.error,
  });

  MembersState copyWith({
    bool? isLoading,
    List<Member>? allMembers,
    List<Member>? membersList,
    List<Member>? filteredList,
    String? error,
  }) {
    return MembersState(
      isLoading: isLoading ?? this.isLoading,
      allMembers: allMembers ?? this.allMembers,
      membersList: membersList ?? this.membersList,
      filteredList: filteredList ?? this.filteredList,
      error: error,
    );
  }
}

class MembersNotifier extends StateNotifier<MembersState> {
  MembersNotifier() : super(const MembersState());

  Future<void> loadMembers(String url) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiClient().get(url);
      if (response["status"] == 1) {
        final dynamic rawData = response['data']?['data'];
        if (rawData is List) {
          final members = rawData.map((e) => Member.fromJson(e)).toList();
          state = state.copyWith(
              isLoading: false,
              allMembers: members,
              membersList: members,
              filteredList: members
          );
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  void filterByField(String fieldName, String value) {
    final results = state.allMembers.where((m) {
      switch (fieldName) {
        case 'Gotra': return m.gotra == value;
        case 'Area': return m.area == value;
        case 'Street/Road': return m.streetRoad == value;
        case 'Pincode': return m.pincode == value;
        default: return true;
      }
    }).toList();
    state = state.copyWith(membersList: results);
  }

  // Method to reset filter
  void resetFilter() {
    state = state.copyWith(filteredList: state.membersList);
  }
}

// /// ======================
// /// NOTIFIER
// /// ======================
// class MembersNotifier extends StateNotifier<MembersState> {
//   MembersNotifier() : super(const MembersState());
//   // inside MembersNotifier class in member_notifier.dart
//   Future<void> loadMembers(String url) async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final response = await ApiClient().get(url);
//       if (response["status"] == 1) {
//         final dynamic rawData = response['data']?['data'];
//         if (rawData is List) {
//           final members = rawData.map((e) => Member.fromJson(e)).toList();
//           state = state.copyWith(
//               isLoading: false,
//               membersList: members,
//               filteredList: members // Initially, both are the same
//           );
//         }
//       }
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }
//   void filterByName(String name) {
//     final results = state.membersList
//         .where((m) => m.name.toLowerCase() == name.toLowerCase())
//         .toList();
//     state = state.copyWith(filteredList: results);
//   }
//
//   // Method to reset filter
//   void resetFilter() {
//     state = state.copyWith(filteredList: state.membersList);
//   }
//
// }

/// ======================
/// PROVIDER
/// ======================
final membersNotifierProvider =
StateNotifierProvider<MembersNotifier, MembersState>(
      (ref) => MembersNotifier(),
);
