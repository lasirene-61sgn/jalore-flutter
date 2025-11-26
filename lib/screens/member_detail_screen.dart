import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../models/member.dart';
import 'profile_edit_screen.dart';

class MemberDetailScreen extends StatelessWidget {
  final Member member;

  const MemberDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(member.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(member: member),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: AppTheme.backgroundGrey,
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundWhite,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryBlue, width: 3),
                      ),
                      child: member.profileImageUrl != null
                          ? ClipOval(
                              child: Image.network(
                                member.profileImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    color: AppTheme.primaryBlue,
                                    size: 80,
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: AppTheme.primaryBlue,
                              size: 80,
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      member.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Contact Information
              _buildSection(
                context,
                title: 'Contact Information',
                children: [
                  if (member.mobile.isNotEmpty)
                    _buildInfoRow(context, 'Mobile', member.mobile, Icons.phone),
                  if (member.secondaryMobile != null)
                    _buildInfoRow(context, 'Secondary Mobile', member.secondaryMobile!, Icons.phone),
                  if (member.email != null)
                    _buildInfoRow(context, 'Email', member.email!, Icons.email),
                ],
              ),

              // Personal Information
              _buildSection(
                context,
                title: 'Personal Information',
                children: [
                  if (member.fatherName != null)
                    _buildInfoRow(context, 'Father Name', member.fatherName!, Icons.person),
                  if (member.gender != null)
                    _buildInfoRow(context, 'Gender', member.gender!, Icons.wc),
                  if (member.age != null)
                    _buildInfoRow(context, 'Age', '${member.age} years', Icons.calendar_today),
                  if (member.education != null)
                    _buildInfoRow(context, 'Education', member.education!, Icons.school),
                  if (member.dateOfBirth != null)
                    _buildInfoRow(
                      context,
                      'Date of Birth',
                      DateFormat('dd MMM yyyy').format(member.dateOfBirth!),
                      Icons.cake,
                    ),
                  if (member.dateOfAnniversary != null)
                    _buildInfoRow(
                      context,
                      'Anniversary',
                      DateFormat('dd MMM yyyy').format(member.dateOfAnniversary!),
                      Icons.favorite,
                    ),
                ],
              ),

              // Business Information
              if (member.businessType != null || member.businessProducts != null)
                _buildSection(
                  context,
                  title: 'Business Information',
                  children: [
                    if (member.businessType != null)
                      _buildInfoRow(context, 'Business Type', member.businessType!, Icons.business),
                    if (member.businessProducts != null)
                      _buildInfoRow(context, 'Products/Services', member.businessProducts!, Icons.inventory),
                  ],
                ),

              // Address Information
              if (member.officeAddress != null ||
                  member.residenceAddress != null ||
                  member.jaloreAddress != null)
                _buildSection(
                  context,
                  title: 'Address Information',
                  children: [
                    if (member.officeAddress != null) ...[
                      _buildInfoRow(context, 'Office Address', member.officeAddress!, Icons.location_city),
                      if (member.officeNumber != null)
                        _buildInfoRow(context, 'Office Number', member.officeNumber!, Icons.phone),
                    ],
                    if (member.residenceAddress != null) ...[
                      _buildInfoRow(context, 'Residence Address', member.residenceAddress!, Icons.home),
                      if (member.residenceMobile != null)
                        _buildInfoRow(context, 'Residence Mobile', member.residenceMobile!, Icons.phone),
                    ],
                    if (member.jaloreAddress != null) ...[
                      _buildInfoRow(context, 'Jalore Address', member.jaloreAddress!, Icons.location_on),
                      if (member.jaloreContactNumber != null)
                        _buildInfoRow(context, 'Jalore Contact', member.jaloreContactNumber!, Icons.phone),
                    ],
                  ],
                ),

              // Family Image
              if (member.familyImageUrl != null)
                _buildSection(
                  context,
                  title: 'Family Image',
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.dividerGrey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          member.familyImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.family_restroom,
                                size: 64,
                                color: AppTheme.textGrey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textGrey,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
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
