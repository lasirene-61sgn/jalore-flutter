import 'package:flutter/material.dart';
import '../config/theme.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildNoticeCard(
              context,
              title: 'Annual General Meeting',
              date: 'Coming Soon',
              description:
                  'The Annual General Meeting will be held next month. All members are requested to attend.',
              priority: 'High',
            ),
            _buildNoticeCard(
              context,
              title: 'New Member Registration',
              date: 'Coming Soon',
              description:
                  'New member registration is now open. Please submit your application forms at the earliest.',
              priority: 'Medium',
            ),
            _buildNoticeCard(
              context,
              title: 'Community Hall Booking',
              date: 'Coming Soon',
              description:
                  'Community hall is available for booking for personal and business events. Contact the office for more details.',
              priority: 'Low',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeCard(
    BuildContext context, {
    required String title,
    required String date,
    required String description,
    required String priority,
  }) {
    Color priorityColor;
    switch (priority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    priority,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.textGrey,
                ),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textGrey,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
