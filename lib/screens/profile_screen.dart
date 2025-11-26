import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/data_service.dart';
import '../models/member.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Member? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Load first member as current user (demo)
      final members = await DataService.getAllMembers();
      if (members.isNotEmpty) {
        setState(() {
          _currentUser = members.first;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_currentUser != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEditScreen(member: _currentUser!),
                  ),
                );
                // Reload profile after editing
                _loadUserProfile();
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _currentUser == null
                ? const Center(child: Text('No profile found'))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Profile Header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          color: AppTheme.backgroundGrey,
                          child: Column(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppTheme.backgroundWhite,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.primaryBlue,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppTheme.primaryBlue,
                                  size: 80,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _currentUser!.name,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _currentUser!.mobile,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textGrey,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        // Profile Options
                        _buildProfileOption(
                          context,
                          icon: Icons.person,
                          title: 'Edit Profile',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileEditScreen(member: _currentUser!),
                              ),
                            );
                            _loadUserProfile();
                          },
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.business,
                          title: 'Business Information',
                          subtitle: _currentUser!.businessType ?? 'Not set',
                          onTap: () {},
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.family_restroom,
                          title: 'Family Details',
                          onTap: () {},
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.notifications,
                          title: 'Notifications',
                          onTap: () {},
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.privacy_tip,
                          title: 'Privacy Settings',
                          onTap: () {},
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.help,
                          title: 'Help & Support',
                          onTap: () {},
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.info,
                          title: 'About App',
                          onTap: () {
                            _showAboutDialog(context);
                          },
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.logout,
                          title: 'Logout',
                          textColor: Colors.red,
                          onTap: () {
                            _showLogoutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.dividerGrey),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: textColor ?? AppTheme.primaryBlue,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textGrey,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textGrey,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shree Sirohi Jain Sangh',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Chennai Community App'),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'This app helps community members connect, share information, and stay updated with events and news.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
