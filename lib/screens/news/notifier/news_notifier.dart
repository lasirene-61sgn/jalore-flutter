import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/api/api_client/api_client.dart';
import 'package:flutter_app/services/api/repo/repo.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/screens/news/model/news_model.dart';

/// ======================
/// STATE
/// ======================
class NewsState {
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;
  final String? error;
  final List<News> newsList;
  final News? selectedNews;

  const NewsState({
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
    this.error,
    this.newsList = const [],
    this.selectedNews,
  });

  NewsState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    String? error,
    List<News>? newsList,
    News? selectedNews,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
      newsList: newsList ?? this.newsList,
      selectedNews: selectedNews ?? this.selectedNews,
    );
  }
}

/// ======================
/// NOTIFIER
/// ======================
class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier() : super(const NewsState());

  /// Load News List
  Future<void> loadNews() async {
    state = state.copyWith(
      isLoading: true,
      isLoaded: false,
      error: null,
    );

    try {
      final response = await ApiClient().get('api/customer/news');

      if (response["status"] == 1) {
        print("RAW RESPONSE: $response");

        final dynamic rawData = response['data']?['data'];

        if (rawData != null && rawData is List) {
          final news = rawData
              .map((e) => News.fromJson(e as Map<String, dynamic>))
              .toList();

          state = state.copyWith(
            isLoading: false,
            isLoaded: true,
            newsList: news,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            isLoaded: true,
            newsList: const [],
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Server returned error status',
        );
      }
    } catch (e, s) {
      print("NEWS LOAD ERROR: $e");
      print(s);

      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load news',
      );
    }
  }

  /// Create / Update News
  Future<void> submitNews(
      BuildContext context,
      Map<String, dynamic> payload, {
        String? newsId,
        PlatformFile? profilePhoto,
        PlatformFile? aadharPhoto,
      }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final isCreate = newsId == null || newsId.isEmpty;

      final response = await Repo().adminsPost(
        isCreate ? 'POST' : 'PUT',
        isCreate
            ? 'user/Admin/registration/'
            : 'user/Admin/update/$newsId/',
        payload,
        profilePhoto: profilePhoto,
        aadharPhoto: aadharPhoto,
      );

      if (response['status'] == 1) {
        await loadNews();
      }
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to save news',
      );
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  /// Load Single News Details
  Future<void> loadNewsDetails(String id) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final response = await Repo().adminDetails(id);
      final news = News.fromJson(response['data']);

      state = state.copyWith(
        isSaving: false,
        selectedNews: news,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to load news details',
      );
    }
  }
}

/// ======================
/// PROVIDER
/// ======================
final newsNotifierProvider =
StateNotifierProvider<NewsNotifier, NewsState>(
      (ref) => NewsNotifier(),
);