import 'package:flutter/material.dart';
import '../config/theme.dart';

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppTheme.ssjsSecondaryBlue,
        title: const Text('HelpLine'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Emergency Contacts
            _buildSectionHeader(context, 'Emergency Contacts'),
            _buildContactCard(
              context,
              name: 'President',
              role: 'Shri Rajkumarji Sancheti',
              phone: '9876543210',
              icon: Icons.shield,
            ),
            _buildContactCard(
              context,
              name: 'Secretary',
              role: 'Shri Anilji Bhandari',
              phone: '9876543212',
              icon: Icons.admin_panel_settings,
            ),

            const SizedBox(height: 24),

            // Office Contact
            _buildSectionHeader(context, 'Office Contact'),
            _buildContactCard(
              context,
              name: 'Sirohi Bhawan',
              role: 'Chennai Office',
              phone: '044-1234567',
              icon: Icons.business,
            ),

            const SizedBox(height: 24),

            // Other Services
            _buildSectionHeader(context, 'Services'),
            _buildServiceCard(
              context,
              title: 'Medical Emergency',
              description: 'Contact for medical assistance',
              icon: Icons.local_hospital,
            ),
            _buildServiceCard(
              context,
              title: 'Legal Advice',
              description: 'Get legal consultation',
              icon: Icons.gavel,
            ),
            _buildServiceCard(
              context,
              title: 'Financial Help',
              description: 'Financial assistance for help_support',
              icon: Icons.account_balance,
            ),
            _buildServiceCard(
              context,
              title: 'Education Support',
              description: 'Scholarships and educational guidance',
              icon: Icons.school,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required String name,
    required String role,
    required String phone,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.backgroundWhite,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 16,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        phone,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.phone_in_talk),
              color: AppTheme.primaryBlue,
              onPressed: () {
                // Handle call action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling $phone...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.backgroundGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryBlue,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening $title...')),
          );
        },
      ),
    );
  }
}
