import 'package:flutter/material.dart';
import 'package:flutter_app/screens/matrimoney/model/matrimony_model.dart';
import 'package:flutter_app/screens/matrimoney/notifier/matrimony_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
import 'package:flutter_app/screens/matrimoney/ui/matrimoney_details.dart';
import 'package:flutter_app/utils/pdf_viewer_helper.dart';

class MatrimoneyScreen extends ConsumerStatefulWidget {
  const MatrimoneyScreen({super.key});

  @override
  ConsumerState<MatrimoneyScreen> createState() =>
      _MatrimoneyScreenState();
}

class _MatrimoneyScreenState extends ConsumerState<MatrimoneyScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  RangeValues _ageRange = const RangeValues(18, 60);
  bool _isFilterApplied = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    Future.microtask(() {
      ref
          .read(matrimoneyNotifierProvider.notifier)
          .loadMatrimoney('api/customer/customers-matrimony');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String _getGender(Matrimoney item) {
    if (item.gender != null && item.gender!.isNotEmpty) {
      return item.gender!.toLowerCase();
    }
    final rel = item.familyMemberRelationship.toLowerCase();
    if (rel.contains('son') || rel.contains('brother') || rel.contains('husband') || rel.contains('father') || rel.contains('boy') || rel == 'male') {
      return 'male';
    }
    if (rel.contains('daughter') || rel.contains('sister') || rel.contains('wife') || rel.contains('mother') || rel.contains('girl') || rel == 'female') {
      return 'female';
    }
    return 'male'; // fallback
  }

  @override
  Widget build(BuildContext context) {
    final memberState = ref.watch(matrimoneyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        foregroundColor: AppTheme.textDark,
        title: const Text('Matrimony'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        ref
                            .read(matrimoneyNotifierProvider.notifier)
                            .loadMatrimoney(
                          'api/customer/customers-matrimony?search=$value',
                        );
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Matrimony',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor:
                        AppTheme.backgroundGrey.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                            ref
                                .read(matrimoneyNotifierProvider.notifier)
                                .loadMatrimoney('api/customer/customers-matrimony');
                          },
                        )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundGrey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isFilterApplied ? Icons.filter_alt : Icons.filter_alt_outlined,
                        color: AppTheme.secondaryBlue,
                      ),
                      onPressed: () => _showFilterSheet(context),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppTheme.secondaryBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(child: Text('All', style: TextStyle(fontWeight: FontWeight.w600))),
                    Tab(child: Text('Boy', style: TextStyle(fontWeight: FontWeight.w600))),
                    Tab(child: Text('Girl', style: TextStyle(fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
            ),
            if (_isFilterApplied)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  children: [
                    Chip(
                      label: Text(
                        'Age: ${_ageRange.start.round()} - ${_ageRange.end.round()}',
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      backgroundColor: AppTheme.primaryBlue,
                      deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
                      onDeleted: () {
                        setState(() {
                          _isFilterApplied = false;
                          _ageRange = const RangeValues(18, 60);
                        });
                      },
                    ),
                  ],
                ),
              ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    final state = ref.watch(matrimoneyNotifierProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text(state.error!));
    }

    final filteredList = state.matrimoneyList.where((item) {
      final gender = _getGender(item);
      if (_tabController.index == 1 && gender != 'male') {
        return false;
      } else if (_tabController.index == 2 && gender != 'female') {
        return false;
      }

      if (_isFilterApplied) {
        final age = item.familyMemberAge;
        if (age == null) {
          return false;
        }
        if (age < _ageRange.start.round() || age > _ageRange.end.round()) {
          return false;
        }
      }
      return true;
    }).toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search,
                size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No profiles found',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredList.length,
      padding: const EdgeInsets.only(bottom: 20),
      itemBuilder: (context, index) {
        return _buildMemberTile(filteredList[index]);
      },
    );
  }

  Widget _buildMemberTile(Matrimoney member) {
    final phone = (member.familyMemberMobile != null && member.familyMemberMobile!.isNotEmpty)
        ? member.familyMemberMobile!
        : member.mobile;

    final displayImage = (member.familyMemberImage != null && member.familyMemberImage!.isNotEmpty)
        ? member.familyMemberImage
        : (member.image != null && member.image!.isNotEmpty ? member.image : null);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatrimoneyDetailScreen(matrimoney: member),
          ),
        );
      },
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.dividerGrey,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.backgroundGrey,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                  AppTheme.primaryBlue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: displayImage != null
                    ? CachedNetworkImage(
                        imageUrl: displayImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                        errorWidget: (context, url, error) => const Icon(Icons.person, color: AppTheme.primaryBlue),
                      )
                    : const Icon(Icons.person, color: AppTheme.primaryBlue),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.familyMemberName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone,
                          size: 14,
                          color: AppTheme.textGrey),
                      const SizedBox(width: 6),
                      Text(
                        phone,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMatrimoneyDetails(BuildContext context, Matrimoney member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final phone = (member.familyMemberMobile != null && member.familyMemberMobile!.isNotEmpty)
            ? member.familyMemberMobile!
            : member.mobile;

        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.4,
          maxChildSize: 0.85,
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
                  
                  // Header
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppTheme.secondaryBlue.withOpacity(0.1),
                        child: const Icon(Icons.person, color: AppTheme.secondaryBlue, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        member.familyMemberName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.familyMemberRelationship,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(const Icon(Icons.call, color: Colors.green), Colors.green, () => launchUrl(Uri.parse('tel:$phone'))),
                      _buildActionButton(const Icon(Icons.message, color: Colors.blue), Colors.blue, () => launchUrl(Uri.parse('sms:$phone'))),
                      _buildActionButton(const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)), const Color(0xFF25D366), () => launchUrl(Uri.parse('https://wa.me/$phone'))),
                    ],
                  ),
                  const Divider(height: 32),

                  // Info
                  const Text("Personal Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildDetailRow("Mobile", member.mobile),
                  if (member.familyMemberMobile != null && member.familyMemberMobile!.isNotEmpty)
                    _buildDetailRow("Member Mobile", member.familyMemberMobile!),
                  if (member.fatherName != null && member.fatherName!.isNotEmpty)
                    _buildDetailRow("Father Name", member.fatherName!),
                  if (member.education != null && member.education!.isNotEmpty)
                    _buildDetailRow("Education", member.education!),
                  if (member.familyMemberEducation != null && member.familyMemberEducation!.isNotEmpty)
                    _buildDetailRow("Member Education", member.familyMemberEducation!),
                  if (member.familyMemberAge != null)
                    _buildDetailRow("Age", "${member.familyMemberAge} years"),
                  if (member.familyMemberDateOfBirth != null)
                    _buildDetailRow("Date of Birth", DateFormat('dd MMM yyyy').format(member.familyMemberDateOfBirth!)),
                  if (member.matrimonyLink != null && member.matrimonyLink!.isNotEmpty)
                    _buildDetailRow("Matrimony Link", member.matrimonyLink!),
                  if (member.matrimonyPdf != null && member.matrimonyPdf!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 130,
                            child: Text(
                              "Matrimony PDF",
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Text(":  ", style: TextStyle(color: Colors.grey)),
                          Expanded(
                            child: InkWell(
                              onTap: () => PdfViewerHelper.openOrDownloadPdf(context, member.matrimonyPdf!),
                              child: const Text(
                                "View / Download PDF",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
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
            width: 130,
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

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter by Age',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _ageRange = const RangeValues(18, 60);
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Min Age: ${_ageRange.start.round()}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Max Age: ${_ageRange.end.round()}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _ageRange,
                    min: 18,
                    max: 80,
                    divisions: 62,
                    labels: RangeLabels(
                      _ageRange.start.round().toString(),
                      _ageRange.end.round().toString(),
                    ),
                    activeColor: AppTheme.secondaryBlue,
                    inactiveColor: AppTheme.secondaryBlue.withOpacity(0.2),
                    onChanged: (RangeValues values) {
                      setModalState(() {
                        _ageRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _isFilterApplied = false;
                              _ageRange = const RangeValues(18, 60);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Clear Filter'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.ssjsSecondaryBlue,
        foregroundColor: AppTheme.textDark,
                            // foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFilterApplied = true;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
