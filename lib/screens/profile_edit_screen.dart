import 'package:flutter/material.dart';
import 'package:flutter_app/screens/members/model/member_model.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

class ProfileEditScreen extends StatefulWidget {
  final Member member;

  const ProfileEditScreen({super.key, required this.member});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _fatherNameController;
  late TextEditingController _businessTypeController;
  late TextEditingController _businessProductsController;
  late TextEditingController _officeAddressController;
  late TextEditingController _ageController;
  late TextEditingController _educationController;
  
  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  DateTime? _selectedDateOfAnniversary;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _mobileController = TextEditingController(text: widget.member.mobile);
    _emailController = TextEditingController(text: widget.member.email);
    _fatherNameController = TextEditingController(text: widget.member.fatherName);
    _businessTypeController = TextEditingController(text: widget.member.businessType);
    _businessProductsController = TextEditingController(text: widget.member.productService);
    _officeAddressController = TextEditingController(text: widget.member.officeAddress);
    _ageController = TextEditingController(text: widget.member.age?.toString());
    _educationController = TextEditingController(text: widget.member.education);
    
    _selectedGender = widget.member.gender;
    _selectedDateOfBirth = widget.member.dateOfBirth;
    _selectedDateOfAnniversary = widget.member.anniversaryDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _fatherNameController.dispose();
    _businessTypeController.dispose();
    _businessProductsController.dispose();
    _officeAddressController.dispose();
    _ageController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isDateOfBirth) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDateOfBirth
          ? _selectedDateOfBirth ?? DateTime.now()
          : _selectedDateOfAnniversary ?? DateTime.now(),
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

  // Future<void> _saveProfile() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //
  //   setState(() {
  //     _isSaving = true;
  //   });
  //
  //   try {
  //     final updatedMember = Member(
  //       id: widget.member.id,
  //       name: _nameController.text,
  //       mobile: _mobileController.text,
  //       email: _emailController.text.isNotEmpty ? _emailController.text : null,
  //       fatherName: _fatherNameController.text.isNotEmpty ? _fatherNameController.text : null,
  //       businessType: _businessTypeController.text.isNotEmpty ? _businessTypeController.text : null,
  //       businessProducts: _businessProductsController.text.isNotEmpty ? _businessProductsController.text : null,
  //       officeAddress: _officeAddressController.text.isNotEmpty ? _officeAddressController.text : null,
  //       gender: _selectedGender,
  //       age: _ageController.text.isNotEmpty ? int.tryParse(_ageController.text) : null,
  //       education: _educationController.text.isNotEmpty ? _educationController.text : null,
  //       dateOfBirth: _selectedDateOfBirth,
  //       dateOfAnniversary: _selectedDateOfAnniversary,
  //       familyImageUrl: widget.member.familyImageUrl,
  //       profileImageUrl: widget.member.profileImageUrl,
  //     );
  //
  //     await DataService.saveMember(updatedMember);
  //
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Profile updated successfully')),
  //       );
  //       Navigator.pop(context);
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error saving profile: $e')),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isSaving = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: (){},
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundGrey,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primaryBlue, width: 2),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppTheme.primaryBlue,
                          size: 60,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Basic Information
                Text(
                  'Basic Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name (Head of the family)',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    return null;
                  },
                ),
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
                  controller: _fatherNameController,
                  decoration: const InputDecoration(
                    labelText: 'Father Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.wc),
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _educationController,
                  decoration: const InputDecoration(
                    labelText: 'Education',
                    prefixIcon: Icon(Icons.school),
                  ),
                ),
                const SizedBox(height: 16),

                // Date of Birth
                InkWell(
                  onTap: () => _selectDate(context, true),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.cake),
                    ),
                    child: Text(
                      _selectedDateOfBirth != null
                          ? DateFormat('dd MMM yyyy').format(_selectedDateOfBirth!)
                          : 'Select Date',
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Date of Anniversary
                InkWell(
                  onTap: () => _selectDate(context, false),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Anniversary',
                      prefixIcon: Icon(Icons.favorite),
                    ),
                    child: Text(
                      _selectedDateOfAnniversary != null
                          ? DateFormat('dd MMM yyyy').format(_selectedDateOfAnniversary!)
                          : 'Select Date',
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Business Information
                Text(
                  'Business Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _businessTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Business Type',
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _businessProductsController,
                  decoration: const InputDecoration(
                    labelText: 'Products/Services',
                    prefixIcon: Icon(Icons.inventory),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _officeAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Office Address',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : (){},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Update Profile'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
