import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/theme.dart';
import 'package:flutter_app/screens/matrimoney/model/matrimony_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/utils/pdf_viewer_helper.dart';

class MatrimoneyDetailScreen extends StatelessWidget {
  final Matrimoney matrimoney;

  const MatrimoneyDetailScreen({
    super.key,
    required this.matrimoney,
  });

  @override
  Widget build(BuildContext context) {
    final displayImage = (matrimoney.familyMemberImage != null && matrimoney.familyMemberImage!.isNotEmpty)
        ? matrimoney.familyMemberImage
        : (matrimoney.image != null && matrimoney.image!.isNotEmpty ? matrimoney.image : null);

    final displayBg = (matrimoney.backgroundImage != null && matrimoney.backgroundImage!.isNotEmpty)
        ? matrimoney.backgroundImage
        : null;

    final primaryPhone = (matrimoney.familyMemberMobile != null && matrimoney.familyMemberMobile!.isNotEmpty)
        ? matrimoney.familyMemberMobile
        : (matrimoney.mobile.isNotEmpty ? matrimoney.mobile : null);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible AppBar with Background & Profile Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.primaryBlue,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  if (displayBg != null)
                    CachedNetworkImage(
                      imageUrl: displayBg,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.primaryBlue.withOpacity(0.2),
                        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF4DA6FF), AppTheme.primaryBlue],
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF4DA6FF), AppTheme.primaryBlue],
                        ),
                      ),
                    ),
                  
                  // Dark overlay for contrast
                  Container(
                    color: Colors.black.withOpacity(0.35),
                  ),

                  // Profile Image and Header Info overlaid
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Profile Avatar
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: displayImage != null
                                ? CachedNetworkImage(
                                    imageUrl: displayImage,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.white,
                                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.white,
                                      child: const Icon(Icons.person, size: 50, color: AppTheme.primaryBlue),
                                    ),
                                  )
                                : Container(
                                    color: Colors.white,
                                    child: const Icon(Icons.person, size: 50, color: AppTheme.primaryBlue),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Basic profile text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                matrimoney.familyMemberName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                matrimoney.familyMemberRelationship,
                                style: TextStyle(
                                  color: Color(0xE6FFFFFF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  shadows: const [
                                    Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions Bar (Call, Message, Whatsapp) if mobile is present
                  if (primaryPhone != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickAction(
                          context,
                          icon: const Icon(Icons.call, color: Colors.green, size: 24),
                          color: Colors.green,
                          label: 'Call',
                          onTap: () => launchUrl(Uri.parse('tel:$primaryPhone')),
                        ),
                        _buildQuickAction(
                          context,
                          icon: const Icon(Icons.message, color: Colors.blue, size: 24),
                          color: Colors.blue,
                          label: 'SMS',
                          onTap: () => launchUrl(Uri.parse('sms:$primaryPhone')),
                        ),
                        _buildQuickAction(
                          context,
                          icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 24),
                          color: const Color(0xFF25D366),
                          label: 'WhatsApp',
                          onTap: () => launchUrl(Uri.parse('https://wa.me/$primaryPhone')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],



                  // Matrimony Profile Section (without title)
                  _buildCardSection(
                    context,
                    fields: [
                      _buildRowData(context, 'Name', matrimoney.familyMemberName),
                      _buildRowData(context, 'Relationship', matrimoney.familyMemberRelationship),
                      _buildRowData(context, 'Gender', matrimoney.gender),
                      if (matrimoney.familyMemberAge != null && matrimoney.familyMemberAge! > 0)
                        _buildRowData(context, 'Age', '${matrimoney.familyMemberAge} years'),
                      if (matrimoney.familyMemberDateOfBirth != null)
                        _buildRowData(
                          context,
                          'Date of Birth',
                          DateFormat('dd MMM yyyy').format(matrimoney.familyMemberDateOfBirth!),
                        ),
                      _buildRowData(context, 'Education', matrimoney.familyMemberEducation),
                      _buildRowData(context, 'Gotra', matrimoney.familyMemberGotra),
                      _buildRowData(context, 'Occupation', matrimoney.familyMemberOccupation),
                      _buildRowData(context, 'Blood Group', matrimoney.familyMemberBloodGroup),
                      _buildRowData(context, 'Hobbies', matrimoney.familyMemberHobbies),
                      _buildRowData(context, 'Native Place', matrimoney.familyMemberNativePlace),
                      _buildRowData(context, 'Notes', matrimoney.familyMemberNotes),
                      if (matrimoney.matrimonyLink != null && matrimoney.matrimonyLink!.isNotEmpty)
                        _buildRowData(context, 'Matrimony Link', matrimoney.matrimonyLink),
                      if (matrimoney.matrimonyPdf != null && matrimoney.matrimonyPdf!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 140,
                                child: Text(
                                  'Matrimony PDF',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Text(':  ', style: TextStyle(color: Colors.grey)),
                              Expanded(
                                child: InkWell(
                                  onTap: () => PdfViewerHelper.openOrDownloadPdf(context, matrimoney.matrimonyPdf!),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.picture_as_pdf, size: 16, color: Colors.blue),
                                      SizedBox(width: 6),
                                      Text(
                                        'View / Download PDF',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  // Customer / Guardian details (without title)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 12.0, left: 4.0),
                    child: Text(
                      "Member Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  _buildCardSection(
                    context,
                    fields: [
                      // Header with Guardian Avatar and Quick actions
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppTheme.primaryBlue.withOpacity(0.08),
                            backgroundImage: (matrimoney.image != null && matrimoney.image!.isNotEmpty)
                                ? NetworkImage(matrimoney.image!)
                                : null,
                            child: (matrimoney.image == null || matrimoney.image!.isEmpty)
                                ? const Icon(Icons.person, color: AppTheme.primaryBlue)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  matrimoney.name,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Guardian',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          if (matrimoney.mobile.isNotEmpty) ...[
                            IconButton(
                              icon: const Icon(Icons.call, color: Colors.green, size: 20),
                              onPressed: () => launchUrl(Uri.parse('tel:${matrimoney.mobile}')),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.message, color: Colors.blue, size: 20),
                              onPressed: () => launchUrl(Uri.parse('sms:${matrimoney.mobile}')),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 20),
                              onPressed: () => launchUrl(Uri.parse('https://wa.me/${matrimoney.mobile}')),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ],
                      ),
                      const Divider(height: 24, thickness: 0.8),

                      _buildRowData(context, 'Guardian Name', matrimoney.name),
                      _buildRowData(context, 'Guardian Father Name', matrimoney.fatherName),
                      _buildRowData(context, 'Guardian Mobile', matrimoney.mobile),
                      _buildRowData(context, 'WhatsApp', matrimoney.whatsapp),
                      _buildRowData(context, 'Email', matrimoney.email),
                      if (matrimoney.dateOfBirth != null)
                        _buildRowData(
                          context,
                          'Date of Birth',
                          DateFormat('dd MMM yyyy').format(matrimoney.dateOfBirth!),
                        ),
                      if (matrimoney.anniversaryDate != null)
                        _buildRowData(
                          context,
                          'Anniversary',
                          DateFormat('dd MMM yyyy').format(matrimoney.anniversaryDate!),
                        ),
                      _buildRowData(context, 'Village', matrimoney.village),
                      _buildRowData(context, 'Native Place', matrimoney.nativePlace),
                      _buildRowData(context, 'Gotra', matrimoney.gotra),
                      _buildRowData(context, 'Blood Group', matrimoney.bloodGroup),
                      _buildRowData(context, 'Hobbies', matrimoney.hobbies),
                      _buildRowData(context, 'Occupation', matrimoney.occupation),
                      _buildRowData(context, 'Business Name', matrimoney.businessName),
                      _buildRowData(context, 'Business Type', matrimoney.businessType),
                      _buildRowData(context, 'Product / Service', matrimoney.productService),
                      _buildRowData(context, 'Office Address', matrimoney.officeAddress),
                    ],
                  ),

                  // All Family Members (without title)
                  if (matrimoney.allFamilyMembers.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 12.0, left: 4.0),
                      child: Text(
                        "Family Members",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    ...matrimoney.allFamilyMembers.map((member) => Card(
                      elevation: 0.5,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with Avatar and Basic info
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppTheme.primaryBlue.withOpacity(0.08),
                                  backgroundImage: (member.image != null && member.image!.isNotEmpty)
                                      ? NetworkImage(member.image!)
                                      : null,
                                  child: (member.image == null || member.image!.isEmpty)
                                      ? const Icon(Icons.person, color: AppTheme.primaryBlue)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        member.name,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${member.relationship} • ${member.gender}',
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                if (member.mobile != null && member.mobile!.isNotEmpty) ...[
                                  IconButton(
                                    icon: const Icon(Icons.call, color: Colors.green, size: 20),
                                    onPressed: () => launchUrl(Uri.parse('tel:${member.mobile}')),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.message, color: Colors.blue, size: 20),
                                    onPressed: () => launchUrl(Uri.parse('sms:${member.mobile}')),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 20),
                                    onPressed: () => launchUrl(Uri.parse('https://wa.me/${member.mobile}')),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ],
                            ),
                            const Divider(height: 24, thickness: 0.8),
                            // Details rows
                            _buildRowData(context, 'Gender', member.gender),
                            if (member.mobile != null && member.mobile!.isNotEmpty)
                              _buildRowData(context, 'Mobile', member.mobile),
                            if (member.dateOfBirth != null)
                              _buildRowData(
                                context,
                                'Date of Birth',
                                DateFormat('dd MMM yyyy').format(member.dateOfBirth!),
                              ),
                            if (member.anniversaryDate != null)
                              _buildRowData(
                                context,
                                'Anniversary',
                                DateFormat('dd MMM yyyy').format(member.anniversaryDate!),
                              ),
                            _buildRowData(context, 'Gotra', member.gotra),
                            _buildRowData(context, 'Education', member.education),
                            _buildRowData(context, 'Occupation', member.occupation),
                            _buildRowData(context, 'Blood Group', member.bloodGroup),
                            _buildRowData(context, 'Hobbies', member.hobbies),
                            _buildRowData(context, 'Native Place', member.nativePlace),
                            _buildRowData(context, 'Notes', member.notes),
                            if (member.matrimonyLink != null && member.matrimonyLink!.isNotEmpty)
                              _buildRowData(context, 'Matrimony Link', member.matrimonyLink),
                            if (member.matrimonyPdf != null && member.matrimonyPdf!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        'Matrimony PDF',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const Text(':  ', style: TextStyle(color: Colors.grey)),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => PdfViewerHelper.openOrDownloadPdf(context, member.matrimonyPdf!),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.picture_as_pdf, size: 16, color: Colors.blue),
                                            SizedBox(width: 6),
                                            Text(
                                              'View / Download PDF',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required Widget icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection(
    BuildContext context, {
    String? title,
    IconData? icon,
    required List<Widget> fields,
  }) {
    // Filter out null widgets (which represent empty fields)
    final activeFields = fields.where((w) => w is! SizedBox).toList();
    if (activeFields.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null && icon != null) ...[
              Row(
                children: [
                  Icon(icon, color: AppTheme.primaryBlue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 0.8),
            ],
            ...activeFields,
          ],
        ),
      ),
    );
  }

  Widget _buildRowData(BuildContext context, String label, String? value) {
    if (value == null || value.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    final bool isLink = label == "Matrimony Link";
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(':  ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: isLink
                ? InkWell(
                    onTap: () {
                      String formattedUrl = value.trim();
                      if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
                        formattedUrl = 'https://$formattedUrl';
                      }
                      launchUrl(Uri.parse(formattedUrl), mode: LaunchMode.externalApplication);
                    },
                    child: Text(
                      value.trim(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : Text(
                    value.trim(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
