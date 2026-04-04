import 'package:flutter/material.dart';
import 'package:flutter_app/config/theme.dart';
import 'package:flutter_app/screens/matrimoney/model/matrimony_model.dart';
import 'package:intl/intl.dart';

class MatrimoneyDetailScreen extends StatelessWidget {
  final Matrimoney matrimoney;

  const MatrimoneyDetailScreen({
    super.key,
    required this.matrimoney,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        title: Text(matrimoney.familyMemberName),
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
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: AppTheme.backgroundWhite,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      matrimoney.familyMemberName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      matrimoney.familyMemberRelationship,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.textGrey),
                    ),
                  ],
                ),
              ),

              // Contact Information
              _buildSection(
                context,
                title: 'Contact Information',
                children: [
                  _buildInfoRow(
                    context,
                    'Family Head Member Mobile',
                    matrimoney.mobile,
                    Icons.phone,
                  ),
                  if (matrimoney.familyMemberMobile != null)
                    _buildInfoRow(
                      context,
                      'Mobile',
                      matrimoney.familyMemberMobile!,
                      Icons.phone_android,
                    ),
                ],
              ),

              // Personal Information
              _buildSection(
                context,
                title: 'Personal Information',
                children: [
                  if (matrimoney.fatherName != null)
                    _buildInfoRow(
                      context,
                      'Father Name',
                      matrimoney.fatherName!,
                      Icons.person,
                    ),
                  // if (matrimoney.education != null)
                  //   _buildInfoRow(
                  //     context,
                  //     'Education',
                  //     matrimoney.education!,
                  //     Icons.school,
                  //   ),
                  if (matrimoney.familyMemberEducation != null)
                    _buildInfoRow(
                      context,
                      'Member Education',
                      matrimoney.familyMemberEducation!,
                      Icons.school_outlined,
                    ),
                  if (matrimoney.familyMemberAge != null)
                    _buildInfoRow(
                      context,
                      'Age',
                      '${matrimoney.familyMemberAge} years',
                      Icons.cake,
                    ),
                  if (matrimoney.familyMemberDateOfBirth != null)
                    _buildInfoRow(
                      context,
                      'Date of Birth',
                      DateFormat('dd MMM yyyy')
                          .format(matrimoney.familyMemberDateOfBirth!),
                      Icons.calendar_today,
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

  Widget _buildInfoRow(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryBlue),
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
