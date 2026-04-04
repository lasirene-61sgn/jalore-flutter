import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _showPhoneNumber = true;
  bool _showEmail = true;
  bool _showAddress = false;
  bool _showBusinessInfo = true;
  bool _allowProfileSearch = true;
  bool _showInDirectory = true;
  bool _shareDataWithPartners = false;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showPhoneNumber = prefs.getBool('show_phone_number') ?? true;
      _showEmail = prefs.getBool('show_email') ?? true;
      _showAddress = prefs.getBool('show_address') ?? false;
      _showBusinessInfo = prefs.getBool('show_business_info') ?? true;
      _allowProfileSearch = prefs.getBool('allow_profile_search') ?? true;
      _showInDirectory = prefs.getBool('show_in_directory') ?? true;
      _shareDataWithPartners = prefs.getBool('share_data_with_partners') ?? false;
    });
  }

  Future<void> _savePrivacySetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings updated'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor:AppTheme.ssjsSecondaryBlue,
        foregroundColor: AppTheme.backgroundWhite,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Control your privacy',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage what information is visible to other community help_support',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                ],
              ),
            ),

            // Profile Visibility
            _buildSectionHeader('Profile Visibility'),
            _buildSwitchTile(
              title: 'Show Phone Number',
              subtitle: 'Allow help_support to see your phone number',
              icon: Icons.phone,
              value: _showPhoneNumber,
              onChanged: (value) {
                setState(() {
                  _showPhoneNumber = value;
                });
                _savePrivacySetting('show_phone_number', value);
              },
            ),
            _buildSwitchTile(
              title: 'Show Email Address',
              subtitle: 'Allow help_support to see your email',
              icon: Icons.email,
              value: _showEmail,
              onChanged: (value) {
                setState(() {
                  _showEmail = value;
                });
                _savePrivacySetting('show_email', value);
              },
            ),
            _buildSwitchTile(
              title: 'Show Address',
              subtitle: 'Display your address in profile',
              icon: Icons.location_on,
              value: _showAddress,
              onChanged: (value) {
                setState(() {
                  _showAddress = value;
                });
                _savePrivacySetting('show_address', value);
              },
            ),
            _buildSwitchTile(
              title: 'Show Business Information',
              subtitle: 'Display your business details',
              icon: Icons.business,
              value: _showBusinessInfo,
              onChanged: (value) {
                setState(() {
                  _showBusinessInfo = value;
                });
                _savePrivacySetting('show_business_info', value);
              },
            ),

            const Divider(height: 32),

            // Directory & Search
            _buildSectionHeader('Directory & Search'),
            _buildSwitchTile(
              title: 'Show in Member Directory',
              subtitle: 'Appear in the searchable member directory',
              icon: Icons.people,
              value: _showInDirectory,
              onChanged: (value) {
                setState(() {
                  _showInDirectory = value;
                });
                _savePrivacySetting('show_in_directory', value);
              },
            ),
            _buildSwitchTile(
              title: 'Allow Profile Search',
              subtitle: 'Let others find you by name or phone',
              icon: Icons.search,
              value: _allowProfileSearch,
              onChanged: (value) {
                setState(() {
                  _allowProfileSearch = value;
                });
                _savePrivacySetting('allow_profile_search', value);
              },
            ),

            const Divider(height: 32),

            // Data Sharing
            _buildSectionHeader('Data Sharing'),
            _buildSwitchTile(
              title: 'Share Data with Partners',
              subtitle: 'Allow data sharing for community events',
              icon: Icons.share,
              value: _shareDataWithPartners,
              onChanged: (value) {
                setState(() {
                  _shareDataWithPartners = value;
                });
                _savePrivacySetting('share_data_with_partners', value);
              },
            ),

            const Divider(height: 32),

            // Additional Options
            _buildSectionHeader('Additional Options'),
            _buildOptionTile(
              title: 'Data Export',
              subtitle: 'Download your personal data',
              icon: Icons.download,
              onTap: () {
                _showDataExportDialog();
              },
            ),
            // _buildOptionTile(
            //   title: 'Delete Account',
            //   subtitle: 'Permanently delete your account',
            //   icon: Icons.delete_forever,
            //   textColor: Colors.red,
            //   onTap: () {
            //     _showDeleteAccountDialog();
            //   },
            // ),
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

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppTheme.primaryBlue),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textGrey),
      onTap: onTap,
    );
  }

  void _showDataExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Your Data'),
        content: const Text(
          'Your personal data will be compiled and sent to your registered email address within 24 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data export request submitted. Check your email within 24 hours.'),
                ),
              );
            },
            child: const Text('Request Export'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion request submitted. Our team will contact you shortly.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
