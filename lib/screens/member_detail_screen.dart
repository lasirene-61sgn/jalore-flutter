import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import '../screens/members/model/member_model.dart';
import 'profile/ui/profile_edit_screen.dart';

class MemberDetailScreen extends StatelessWidget {
  final Member member;

  const MemberDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(member.name),
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: () {
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(
        //       //     builder: (context) => ProfileEditScreen(member: member),
        //       //   ),
        //       // );
        //     },
        //   ),
        // ],
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
                      child: member.image != null
                          ? ClipOval(
                              child: Image.network(
                                member.image!,
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
                  if (member.whatsapp != null)
                    _buildInfoRow(context, 'Email', member.whatsapp!, Icons.email),
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
                      DateFormat('yyyy MMM dd').format(member.dateOfBirth!),
                      Icons.cake,
                    ),
                  if (member.anniversaryDate != null)
                    _buildInfoRow(
                      context,
                      'Anniversary',
                      DateFormat('yyyy MMM dd').format(member.anniversaryDate!),
                      Icons.favorite,
                    ),
                ],
              ),

              if (member.businessType != null)
                _buildSection(
                  context,
                  title: 'Business Information',
                  children: [
                    if (member.businessType != null)
                      _buildInfoRow(context, 'Business Type', member.businessType!, Icons.business),
                    if (member.productService != null)
                      _buildInfoRow(context, 'Products/Services', member.productService!, Icons.inventory),
                  ],
                ),

              // Address Information
// Family Members Section
              // Family Members Section (simple continuous style, no image)
              // Family Members Section (full details, null-safe, no image)
              if (member.familyMembers.isNotEmpty)
                _buildSection(
                  context,
                  title: 'Family Members',
                  children: member.familyMembers.map((fm) {
                    final List<Widget> rows = [];

                    void addRow(String label, String? value, IconData icon) {
                      if (value != null && value.trim().isNotEmpty) {
                        rows.add(_buildInfoRow(context, label, value, icon));
                      }
                    }

                    // Mandatory name
                    if (fm.name.trim().isNotEmpty) {
                      rows.add(
                        _buildInfoRow(context, 'Name', fm.name, Icons.person),
                      );
                    }

                    addRow('Relationship', fm.relationship, Icons.group);
                    addRow('Mobile', fm.mobile, Icons.phone);
                    addRow('Gender', fm.gender, Icons.wc);
                    addRow('Gotra', fm.gotra, Icons.account_tree);
                    addRow('Education', fm.education, Icons.school);
                    addRow('Occupation', fm.occupation, Icons.work);
                    addRow('Blood Group', fm.bloodGroup, Icons.bloodtype);
                    addRow('Hobbies', fm.hobbies, Icons.sports);
                    addRow('Native Place', fm.nativePlace, Icons.place);
                    addRow('Notes', fm.notes, Icons.note);

                    if (fm.dateOfBirth != null) {
                      rows.add(
                        _buildInfoRow(
                          context,
                          'Date of Birth',
                          DateFormat('yyyy MMM dd').format(fm.dateOfBirth!),
                          Icons.cake,
                        ),
                      );
                    }

                    if (fm.anniversaryDate != null) {
                      rows.add(
                        _buildInfoRow(
                          context,
                          'Anniversary',
                          DateFormat('yyyy MMM dd').format(fm.anniversaryDate!),
                          Icons.favorite,
                        ),
                      );
                    }

                    // Matrimony flag (only if true)
                    // if (fm.matrimony) {
                    //   rows.add(
                    //     _buildInfoRow(
                    //       context,
                    //       'Matrimony',
                    //       'Yes',
                    //       Icons.favorite_border,
                    //     ),
                    //   );
                    // }

                    // If no valid fields → render nothing
                    if (rows.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...rows,
                        const Divider(height: 24),
                      ],
                    );
                  }).toList(),
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
          if(member.mobile.isNotEmpty && label == 'Mobile')
            IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () async {
                final phone = member.mobile;
                if ( phone.isEmpty) {
                  return;
                }

                final Uri callUri = Uri(scheme: 'tel', path: phone);

                if (await canLaunchUrl(callUri)) {
                  await launchUrl(callUri);
                } else {
                  debugPrint('Could not launch dialer');
                }
              },
            ),
        ],
      ),
    );
  }
}
