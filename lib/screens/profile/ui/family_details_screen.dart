import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/profile/notifier/profile_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/profile/notifier/profile_notifier.dart';
import 'package:flutter_app/screens/profile/model/family_member_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    showDialog(
      context: context,
      builder: (context) => _AddFamilyMemberDialog(
        onAdd: (memberPayload, imageFile) async {
          await ref.read(profileNotifierProvider.notifier).addFamily(context,imageFile, memberPayload,);
          // Refresh list after adding
          ref.read(profileNotifierProvider.notifier).loadMember();
        },
      ),
    );
  }

  void _editFamilyMember(FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) => _AddFamilyMemberDialog(
        // Pass the model's current data to the dialog
        initialData: member.toJson(),
        onAdd: (memberPayload,f) async {
          await ref.read(profileNotifierProvider.notifier).updateFamily(
            context,
            member.id.toString(),
            f,
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
      appBar: AppBar(
        title: const Text('Family Details'),
        backgroundColor: AppTheme.ssjsSecondaryBlue,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FamilyMemberDetailScreen(member: member),
                    ),
                  );
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
}

class _AddFamilyMemberDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>, File?) onAdd;

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

  // DATE
  DateTime? _selectedDob;
  DateTime? _selectedAnniversary;

  // IMAGE
  File? _selectedImage;

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

    _selectedGender = widget.initialData?['gender'] ?? 'male';
    _isMatrimony = widget.initialData?['matrimony'] ?? false;

    if (widget.initialData?['date_of_birth'] != null) {
      _selectedDob = DateTime.tryParse(widget.initialData!['date_of_birth']);
    }
    if (widget.initialData?['anniversary_date'] != null) {
      _selectedAnniversary = DateTime.tryParse(widget.initialData!['anniversary_date']);
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
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // IMAGE PICKER
  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
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
    return AlertDialog(
      title: Text(widget.initialData == null ? 'Add Family Member' : 'Edit Family Member'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [

              // 🔥 IMAGE PICKER UI
              GestureDetector(
                onTap: () => _showImageSourceSheet(),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : null,
                  child: _selectedImage == null
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
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
                "matrimony": _isMatrimony? 1 : 0,
              }, _selectedImage);

              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
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

                    // Special case for Matrimony
                    // if (member.matrimony == true)
                    //   const ListTile(
                    //     leading: Icon(Icons.star, color: Colors.orange),
                    //     title: Text("Open for Matrimony", style: TextStyle(fontWeight: FontWeight.bold)),
                    //   ),
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

    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppTheme.primaryBlue),
          title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          subtitle: Text(displayValue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
        ),
        const Divider(height: 1, indent: 70),
      ],
    );
  }
}
