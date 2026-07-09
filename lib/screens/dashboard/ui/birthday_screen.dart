import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_app/config/theme.dart';
import 'package:flutter_app/screens/dashboard/model/dashboard_model.dart';
import 'package:flutter_app/screens/dashboard/notifier/dashboard_notifier.dart';
import 'package:flutter_app/screens/dashboard/ui/wish_bottom_sheet.dart';
import 'package:flutter_app/utils/pdf_viewer_helper.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  late String _selectedMonth;
  final ScrollController _monthScrollController = ScrollController();
  final ScrollController _listScrollController = ScrollController();
  GlobalKey? _todayKey;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateFormat('MMMM').format(DateTime.now());
    Future.microtask(() {
      ref.read(dashboardNotifierProvider.notifier).loadBirthdays();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMonth();
      if (_selectedMonth == DateFormat('MMMM').format(DateTime.now())) {
        _scrollToToday();
      }
    });
  }

  @override
  void dispose() {
    _monthScrollController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  int? _getDayNumber(String dateKey) {
    final RegExp regex = RegExp(r'\d+');
    final Match? match = regex.firstMatch(dateKey);
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    return null;
  }

  void _scrollToToday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_todayKey?.currentContext != null) {
        Scrollable.ensureVisible(
          _todayKey!.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _scrollToSelectedMonth() {
    if (!_monthScrollController.hasClients) return;
    final index = _months.indexOf(_selectedMonth);
    if (index != -1) {
      final targetOffset = index * 90.0 - 100.0;
      _monthScrollController.animateTo(
        targetOffset.clamp(0.0, _monthScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _isToday(DateTime dob) {
    final now = DateTime.now();
    return dob.day == now.day && dob.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);
    final dateMap = state.birthdayData[_selectedMonth] ?? {};

    ref.listen(dashboardNotifierProvider, (previous, next) {
      if ((previous == null || previous.isLoading) && !next.isLoading) {
        if (_selectedMonth == DateFormat('MMMM').format(DateTime.now())) {
          _scrollToToday();
        }
      }
    });

    final String currentMonth = DateFormat('MMMM').format(DateTime.now());
    final int todayDay = DateTime.now().day;
    String? targetScrollKey;

    if (_selectedMonth == currentMonth) {
      for (var entry in dateMap.entries) {
        final dayNum = _getDayNumber(entry.key);
        if (dayNum != null && dayNum >= todayDay) {
          targetScrollKey = entry.key;
          break;
        }
      }
    }

    _todayKey = null;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        foregroundColor: AppTheme.textDark,
        title: const Text('Birthdays', style: TextStyle(color: Colors.black)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(dashboardNotifierProvider.notifier).loadBirthdays(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Month Selector
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.white,
              child: ListView.builder(
                controller: _monthScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _months.length,
                itemBuilder: (context, index) {
                  final month = _months[index];
                  final isSelected = month == _selectedMonth;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        month,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      showCheckmark: false,
                      selectedColor: AppTheme.primaryBlue,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedMonth = month;
                          });
                          _scrollToSelectedMonth();
                          if (month == DateFormat('MMMM').format(DateTime.now())) {
                            _scrollToToday();
                          }
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            // Members List
            Expanded(
              child: state.isLoading && state.birthdayData.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue))
                  : dateMap.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cake_outlined, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                'No birthdays in $_selectedMonth',
                                style: const TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          controller: _listScrollController,
                          padding: const EdgeInsets.all(16),
                          children: dateMap.entries.map((entry) {
                            final dateKey = entry.key;
                            final members = entry.value;
                            final isTarget = (dateKey == targetScrollKey);
                            if (isTarget) {
                              _todayKey = GlobalKey();
                            }
                            return Column(
                              key: isTarget ? _todayKey : null,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  child: Text(
                                    dateKey,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                ...members.map((m) => _buildMemberTile(m)),
                                const SizedBox(height: 8),
                              ],
                            );
                          }).toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMemberDetails(BuildContext context, BirthdayModel member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.5,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            // Background Image Section
                            Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                image: member.backgroundImage != null && member.backgroundImage!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(member.backgroundImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                            // Space for overlapping avatar and name
                            const SizedBox(height: 50),
                            Text(
                              member.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            if (member.dateOfBirth != null)
                              Text(
                                'Birthday: ${DateFormat('dd MMMM yyyy').format(member.dateOfBirth!)}',
                                style: const TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                        // Profile Avatar overlapping bottom center of background
                        Positioned(
                          top: 180 - 45,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundWhite,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primaryBlue,
                                width: 3,
                              ),
                            ),
                            child: ClipOval(
                              child: member.image != null && member.image!.isNotEmpty
                                  ? Image.network(
                                      member.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.person, color: AppTheme.primaryBlue, size: 40),
                                    )
                                  : const Icon(Icons.person, color: AppTheme.primaryBlue, size: 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (member.mobile.isNotEmpty || (member.email != null && member.email!.isNotEmpty))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (member.mobile.isNotEmpty)
                          _buildActionButton(const Icon(Icons.call, color: Colors.green), Colors.green, () => launchUrl(Uri.parse('tel:${member.mobile}'))),
                        if (member.mobile.isNotEmpty)
                          _buildActionButton(const Icon(Icons.message, color: Colors.blue), Colors.blue, () => launchUrl(Uri.parse('sms:${member.mobile}'))),
                        if (member.whatsapp != null && member.whatsapp!.isNotEmpty)
                          _buildActionButton(const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)), const Color(0xFF25D366), () => launchUrl(Uri.parse('https://wa.me/${member.whatsapp}'))),
                        if (member.email != null && member.email!.isNotEmpty)
                          _buildActionButton(const Icon(Icons.email, color: Colors.red), Colors.red, () => launchUrl(Uri.parse('mailto:${member.email}'))),
                      ],
                    ),
                  const SizedBox(height: 24),
                  
                  // Details Info
                  if ((member.fatherName != null && member.fatherName!.isNotEmpty) ||
                      (member.gotra != null && member.gotra!.isNotEmpty) ||
                      (member.gender != null && member.gender!.isNotEmpty) ||
                      (member.age != null) ||
                      (member.bloodGroup != null && member.bloodGroup!.isNotEmpty) ||
                      (member.education != null && member.education!.isNotEmpty) ||
                      (member.hobbies != null && member.hobbies!.isNotEmpty) ||
                      (member.nativePlace != null && member.nativePlace!.isNotEmpty)) ...[
                    const Text("Personal Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (member.fatherName != null && member.fatherName!.isNotEmpty) _buildDetailRow("Father's Name", member.fatherName!),
                    if (member.gotra != null && member.gotra!.isNotEmpty) _buildDetailRow("Gotra", member.gotra!),
                    if (member.gender != null && member.gender!.isNotEmpty) _buildDetailRow("Gender", member.gender!),
                    if (member.age != null) _buildDetailRow("Age", member.age.toString()),
                    if (member.bloodGroup != null && member.bloodGroup!.isNotEmpty) _buildDetailRow("Blood Group", member.bloodGroup!),
                    if (member.education != null && member.education!.isNotEmpty) _buildDetailRow("Education", member.education!),
                    if (member.hobbies != null && member.hobbies!.isNotEmpty) _buildDetailRow("Hobbies", member.hobbies!),
                    if (member.nativePlace != null && member.nativePlace!.isNotEmpty) _buildDetailRow("Native Place", member.nativePlace!),
                    const Divider(height: 32),
                  ],

                  if ((member.occupation != null && member.occupation!.isNotEmpty) ||
                      (member.businessType != null && member.businessType!.isNotEmpty) ||
                      (member.businessName != null && member.businessName!.isNotEmpty) ||
                      (member.msFirmName != null && member.msFirmName!.isNotEmpty) ||
                      (member.productService != null && member.productService!.isNotEmpty) ||
                      (member.officeAddress != null && member.officeAddress!.isNotEmpty)) ...[
                    const Text("Professional Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (member.occupation != null && member.occupation!.isNotEmpty) _buildDetailRow("Occupation", member.occupation!),
                    if (member.businessType != null && member.businessType!.isNotEmpty) _buildDetailRow("Category", member.businessType!),
                    if (member.businessName != null && member.businessName!.isNotEmpty) _buildDetailRow("Business Name", member.businessName!),
                    if (member.msFirmName != null && member.msFirmName!.isNotEmpty) _buildDetailRow("Firm Name", member.msFirmName!),
                    if (member.productService != null && member.productService!.isNotEmpty) _buildDetailRow("Products/Services", member.productService!),
                    if (member.officeAddress != null && member.officeAddress!.isNotEmpty) _buildDetailRow("Office Address", member.officeAddress!),
                    const Divider(height: 32),
                  ],
                  
                  // Address Info
                  if ((member.village != null) || (member.area != null && member.area!.isNotEmpty) || (member.city != null && member.city!.isNotEmpty)) ...[
                    const Text("Address Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (member.village != null) _buildDetailRow("Village", member.village!.name),
                    if (member.area != null && member.area!.isNotEmpty) _buildDetailRow("Area", member.area!),
                    if (member.city != null && member.city!.isNotEmpty) _buildDetailRow("City", member.city!),
                  ],
                  
                  // Family Members Info
                  if (member.allFamilyMembers.isNotEmpty) ...[
                    const Divider(height: 32),
                    const Text("Family Members", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...member.allFamilyMembers.map((fam) => Card(
                      elevation: 0.5,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppTheme.primaryBlue.withOpacity(0.08),
                                  backgroundImage: (fam.image != null && fam.image!.isNotEmpty)
                                      ? NetworkImage(fam.image!)
                                      : null,
                                  child: (fam.image == null || fam.image!.isEmpty)
                                      ? const Icon(Icons.person, color: AppTheme.primaryBlue)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fam.name,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${fam.relationship} • ${fam.gender}',
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                if (fam.mobile != null && fam.mobile!.isNotEmpty) ...[
                                  IconButton(
                                    icon: const Icon(Icons.call, color: Colors.green, size: 18),
                                    onPressed: () => launchUrl(Uri.parse('tel:${fam.mobile}')),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.message, color: Colors.blue, size: 18),
                                    onPressed: () => launchUrl(Uri.parse('sms:${fam.mobile}')),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 18),
                                    onPressed: () => launchUrl(Uri.parse('https://wa.me/${fam.mobile}')),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ],
                            ),
                            const Divider(height: 16),
                            _buildDetailRow("Gender", fam.gender),
                            if (fam.mobile != null && fam.mobile!.isNotEmpty)
                              _buildDetailRow("Mobile", fam.mobile!),
                            if (fam.dateOfBirth != null)
                              _buildDetailRow(
                                "Date of Birth",
                                DateFormat('dd MMM yyyy').format(fam.dateOfBirth!),
                              ),
                            if (fam.anniversaryDate != null)
                              _buildDetailRow(
                                "Anniversary",
                                DateFormat('dd MMM yyyy').format(fam.anniversaryDate!),
                              ),
                            if (fam.gotra != null && fam.gotra!.isNotEmpty) _buildDetailRow("Gotra", fam.gotra!),
                            if (fam.education != null && fam.education!.isNotEmpty) _buildDetailRow("Education", fam.education!),
                            if (fam.occupation != null && fam.occupation!.isNotEmpty) _buildDetailRow("Occupation", fam.occupation!),
                            if (fam.bloodGroup != null && fam.bloodGroup!.isNotEmpty) _buildDetailRow("Blood Group", fam.bloodGroup!),
                            if (fam.hobbies != null && fam.hobbies!.isNotEmpty) _buildDetailRow("Hobbies", fam.hobbies!),
                            if (fam.nativePlace != null && fam.nativePlace!.isNotEmpty) _buildDetailRow("Native Place", fam.nativePlace!),
                            if (fam.notes != null && fam.notes!.isNotEmpty) _buildDetailRow("Notes", fam.notes!),
                            if (fam.matrimonyLink != null && fam.matrimonyLink!.isNotEmpty) _buildDetailRow("Matrimony Link", fam.matrimonyLink!),
                            if (fam.matrimonyPdf != null && fam.matrimonyPdf!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 120,
                                      child: Text(
                                        "Matrimony PDF",
                                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Text(":  ", style: TextStyle(color: Colors.grey)),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => PdfViewerHelper.openOrDownloadPdf(context, fam.matrimonyPdf!),
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
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionButton(Widget icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final bool isLink = label == "Matrimony Link";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          const Text(":  ", style: TextStyle(color: Colors.grey)),
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
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(BirthdayModel member) {
    final isToday = member.isToday || (member.dateOfBirth != null && _isToday(member.dateOfBirth!));

    return GestureDetector(
      onTap: () => _showMemberDetails(context, member),
      child: Opacity(
      opacity: isToday ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isToday ? AppTheme.primaryBlue.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isToday ? AppTheme.primaryBlue.withOpacity(0.5) : AppTheme.dividerGrey, 
            width: isToday ? 1.5 : 0.5
          ),
          boxShadow: [
            if (isToday)
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: isToday ? AppTheme.primaryBlue.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
              backgroundImage: member.image != null && member.image!.isNotEmpty
                  ? NetworkImage(member.image!)
                  : null,
              child: member.image == null || member.image!.isEmpty
                  ? Icon(Icons.person, color: isToday ? AppTheme.primaryBlue : Colors.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: isToday ? Colors.black : Colors.grey.shade700,
                    )
                  ),
                  const SizedBox(height: 4),
                  if (member.dateOfBirth != null)
                    Text(DateFormat('dd MMM').format(member.dateOfBirth!), style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            if (isToday && member.mobile.isNotEmpty)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 14),
                label: const Text('Wish', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: () {
                  final phone = member.whatsapp != null && member.whatsapp!.isNotEmpty
                      ? member.whatsapp!
                      : member.mobile;
                  showWishBottomSheet(
                    context, 
                    phone: phone, 
                    isBirthday: true, 
                    name: member.name,
                  );
                },
              ),
          ],
        ),
      ),
    ));
  }
}