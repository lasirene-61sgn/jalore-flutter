import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../config/theme.dart';
import '../notifier/notice_notifier.dart';
import '../model/notice_model.dart';

class NoticeScreen extends ConsumerStatefulWidget {
  const NoticeScreen({super.key});

  @override
  ConsumerState<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(noticeNotifierProvider.notifier).loadNotices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final noticeState = ref.watch(noticeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        title: const Text('Notices'),
      ),
      body: SafeArea(
        child: Builder(
          builder: (_) {
            if (noticeState.isLoading && noticeState.noticeList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (noticeState.error != null) {
              return Center(
                child: Text(
                  noticeState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (noticeState.noticeList.isEmpty) {
              return const Center(child: Text('No notices available'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: noticeState.noticeList.length,
              itemBuilder: (context, index) {
                final notice = noticeState.noticeList[index];
                return _buildNoticeCard(context, notice);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoticeCard(BuildContext context, Notice notice) {
    final statusColor = notice.status == 'active'
        ? Colors.green
        : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    notice.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    notice.status,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.textGrey,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd MMM yyyy')
                      .format(notice.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Description
            Text(
              notice.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
