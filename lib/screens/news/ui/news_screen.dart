import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../config/theme.dart';
import '../notifier/news_notifier.dart';
import '../model/news_model.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(newsNotifierProvider.notifier).loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        title: const Text('News'),
      ),
      body: SafeArea(
        child: Builder(
          builder: (_) {
            if (newsState.isLoading && newsState.newsList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (newsState.error != null) {
              return Center(
                child: Text(
                  newsState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (newsState.newsList.isEmpty) {
              return const Center(child: Text('No news available'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: newsState.newsList.length,
              itemBuilder: (context, index) {
                final news = newsState.newsList[index];
                return _buildNewsCard(context, news);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, News news) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                news.imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Center(
                    child: Icon(
                      Icons.article,
                      size: 64,
                      color: AppTheme.backgroundWhite,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),

          /// Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  news.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                /// Date + Status
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.textGrey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd MMM yyyy')
                          .format(news.postedDate),
                      style:
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textGrey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        news.status,
                        style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.backgroundWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Summary
                Text(
                  news.summary,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
