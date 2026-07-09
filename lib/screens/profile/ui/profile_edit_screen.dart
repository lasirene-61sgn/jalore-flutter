import 'package:flutter/material.dart';
import 'package:flutter_app/config/theme.dart';
import 'package:flutter_app/screens/profile/notifier/profile_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  // final Member member;

  const ProfileEditScreen({super.key,});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

// ... imports remain the same

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController(); // Read-only
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _gotraController = TextEditingController();
  final TextEditingController _labelNameController = TextEditingController();

  // VILLAGE
  final TextEditingController _villageController = TextEditingController(); // Read-only

  // BUSINESS
  final TextEditingController _firmNameController = TextEditingController(); // ms_firm_name
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _productServiceController = TextEditingController();
  final TextEditingController _officeAddressController = TextEditingController();

  // ADDRESS
  final TextEditingController _addressController = TextEditingController(); // address2
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  DateTime? _selectedDateOfBirth;
  DateTime? _selectedDateOfAnniversary;
  File? _profileImage;
  File? _backgroundImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(profileNotifierProvider.notifier).loadProfile();
      loadData();
    });
  }

  void loadData() {
    final profile = ref.read(profileNotifierProvider).profile;
    if (profile == null) return;

    setState(() {
      _nameController.text = profile.name;
      _mobileController.text = profile.mobile;
      _emailController.text = profile.email ?? '';
      _villageController.text = profile.villageName ?? '';
      _fatherNameController.text = profile.fatherName ?? '';
      _educationController.text = profile.education ?? '';
      _occupationController.text = profile.occupation ?? '';
      _genderController.text = profile.gender ?? '';
      _ageController.text = profile.age ?? '';
      _gotraController.text = profile.gotra ?? '';
      _labelNameController.text = profile.labelName ?? '';

      _firmNameController.text = profile.msFirmName ?? '';
      _businessTypeController.text = profile.businessType ?? '';
      _productServiceController.text = profile.productService ?? '';
      _officeAddressController.text = profile.officeAddress ?? '';

      _addressController.text = profile.address2 ?? '';
      _cityController.text = profile.city ?? '';
      _pincodeController.text = profile.pincode ?? '';

      _selectedDateOfBirth = profile.dateOfBirth;
      _selectedDateOfAnniversary = profile.anniversaryDate;
    });
  }

  // ... _selectDate, _pickImage, and _buildImageSourceButton remain same ...

  Future<void> _saveProfile() async {
    final state = ref.watch(profileNotifierProvider);
    if (!_formKey.currentState!.validate()) return;

    Map<String, dynamic> updatedMember = {
      "id": state.profile?.id,
      "name": _nameController.text,
      "email": _emailController.text,
      "father_name": _fatherNameController.text,
      "mobile": _mobileController.text, // Sent but read-only in UI
      "ms_firm_name": _firmNameController.text,
      "address2": _addressController.text,
      "city": _cityController.text,
      "pincode": _pincodeController.text,
      "business_type": _businessTypeController.text,
      "business_name": _firmNameController.text, // Same as firm name usually
      "product_service": _productServiceController.text,
      "office_address": _officeAddressController.text,
      "gender": _genderController.text,
      "age": _ageController.text,
      "education": _educationController.text,
      "occupation": _occupationController.text,
      "date_of_birth": _selectedDateOfBirth != null ? DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!) : null,
      "anniversary_date": _selectedDateOfAnniversary != null ? DateFormat('yyyy-MM-dd').format(_selectedDateOfAnniversary!) : null,
      "status": "active",
      "admin_customer_id": state.profile?.adminCustomerId.toString(),
      "admin_id": state.profile?.adminId.toString(),
      "village_id": null,
      "area": '',
      // "image": null,
      "gotra": _gotraController.text,
      "label_name": _labelNameController.text,
      "district": "",// Correctly mapped
      "dno": "",
      "street_road": "",
      "otp_expires_at": null,
      "is_password_set": 1,
      "whatsapp": "",
      "blood_group": "",
      "hobbies": "",
      "native_place": "",
      "created_at": state.profile?.createdAt ?? "2025-12-22T10:04:07.000000Z",
      "updated_at": DateTime.now().toIso8601String()
    };

    await ref.read(profileNotifierProvider.notifier).submitProfile(context, updatedMember, _profileImage, _backgroundImage);
  }
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

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to open ${source == ImageSource.camera ? 'camera' : 'gallery'}: $e")),
      );
    }
  }

  Future<void> _pickBackgroundImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (pickedFile != null) {
        setState(() {
          _backgroundImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking background image: $e");
    }
  }

  void _showPermissionDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$type Permission'),
        content: Text('$type access is required to upload profile pictures. Please enable it in settings.'),
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
  void _showImagePickerSheet(BuildContext context, {bool isBackground = false}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                if (isBackground) {
                  _pickBackgroundImage(ImageSource.camera);
                } else {
                  _pickImage(ImageSource.camera);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                if (isBackground) {
                  _pickBackgroundImage(ImageSource.gallery);
                } else {
                  _pickImage(ImageSource.gallery);
                }
              },
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'),backgroundColor:Colors.white ,),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        // Background Image Picker
                        GestureDetector(
                          onTap: () => _showImagePickerSheet(context, isBackground: true),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              image: _backgroundImage != null
                                  ? DecorationImage(
                                      image: FileImage(_backgroundImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : (state.profile?.backgroundImage != null && state.profile!.backgroundImage!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(state.profile!.backgroundImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : null),
                            ),
                            child: _backgroundImage == null && (state.profile?.backgroundImage == null || state.profile!.backgroundImage!.isEmpty)
                                ? const Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.camera_alt, color: Colors.grey, size: 40),
                                        SizedBox(height: 8),
                                        Text("Add Background Image", style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  )
                                : const Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white70,
                                        radius: 16,
                                        child: Icon(Icons.edit, color: Colors.black, size: 16),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        // Spacer for the avatar
                        const SizedBox(height: 60),
                      ],
                    ),
                    
                    // Profile Image Picker overlapping
                    Positioned(
                      top: (MediaQuery.of(context).size.height * 0.20) - 55,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: AppTheme.ssjsSecondaryBlue,
        foregroundColor: AppTheme.textDark,
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: AppTheme.ssjsSecondaryBlue,
        foregroundColor: AppTheme.textDark,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : (state.profile?.image != null
                                  ? NetworkImage(state.profile!.image!)
                                  : null) as ImageProvider?,
                              child: (_profileImage == null && state.profile?.image == null)
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () => _showImagePickerSheet(context, isBackground: false),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // Basic Info
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _labelNameController,
                  decoration: const InputDecoration(
                    labelText: 'Label Name',
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mobileController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Mobile', prefixIcon: Icon(Icons.phone)),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.wc),
                  ),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.cake),
                  ),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _fatherNameController,
                  decoration: const InputDecoration(labelText: 'Father Name', prefixIcon: Icon(Icons.person_outline)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _educationController,
                  decoration: const InputDecoration(labelText: 'Education', prefixIcon: Icon(Icons.school)),
                ),
                const SizedBox(height: 16),

                // Date Pickers
                _buildDatePicker(context, 'Date of Birth', true),
                const SizedBox(height: 16),
                _buildDatePicker(context, 'Anniversary Date', false),

                const SizedBox(height: 24),
                // Business Info (Mapped to JSON Keys)
                TextFormField(
                  controller: _gotraController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Gotra ', prefixIcon: Icon(Icons.business)),
                ),

                const SizedBox(height: 24),
                Text(
                  'Business Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _firmNameController,
                  decoration: const InputDecoration(labelText: 'Firm Name (ms_firm_name)', prefixIcon: Icon(Icons.business)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _occupationController,
                  decoration: const InputDecoration(labelText: 'Occupation', prefixIcon: Icon(Icons.work)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _businessTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.store),
                  ),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _productServiceController,
                  decoration: const InputDecoration(
                    labelText: 'Product / Service',
                    prefixIcon: Icon(Icons.category),
                  ),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _officeAddressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Office Address',
                    prefixIcon: Icon(Icons.business_center),
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  'Address Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address (Home)', prefixIcon: Icon(Icons.location_on)),
                  maxLines: 2,
                ),


                const SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Pincode',
                    prefixIcon: Icon(Icons.pin),
                  ),
                ),


                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: state.isSaving ? null : _saveProfile,
                  child: Text(state.isSaving ? 'Saving...' : 'Update Profile'),
                ),
                const SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _selectDate(BuildContext context, bool isDateOfBirth) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDateOfBirth
          ? (_selectedDateOfBirth ?? DateTime.now())
          : (_selectedDateOfAnniversary ?? DateTime.now()),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isDateOfBirth) {
          _selectedDateOfBirth = picked;
        } else {
          _selectedDateOfAnniversary = picked;
        }
      });
    }
  }
  Widget _buildDatePicker(BuildContext context, String label, bool isDOB) {
    DateTime? date = isDOB ? _selectedDateOfBirth : _selectedDateOfAnniversary;
    return InkWell(
      onTap: () => _selectDate(context, isDOB),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.calendar_month)),
        child: Text(date != null ? DateFormat('dd MMM yyyy').format(date) : 'Select Date'),
      ),
    );
  }
}
