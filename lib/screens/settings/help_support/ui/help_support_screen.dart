import 'package:flutter/material.dart';
import 'package:flutter_app/screens/settings/help_support/notifier/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme.dart';

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      ref.read(settingsNotifierProvider.notifier).loadSettings();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppTheme.ssjsSecondaryBlue,
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
                    'How can we help you?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers to common questions or contact our support team',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Quick Contact Options
            _buildSectionHeader(context, 'Contact Us'),
            _buildContactOption(
              context,
              icon: Icons.phone,
              title: 'Call Support',
              subtitle: '+91 9876543210',
              onTap: () {
                _showContactDialog(context, 'Call', '+91 9876543210');
              },
            ),
            _buildContactOption(
              context,
              icon: Icons.email,
              title: 'Email Support',
              subtitle: 'support@shreejalore.com',
              onTap: () {
                _showContactDialog(context, 'Email', 'support@shreejalore.com');
              },
            ),
            _buildContactOption(
              context,
              icon: Icons.chat,
              title: 'WhatsApp Support',
              subtitle: '+91 9876543210',
              onTap: () {
                _showContactDialog(context, 'WhatsApp', '+91 9876543210');
              },
            ),

            const Divider(height: 32),

            // FAQs
            _buildSectionHeader(context, 'Frequently Asked Questions'),
            _buildFAQTile(
              context,
              question: 'How do I update my profile?',
              answer:
                  'Go to Profile > Edit Profile. Update your information and tap Save Changes.',
            ),
            _buildFAQTile(
              context,
              question: 'How can I add family help_support?',
              answer:
                  'Navigate to Profile > Family Details, then tap the + button to add family help_support.',
            ),
            _buildFAQTile(
              context,
              question: 'How do I search for help_support?',
              answer:
                  'Go to Find A Member from the home screen. Use the search bar to find help_support by name, business, or location.',
            ),
            _buildFAQTile(
              context,
              question: 'How can I register for events?',
              answer:
                  'Go to Events section, select an event, and tap the Register button. You will receive confirmation via notification.',
            ),
            _buildFAQTile(
              context,
              question: 'How do I change my password?',
              answer:
                  'Currently, you can use the Forgot Password option on the login screen to reset your password via OTP.',
            ),
            _buildFAQTile(
              context,
              question: 'How can I report an issue?',
              answer:
                  'Contact our support team via phone, email, or WhatsApp. We typically respond within 24 hours.',
            ),

            const Divider(height: 32),

            // Additional Resources
            _buildSectionHeader(context, 'Additional Resources'),
            _buildResourceTile(
              context,
              icon: Icons.article,
              title: 'User Guide',
              onTap: () {
                _showUserGuideDialog(context);
              },
            ),
            _buildResourceTile(
              context,
              icon: Icons.policy,
              title: 'Privacy Policy',
              onTap: () {
                _showPrivacyPolicyDialog(context);
              },
            ),
            _buildResourceTile(
              context,
              icon: Icons.description,
              title: 'Terms of Service',
              onTap: () {
                _showTermsDialog(context);
              },
            ),
            _buildResourceTile(
              context,
              icon: Icons.feedback,
              title: 'Send Feedback',
              onTap: () {
                _showFeedbackDialog(context);
              },
            ),

            const SizedBox(height: 32),

            // App Version
            Center(
              child: Column(
                children: [
                  Text(
                    'Shri Jalore Jain Sangh Chennai',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
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

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryBlue.withAlpha(51),
        child: Icon(icon, color: AppTheme.primaryBlue),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildFAQTile(BuildContext context, {required String question, required String answer}) {
    return ExpansionTile(
      leading: const Icon(Icons.help_outline, color: AppTheme.primaryBlue),
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(72, 0, 16, 16),
          child: Text(
            answer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textGrey,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildResourceTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showContactDialog(BuildContext context, String type, String contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact via $type'),
        content: Text('Opening $type: $contact'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening $type...')),
              );
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  void _showUserGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Guide'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Shri Jalore Jain Sangh Chennai App',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('1. Dashboard: Access all features from the home screen'),
              SizedBox(height: 8),
              Text('2. Find Members: Search and connect with community help_support'),
              SizedBox(height: 8),
              Text('3. Events: View and register for upcoming events'),
              SizedBox(height: 8),
              Text('4. News: Stay updated with community news'),
              SizedBox(height: 8),
              Text('5. Gallery: Browse photo galleries'),
              SizedBox(height: 8),
              Text('6. Profile: Manage your personal and business information'),
            ],
          ),
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

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'We respect your privacy and are committed to protecting your personal data. '
            'This app collects and uses data to provide community services. '
            'Your information is stored securely and is not shared with third parties without consent.',
          ),
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

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using this app, you agree to our terms of service. '
            'This app is designed for community help_support to connect and stay informed. '
            'Please use the app respectfully and follow community guidelines.',
          ),
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
  void _showFeedbackDialog(BuildContext context) {
    final feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: TextField(
          controller: feedbackController,
          // ...
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Just pop
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = feedbackController.text;
              Navigator.pop(context);
              // Handle feedback text here
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    ).then((_) => feedbackController.dispose()); // Dispose here!
  }
}
