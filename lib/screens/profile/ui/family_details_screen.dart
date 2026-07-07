import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/profile/notifier/profile_notifier.dart';
import 'package:flutter_app/screens/profile/model/family_member_model.dart';
import 'package:flutter_app/utils/pdf_viewer_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../config/theme.dart';

class FamilyDetailsScreen extends ConsumerStatefulWidget {
  const FamilyDetailsScreen({super.key});

  @override
  ConsumerState<FamilyDetailsScreen> createState() => _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends ConsumerState<FamilyDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Load data from API when screen opens
    Future.microtask(() {
      ref.read(profileNotifierProvider.notifier).loadMember();
    });
  }

  void _addFamilyMember() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddFamilyMemberDialog(
        onAdd: (memberPayload, imageFile, pdfFile) async {
          await ref.read(profileNotifierProvider.notifier).addFamily(context, imageFile, pdfFile, memberPayload);
          // Refresh list after adding
          ref.read(profileNotifierProvider.notifier).loadMember();
        },
      ),
    );
  }

  void _editFamilyMember(FamilyMember member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddFamilyMemberDialog(
        // Pass the model's current data to the sheet
        initialData: member.toJson(),
        onAdd: (memberPayload, f, pdfFile) async {
          await ref.read(profileNotifierProvider.notifier).updateFamily(
            context,
            member.id.toString(),
            f,
            pdfFile,
            memberPayload,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // WATCH the state here. When state change in Notifier, this UI rebuilds.
    final profileState = ref.watch(profileNotifierProvider);
    final familyMembers = profileState.familyMember ?? [];

    return Scaffold(
      // backgroundColor: AppTheme.primaryBlue,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
        title: const Text('Family Details'),
        backgroundColor:Colors.white,
        foregroundColor: AppTheme.backgroundWhite,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addFamilyMember,
          ),
        ],
      ),
      body: SafeArea(
        child: profileState.isLoading && familyMembers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : familyMembers.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          itemCount: familyMembers.length,
          padding: const EdgeInsets.symmetric(vertical: 12), // Added padding top/bottom
          itemBuilder: (context, index) {
            final member = familyMembers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: InkWell(
                borderRadius: BorderRadius.circular(16), // Match card corners
                onTap: () {
                  _showFamilyMemberDetails(context, member);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    // Suble border instead of heavy shadow
                    border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        // Clean Avatar Section
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: (member.image != null && member.image!.isNotEmpty)
                                ? Image.network(
                              member.image!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)));
                              },
                              errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(member),
                            )
                                : _buildDefaultIcon(member),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Text Content Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                member.relationship,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Actions Section
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            color: AppTheme.primaryBlue,
                            onPressed: () => _editFamilyMember(member),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFamilyMember,
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
  Widget _buildDefaultIcon(FamilyMember member) {
    return Container(
      color: AppTheme.primaryBlue,
      child: Icon(
        _getRelationIcon(member.relationship), // Ensure this matches your model field
        color: Colors.white,
        size: 24,
      ),
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.family_restroom, size: 80, color: AppTheme.textGrey.withAlpha(128)),
          const SizedBox(height: 16),
          const Text('No family members added'),
        ],
      ),
    );
  }

  IconData _getRelationIcon(String relation) {
    switch (relation.toLowerCase()) {
      case 'spouse': case 'husband': case 'wife': return Icons.favorite;
      case 'father': case 'mother': case 'parent': return Icons.elderly;
      case 'son': case 'daughter': case 'child': return Icons.child_care;
      case 'brother': case 'sister': case 'sibling': return Icons.people;
      default: return Icons.person;
    }
  }

  void _showFamilyMemberDetails(BuildContext context, FamilyMember member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.45,
          maxChildSize: 0.9,
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
                        radius: 45,
                        backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                        backgroundImage: (member.image != null && member.image!.isNotEmpty)
                            ? NetworkImage(member.image!)
                            : null,
                        child: (member.image == null || member.image!.isEmpty)
                            ? const Icon(Icons.person, size: 45, color: AppTheme.primaryBlue)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        member.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.relationship,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Actions (Call, Message, WhatsApp)
                  if (member.mobile != null && member.mobile!.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(const Icon(Icons.call, color: Colors.green), Colors.green, () => launchUrl(Uri.parse('tel:${member.mobile}'))),
                        _buildActionButton(const Icon(Icons.message, color: Colors.blue), Colors.blue, () => launchUrl(Uri.parse('sms:${member.mobile}'))),
                        _buildActionButton(const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)), const Color(0xFF25D366), () => launchUrl(Uri.parse('https://wa.me/${member.mobile}'))),
                      ],
                    ),
                    const Divider(height: 32),
                  ],

                  // Details
                  const Text("Member Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (member.mobile != null && member.mobile!.isNotEmpty)
                    _buildDetailRow2("Mobile", member.mobile!),
                  if (member.gender != null && member.gender!.isNotEmpty)
                    _buildDetailRow2("Gender", member.gender!),
                  if (member.dateOfBirth != null)
                    _buildDetailRow2("Date of Birth", DateFormat('dd MMM yyyy').format(member.dateOfBirth!)),
                  if (member.anniversaryDate != null)
                    _buildDetailRow2("Anniversary", DateFormat('dd MMM yyyy').format(member.anniversaryDate!)),
                  if (member.gotra != null && member.gotra!.isNotEmpty)
                    _buildDetailRow2("Gotra", member.gotra!),
                  if (member.education != null && member.education!.isNotEmpty)
                    _buildDetailRow2("Education", member.education!),
                  if (member.occupation != null && member.occupation!.isNotEmpty)
                    _buildDetailRow2("Occupation", member.occupation!),
                  if (member.bloodGroup != null && member.bloodGroup!.isNotEmpty)
                    _buildDetailRow2("Blood Group", member.bloodGroup!),
                  if (member.nativePlace != null && member.nativePlace!.isNotEmpty)
                    _buildDetailRow2("Native Place", member.nativePlace!),
                  if (member.hobbies != null && member.hobbies!.isNotEmpty)
                    _buildDetailRow2("Hobbies", member.hobbies!),
                  if (member.notes != null && member.notes!.isNotEmpty)
                    _buildDetailRow2("Notes", member.notes!),
                  if (member.matrimonyLink != null && member.matrimonyLink!.isNotEmpty)
                    _buildDetailRow2("Matrimony Link", member.matrimonyLink!),
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

  Widget _buildDetailRow2(String label, String value) {
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
}

class _AddFamilyMemberDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic> payload, File? imageFile, File? pdfFile) onAdd;

  const _AddFamilyMemberDialog({
    this.initialData,
    required this.onAdd,
  });

  @override
  State<_AddFamilyMemberDialog> createState() => _AddFamilyMemberDialogState();
}

class _AddFamilyMemberDialogState extends State<_AddFamilyMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // TEXT CONTROLLERS
  late TextEditingController _nameController;
  late TextEditingController _relationController;
  late TextEditingController _mobileController;
  late TextEditingController _gotraController;
  late TextEditingController _occupationController;
  late TextEditingController _educationController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _hobbiesController;
  late TextEditingController _nativePlaceController;
  late TextEditingController _notesController;
  late TextEditingController _matrimonyLinkController;

  // DATE
  DateTime? _selectedDob;
  DateTime? _selectedAnniversary;

  // IMAGE
  File? _selectedImage;

  // PDF
  File? _selectedPdf;
  String? _pdfFileName;

  String _selectedGender = 'male';
  bool _isMatrimony = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialData?['name']);
    _relationController = TextEditingController(text: widget.initialData?['relationship']);
    _mobileController = TextEditingController(text: widget.initialData?['mobile']);
    _gotraController = TextEditingController(text: widget.initialData?['gotra']);
    _occupationController = TextEditingController(text: widget.initialData?['occupation']);
    _educationController = TextEditingController(text: widget.initialData?['education']);
    _bloodGroupController = TextEditingController(text: widget.initialData?['blood_group']);
    _hobbiesController = TextEditingController(text: widget.initialData?['hobbies']);
    _nativePlaceController = TextEditingController(text: widget.initialData?['native_place']);
    _notesController = TextEditingController(text: widget.initialData?['notes']);
    _matrimonyLinkController = TextEditingController(
      text: widget.initialData?['link']?.toString() ?? widget.initialData?['matrimony_link']?.toString(),
    );

    _selectedGender = widget.initialData?['gender'] ?? 'male';
    _isMatrimony = widget.initialData?['matrimony'] ?? false;

    if (widget.initialData?['date_of_birth'] != null) {
      _selectedDob = DateTime.tryParse(widget.initialData!['date_of_birth']);
    }
    if (widget.initialData?['anniversary_date'] != null) {
      _selectedAnniversary = DateTime.tryParse(widget.initialData!['anniversary_date']);
    }
    final pdfUrl = (widget.initialData?['pdf'] ?? widget.initialData?['matrimony_pdf'])?.toString();
    if (pdfUrl != null && pdfUrl.isNotEmpty) {
      _pdfFileName = pdfUrl.split('/').last;
    }
  }

  @override
  void dispose() {
    for (var c in [
      _nameController,
      _relationController,
      _mobileController,
      _gotraController,
      _occupationController,
      _educationController,
      _bloodGroupController,
      _hobbiesController,
      _nativePlaceController,
      _notesController,
      _matrimonyLinkController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // IMAGE PICKER
  Future<void> _pickImage(ImageSource source) async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        if (source == ImageSource.camera) {
          var status = await Permission.camera.request();
          if (status.isPermanentlyDenied) {
            _showPermissionDialog('Camera');
            return;
          }
          if (!status.isGranted) return;
        } else {
          var status = await Permission.photos.request();
          if (status.isPermanentlyDenied) {
            _showPermissionDialog('Photo Library');
            return;
          }
          if (!status.isGranted) return;
        }
      }

      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to open ${source == ImageSource.camera ? 'camera' : 'gallery'}: $e")),
      );
    }
  }

  void _showPermissionDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$type Permission'),
        content: Text('$type access is required to upload member pictures. Please enable it in settings.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  // DATE PICKER
  Future<void> _selectDate(bool isDob) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        isDob ? _selectedDob = picked : _selectedAnniversary = picked;
      });
    }
  }

  String _formatDate(DateTime? d) =>
      d == null ? 'Select Date' : DateFormat('dd MMM yyyy').format(d);

  String? _apiDate(DateTime? d) =>
      d?.toIso8601String().split('T').first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.initialData == null ? 'Add Family Member' : 'Edit Family Member',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // IMAGE PICKER UI
                      GestureDetector(
                        onTap: () => _showImageSourceSheet(),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (widget.initialData?['image'] != null && widget.initialData!['image'].isNotEmpty)
                                  ? NetworkImage(widget.initialData!['image']) as ImageProvider
                                  : null,
                          child: _selectedImage == null && (widget.initialData?['image'] == null || widget.initialData!['image'].isEmpty)
                              ? const Icon(Icons.camera_alt, size: 28)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildField(_nameController, 'Name', Icons.person, isRequired: true),
                      _buildField(_relationController, 'Relationship', Icons.family_restroom, isRequired: true),
                      _buildField(_mobileController, 'Mobile', Icons.phone, keyboard: TextInputType.phone),
                      _dateTile('Date of Birth', true),
                      _dateTile('Anniversary Date', false),
                      _buildField(_gotraController, 'Gotra', Icons.groups),
                      _buildField(_educationController, 'Education', Icons.school),
                      _buildField(_occupationController, 'Occupation', Icons.work),
                      _buildField(_bloodGroupController, 'Blood Group', Icons.bloodtype),
                      _buildField(_nativePlaceController, 'Native Place', Icons.home),
                      _buildField(_hobbiesController, 'Hobbies', Icons.palette),
                      _buildField(_notesController, 'Notes', Icons.note, maxLines: 2),
                      Row(
                        children: [
                          const Text("Gender: "),
                          Radio(value: 'male', groupValue: _selectedGender, onChanged: (v) => setState(() => _selectedGender = v!)),
                          const Text("Male"),
                          Radio(value: 'female', groupValue: _selectedGender, onChanged: (v) => setState(() => _selectedGender = v!)),
                          const Text("Female"),
                        ],
                      ),
                       CheckboxListTile(
                        title: const Text("Open for Matrimony"),
                        value: _isMatrimony,
                        onChanged: (v) => setState(() => _isMatrimony = v!),
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (_isMatrimony) ...[
                        const SizedBox(height: 12),
                        _buildField(
                          _matrimonyLinkController,
                          'Matrimony Bio Link (Optional)',
                          Icons.link,
                          keyboard: TextInputType.url,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _pdfFileName ?? 'No PDF selected',
                                style: TextStyle(
                                  color: _pdfFileName != null ? Colors.black87 : Colors.grey,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (widget.initialData?['pdf'] != null && widget.initialData!['pdf'].toString().isNotEmpty) ...[
                              TextButton.icon(
                                onPressed: () async {
                                  PdfViewerHelper.openOrDownloadPdf(context, widget.initialData!['pdf'].toString());
                                },
                                icon: const Icon(Icons.open_in_new, size: 16),
                                label: const Text('View'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.primaryBlue,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ] else if (widget.initialData?['matrimony_pdf'] != null && widget.initialData!['matrimony_pdf'].toString().isNotEmpty) ...[
                              TextButton.icon(
                                onPressed: () async {
                                  PdfViewerHelper.openOrDownloadPdf(context, widget.initialData!['matrimony_pdf'].toString());
                                },
                                icon: const Icon(Icons.open_in_new, size: 16),
                                label: const Text('View'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.primaryBlue,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result = await fp.FilePicker.platform.pickFiles(
                                  type: fp.FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );
                                if (result != null && result.files.single.path != null) {
                                  setState(() {
                                    _selectedPdf = File(result.files.single.path!);
                                    _pdfFileName = result.files.single.name;
                                  });
                                }
                              },
                              icon: const Icon(Icons.picture_as_pdf, size: 18),
                              label: const Text('Pick PDF'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.secondaryBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SafeArea(
              bottom: true,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onAdd({
                            "name": _nameController.text,
                            "relationship": _relationController.text,
                            "mobile": _mobileController.text,
                            "date_of_birth": _apiDate(_selectedDob),
                            "anniversary_date": _apiDate(_selectedAnniversary),
                            "gotra": _gotraController.text,
                            "occupation": _occupationController.text,
                            "education": _educationController.text,
                            "blood_group": _bloodGroupController.text,
                            "hobbies": _hobbiesController.text,
                            "native_place": _nativePlaceController.text,
                            "notes": _notesController.text,
                            "gender": _selectedGender,
                            "matrimony": _isMatrimony ? 1 : 0,
                            "link": _isMatrimony ? _matrimonyLinkController.text : '',
                          }, _selectedImage, _isMatrimony ? _selectedPdf : null);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateTile(String label, bool isDob) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(isDob ? Icons.cake : Icons.favorite),
      title: Text(label),
      subtitle: Text(_formatDate(isDob ? _selectedDob : _selectedAnniversary)),
      onTap: () => _selectDate(isDob),
    );
  }

  Widget _buildField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool isRequired = false,
        TextInputType? keyboard,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (v) =>
        isRequired && (v == null || v.isEmpty) ? 'Enter $label' : null,
      ),
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
class FamilyMemberDetailScreen extends StatelessWidget {
  final FamilyMember member;

  const FamilyMemberDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(member.name),
        backgroundColor: AppTheme.ssjsSecondaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                backgroundImage: (member.image != null && member.image!.isNotEmpty)
                    ? NetworkImage(member.image!)
                    : null,
                child: (member.image == null || member.image!.isEmpty)
                    ? const Icon(Icons.person, size: 60, color: AppTheme.primaryBlue)
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildDetailRow('Relationship', member.relationship, Icons.family_restroom),
                    _buildDetailRow('Mobile', member.mobile, Icons.phone),
                    _buildDetailRow('Gender', member.gender, Icons.wc),
                    _buildDetailRow('Date of Birth', member.dateOfBirth, Icons.cake),
                    _buildDetailRow('Anniversary', member.anniversaryDate, Icons.favorite),
                    _buildDetailRow('Gotra', member.gotra, Icons.groups),
                    _buildDetailRow('Education', member.education, Icons.school),
                    _buildDetailRow('Occupation', member.occupation, Icons.work),
                    _buildDetailRow('Blood Group', member.bloodGroup, Icons.bloodtype),
                    _buildDetailRow('Native Place', member.nativePlace, Icons.home),
                    _buildDetailRow('Hobbies', member.hobbies, Icons.palette),
                    _buildDetailRow('Notes', member.notes, Icons.note),

                    if (member.matrimony)
                      const ListTile(
                        leading: Icon(Icons.favorite, color: Colors.pink),
                        title: Text("Open for Matrimony", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    if (member.matrimonyLink != null && member.matrimonyLink!.isNotEmpty)
                      _buildDetailRow('Matrimony Link', member.matrimonyLink!, Icons.link),
                    if (member.matrimonyPdf != null && member.matrimonyPdf!.isNotEmpty)
                      Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.picture_as_pdf, color: AppTheme.primaryBlue),
                            title: const Text('Matrimony PDF', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            subtitle: const Text('View / Download PDF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue)),
                            onTap: () => PdfViewerHelper.openOrDownloadPdf(context, member.matrimonyPdf!),
                          ),
                          const Divider(height: 1, indent: 70),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 This helper method handles the "not empty / not null" logic
  Widget _buildDetailRow(String label, dynamic value, IconData icon) {
    if (value == null || value.toString().trim().isEmpty) {
      return const SizedBox.shrink(); // Returns nothing if empty
    }

    // If the value is a DateTime, format it
    String displayValue = value.toString();
    if (value is DateTime) {
      displayValue = DateFormat('dd MMM yyyy').format(value);
    }

    final bool isLink = label == 'Matrimony Link';

    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppTheme.primaryBlue),
          title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          subtitle: isLink
              ? InkWell(
                  onTap: () {
                    String formattedUrl = displayValue.trim();
                    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
                      formattedUrl = 'https://$formattedUrl';
                    }
                    launchUrl(Uri.parse(formattedUrl), mode: LaunchMode.externalApplication);
                  },
                  child: Text(
                    displayValue,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(displayValue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
        ),
        const Divider(height: 1, indent: 70),
      ],
    );
  }
}
