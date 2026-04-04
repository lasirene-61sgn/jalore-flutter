import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/screens/auth/login/notifier/login_notifier.dart';
import 'package:flutter_app/screens/profile/notifier/profile_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme.dart';
import 'profile_edit_screen.dart';
import '../../auth/login/ui/login_screen.dart';
import '../../settings/business_information_screen.dart';
import 'family_details_screen.dart';
import '../../notification/ui/notifications_screen.dart';
import '../../settings/privacy_settings_screen.dart';
import '../../settings/help_support/ui/help_support_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {


  @override
  void initState() {
    super.initState();
    Future.microtask((){
      ref.read(profileNotifierProvider.notifier).loadProfile();
    });

  }


  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final profile = profileState.profile;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        title: const Text('Profile'),
        actions: [
          if (profile != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEditScreen(),
                  ),
                );
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
        child: profileState.isLoading && profileState.profile == null
            ? const Center(child: CircularProgressIndicator())
            : profile == null
                ? const Center(child: Text('No profile found'))
                : SingleChildScrollView(
                    child: Column(
                      children: [
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
                                child: ClipOval(
                                  child: profile.image != null && profile.image!.isNotEmpty
                                      ? Image.network(
                                    profile.image!,
                                    fit: BoxFit.cover,
                                    // --- LOADING STATE ---
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                                    // --- ERROR STATE ---
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      Icons.person,
                                      color: AppTheme.primaryBlue,
                                      size: 80,
                                    ),
                                  )
                                      : const Icon(
                                    Icons.person,
                                    color: AppTheme.primaryBlue,
                                    size: 80,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                profile.name,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                profile.mobile,
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
                                builder: (context) => ProfileEditScreen(),
                              ),
                            );
                          },
                        ),
                        // _buildProfileOption(
                        //   context,
                        //   icon: Icons.business,
                        //   title: 'Business Information',
                        //   subtitle: _currentUser!.businessType ?? 'Not set',
                        //   onTap: () async {
                        //     final result = await Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => BusinessInformationScreen(member: _currentUser!),
                        //       ),
                        //     );
                        //     if (result != null) {
                        //       _loadUserProfile();
                        //     }
                        //   },
                        // ),
                        _buildProfileOption(
                          context,
                          icon: Icons.family_restroom,
                          title: 'Family Details',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FamilyDetailsScreen(),
                              ),
                            );
                          },
                        ),
                        // _buildProfileOption(
                        //   context,
                        //   icon: Icons.notifications,
                        //   title: 'Notifications',
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const NotificationsScreen(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        // _buildProfileOption(
                        //   context,
                        //   icon: Icons.privacy_tip,
                        //   title: 'Privacy Settings',
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const PrivacySettingsScreen(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        // _buildProfileOption(
                        //   context,
                        //   icon: Icons.help,
                        //   title: 'Help & Support',
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const HelpSupportScreen(),
                        //       ),
                        //     );
                        //   },
                        // ),
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
      onTap: () {
        if (kDebugMode) {
          debugPrint('Profile option tapped: $title');
        }
        onTap();
      },
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
            onPressed: () async {
              await ref.read(loginProvider.notifier).logout();
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
              'Shri Jalore Jain Sangh Chennai',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Chennai Community App'),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'This app helps community help_support connect, share information, and stay updated with events and news.',
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
