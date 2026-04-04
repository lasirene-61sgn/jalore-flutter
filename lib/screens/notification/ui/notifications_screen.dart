import 'package:flutter/material.dart';
import 'package:flutter_app/screens/dashboard/notifier/dashboard_notifier.dart';
import 'package:flutter_app/screens/notification/notifier/notification_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/theme.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;
  bool _eventReminders = false;
  bool _newsUpdates = false;
  bool _birthdayReminders = false;
  bool _anniversaryReminders = false;
  bool _galleryAnnouncements = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? false;
      _emailNotifications = prefs.getBool('email_notifications') ?? false;
      _smsNotifications = prefs.getBool('sms_notifications') ?? false;
      _eventReminders = prefs.getBool('event_reminders') ?? false;
      _newsUpdates = prefs.getBool('news_updates') ?? false;
      _birthdayReminders = prefs.getBool('birthday_reminders') ?? false;
      _anniversaryReminders = prefs.getBool('anniversary_reminders') ?? false;
      _galleryAnnouncements = prefs.getBool('gallery_updates') ?? false;
    });
  }

  Future<void> _saveNotificationSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);

    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings updated'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        foregroundColor: AppTheme.backgroundWhite,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Manage your notification preferences',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textGrey,
                    ),
              ),
            ),

            // Notification Channels
            _buildSectionHeader('Notification Channels'),
            _buildSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Receive notifications on your device',
              icon: Icons.notifications_active,
              value: _pushNotifications,
              onChanged: (value) async {
                setState(() {
                  _pushNotifications = value;
                });
                _saveNotificationSetting('push_notifications', value);
                // await  ref.read(notificationNotifierProvider.notifier).sendNotification();
              },
            ),
            _buildSwitchTile(
              title: 'Email Notifications',
              subtitle: 'Receive updates via email',
              icon: Icons.email,
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
                _saveNotificationSetting('email_notifications', value);
              },
            ),
            _buildSwitchTile(
              title: 'SMS Notifications',
              subtitle: 'Receive important alerts via SMS',
              icon: Icons.sms,
              value: _smsNotifications,
              onChanged: (value) {
                setState(() {
                  _smsNotifications = value;
                });
                _saveNotificationSetting('sms_notifications', value);
              },
            ),

            const Divider(height: 32),

            // Notification Types
            _buildSectionHeader('Notification Types'),
            _buildSwitchTile(
              title: 'Event Reminders',
              subtitle: 'Get notified about upcoming events',
              icon: Icons.event,
              value: _eventReminders,
              onChanged: (value) async {
                setState(() {
                  _eventReminders = value;
                });
                _saveNotificationSetting('event_reminders', value);

               await ref.read(dashboardNotifierProvider.notifier).loadNotification();
              },
            ),
            _buildSwitchTile(
              title: 'News Updates',
              subtitle: 'Stay informed about community news',
              icon: Icons.newspaper,
              value: _newsUpdates,
              onChanged: (value) async {
                setState(() {
                  _newsUpdates = value;
                });
                _saveNotificationSetting('news_updates', value);

                await ref.read(dashboardNotifierProvider.notifier).loadNotification();
              },
            ),
            _buildSwitchTile(
              title: 'Birthday Reminders',
              subtitle: 'Get reminded of member birthdays',
              icon: Icons.cake,
              value: _birthdayReminders,
              onChanged: (value) async {
                setState(() {
                  _birthdayReminders = value;
                });
                _saveNotificationSetting('birthday_reminders', value);

                await ref.read(dashboardNotifierProvider.notifier).loadNotification();
              },
            ),
            _buildSwitchTile(
              title: 'Anniversary Reminders',
              subtitle: 'Get reminded of member anniversaries',
              icon: Icons.celebration,
              value: _anniversaryReminders,
              onChanged: (value) async {
                setState(() {
                  _anniversaryReminders = value;
                });
                _saveNotificationSetting('anniversary_reminders', value);

                await ref.read(dashboardNotifierProvider.notifier).loadNotification();
              },
            ),
            _buildSwitchTile(
              title: 'Gallery Updates',
              subtitle: 'New updates from gallery',
              icon: Icons.campaign,
              value: _galleryAnnouncements,
              onChanged: (value) async {
                setState(() {
                  _galleryAnnouncements = value;
                });
                _saveNotificationSetting('gallery_updates', value);

                await ref.read(dashboardNotifierProvider.notifier).loadNotification();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(icon, color: AppTheme.primaryBlue),
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppTheme.primaryBlue.withAlpha(128),
      activeThumbColor: AppTheme.primaryBlue,
    );
  }
}
