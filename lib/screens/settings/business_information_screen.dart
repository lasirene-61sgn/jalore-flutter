import 'package:flutter/material.dart';
import 'package:flutter_app/screens/members/model/member_model.dart';
import '../../config/theme.dart';

class BusinessInformationScreen extends StatefulWidget {
  final Member member;

  const BusinessInformationScreen({super.key, required this.member});

  @override
  State<BusinessInformationScreen> createState() => _BusinessInformationScreenState();
}

class _BusinessInformationScreenState extends State<BusinessInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _businessTypeController;
  late TextEditingController _businessNameController;
  late TextEditingController _businessAddressController;
  late TextEditingController _businessPhoneController;
  late TextEditingController _businessEmailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _businessTypeController = TextEditingController(text: widget.member.businessType ?? '');
    _businessNameController = TextEditingController(text: widget.member.productService ?? '');
    _businessAddressController = TextEditingController(text: widget.member.officeAddress ?? '');
    _businessPhoneController = TextEditingController(text: widget.member.mobile ?? widget.member.mobile);
    _businessEmailController = TextEditingController(text: widget.member.email ?? '');
  }

  @override
  void dispose() {
    _businessTypeController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _businessPhoneController.dispose();
    _businessEmailController.dispose();
    super.dispose();
  }

  // Future<void> _saveBusinessInfo() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //
  //     try {
  //       // Update member with business info
  //       final updatedMember = Member(
  //         id: widget.member.id,
  //         name: widget.member.name,
  //         mobile: widget.member.mobile,
  //         email: _businessEmailController.text,
  //         businessType: _businessTypeController.text,
  //         businessProducts: _businessNameController.text,
  //         officeAddress: _businessAddressController.text,
  //         officeNumber: _businessPhoneController.text,
  //         secondaryMobile: widget.member.secondaryMobile,
  //         fatherName: widget.member.fatherName,
  //         residenceAddress: widget.member.residenceAddress,
  //         residenceMobile: widget.member.residenceMobile,
  //         jaloreAddress: widget.member.jaloreAddress,
  //         jaloreContactNumber: widget.member.jaloreContactNumber,
  //         gender: widget.member.gender,
  //         age: widget.member.age,
  //         education: widget.member.education,
  //         dateOfBirth: widget.member.dateOfBirth,
  //         dateOfAnniversary: widget.member.dateOfAnniversary,
  //         familyImageUrl: widget.member.familyImageUrl,
  //         profileImageUrl: widget.member.profileImageUrl,
  //       );
  //
  //       // Save to local storage
  //       final box = await DataService.getMembersBox();
  //       await box.put(updatedMember.id, updatedMember.toJson());
  //
  //       if (!mounted) return;
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Business information updated successfully')),
  //       );
  //       Navigator.pop(context, updatedMember);
  //     } catch (e) {
  //       if (!mounted) return;
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to update: $e')),
  //       );
  //     } finally {
  //       if (mounted) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Information'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.backgroundWhite,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Manage your business details',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Business Type
                  TextFormField(
                    controller: _businessTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Business Type',
                      hintText: 'e.g., Textiles, Manufacturing, Services',
                      prefixIcon: Icon(Icons.business_center),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter business type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Business Name
                  TextFormField(
                    controller: _businessNameController,
                    decoration: const InputDecoration(
                      labelText: 'Business Name',
                      hintText: 'Enter your business name',
                      prefixIcon: Icon(Icons.store),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Business Address
                  TextFormField(
                    controller: _businessAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Business Address',
                      hintText: 'Enter business address',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Business Phone
                  TextFormField(
                    controller: _businessPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Business Phone',
                      hintText: 'Enter business phone number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // Business Email
                  TextFormField(
                    controller: _businessEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Business Email',
                      hintText: 'Enter business email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : (){

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: AppTheme.backgroundWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
