import 'package:flutter/material.dart';
import 'package:flutter_app/config/theme.dart' show AppTheme;
import 'package:flutter_app/screens/business/model/business_model.dart';
import 'package:flutter_app/screens/business/notifier/business_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessScreen extends ConsumerStatefulWidget {
  const BusinessScreen({super.key});

  @override
  ConsumerState<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends ConsumerState<BusinessScreen> {
  final List<Map<String, dynamic>> _businesses = [
    {
      'name': 'Jain Textiles',
      'owner': 'Rajesh Jain',
      'category': 'Textile & Garments',
      'phone': '+91 98765 43210',
      'address': 'T Nagar, Chennai',
      'description': 'Premium quality textiles and ethnic wear',
      'icon': Icons.checkroom,
      'color': const Color(0xFFE91E63),
    },
    {
      'name': 'Sirohi Jewellers',
      'owner': 'Amit Jain',
      'category': 'Jewellery & Ornaments',
      'phone': '+91 98765 43211',
      'address': 'Mylapore, Chennai',
      'description': 'Traditional and modern jewellery designs',
      'icon': Icons.diamond,
      'color': const Color(0xFFFFB300),
    },
    {
      'name': 'Jain Sweets & Snacks',
      'owner': 'Priya Jain',
      'category': 'Food & Beverages',
      'phone': '+91 98765 43212',
      'address': 'Adyar, Chennai',
      'description': 'Pure vegetarian sweets and savory items',
      'icon': Icons.fastfood,
      'color': const Color(0xFFFF5722),
    },
    {
      'name': 'Tech Solutions',
      'owner': 'Vikram Jain',
      'category': 'IT & Software',
      'phone': '+91 98765 43213',
      'address': 'Anna Nagar, Chennai',
      'description': 'Web & mobile app development services',
      'icon': Icons.computer,
      'color': const Color(0xFF2196F3),
    },
    {
      'name': 'Jain Builders',
      'owner': 'Suresh Jain',
      'category': 'Real Estate & Construction',
      'phone': '+91 98765 43214',
      'address': 'Velachery, Chennai',
      'description': 'Residential and commercial construction',
      'icon': Icons.apartment,
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Granite & Marbles',
      'owner': 'Mahesh Jain',
      'category': 'Building Materials',
      'phone': '+91 98765 43215',
      'address': 'Porur, Chennai',
      'description': 'Premium quality granite and marble stones',
      'icon': Icons.layers,
      'color': const Color(0xFF9C27B0),
    },
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<String> get _categories {
    final categories = _businesses.map((b) => b['category'] as String).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  List<Map<String, dynamic>> get _filteredBusinesses {
    return _businesses.where((business) {
      final matchesSearch = business['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          business['owner'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          business['category'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || business['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }
 @override
  void initState() {
    super.initState();
    Future.microtask((){
      ref.read(businessNotifierProvider.notifier).loadBusiness("api/customer/business-names");
      ref.read(businessNotifierProvider.notifier).loadCategory("api/customer/business-names/categories");
    });
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Business Directory',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [Color(0xFF1E90FF), Color(0xFF4DA6FF)],
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // ),
              color: AppTheme.secondaryBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField( // Ensure controller is attached
                    onChanged: (value) async {
                      // Your existing search logic
                      if(_selectedCategory == 'All') {
                        await ref
                            .read(businessNotifierProvider.notifier)
                            .loadBusiness("api/customer/business-names?search=$value");
                      } else {
                        await ref
                            .read(businessNotifierProvider.notifier)
                            .loadBusiness("api/customer/business-names?search=$value&category=$_selectedCategory");
                      }
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      filled: false,
                      hintText: 'Search businesses...',
                      // Removes the line/border entirely
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      // Icon inside the container
                      icon: Icon(Icons.search, color: Color(0xFF1E90FF)),
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      // Set suffixIcon to null to remove the cancel button
                      suffixIcon: null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Category Filter
                SizedBox(
                  height:state.category.isEmpty?30: 40,
                  child:  state.isLoading && state.category.isEmpty
                      ?
                  Center(
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator()
                    ),
                  )
                      :
                  state.category.isEmpty?
                  //     ? Center(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(Icons.business_outlined, size: 64, color: Colors.grey[400]),
                  //       const SizedBox(height: 16),
                  //       Text(
                  //         'No Category found',
                  //         style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  //       ),
                  //     ],
                  //   ),
                  // )
                  SizedBox()
                      :  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.category.length,
                    itemBuilder: (context, index) {
                      final category = state.category[index];
                      final isSelected = category.categoryName == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              _selectedCategory = category.categoryName;
                            });
                            if(_selectedCategory == "All"){
                              ref.read(businessNotifierProvider.notifier).loadBusiness("api/customer/business-names");
                            }else {
                              await ref
                                  .read(businessNotifierProvider.notifier)
                                  .loadBusiness(
                                  "api/customer/business-names?category=${category
                                      .categoryName}");
                            }
                            },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              category.categoryName,
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF1E90FF) : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Business List
          Expanded(
            child:
            state.isLoading && state.businessList.isEmpty
                ?
                Center(
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator()
                    ),
                )
                :
            state.businessList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No businesses found',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.businessList.length,
                    itemBuilder: (context, index) {
                      final business = state.businessList[index];
                      return _buildBusinessCard(business);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCard(Business business) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          _showBusinessDetails(business);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              // Container(
              //   width: 60,
              //   height: 60,
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [
              //         business['color'],
              //         business['color'].withValues(alpha: 0.7),
              //       ],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Icon(
              //     business['icon'],
              //     color: Colors.white,
              //     size: 30,
              //   ),
              // ),
              const SizedBox(width: 16),
              // Business Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.msFirmName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      business.businessType,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.category, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            business.owner,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Call Button
              IconButton(
                icon: const Icon(Icons.phone, color: Color(0xFF1E90FF)),
                onPressed: () {
                 _makePhoneCall(business.mobile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBusinessDetails(Business business) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            // Container(
            //   padding: const EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [
            //         business['color'],
            //         business['color'].withValues(alpha: 0.7),
            //       ],
            //     ),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Icon(business['icon'], color: Colors.white),
            // ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                business.businessType,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(Icons.person, 'Owner', business.owner),
              _buildDetailRow(Icons.category, 'Category', business.msFirmName),
              _buildDetailRow(Icons.phone, 'Phone', business.mobile),
              _buildDetailRow(Icons.location_on, 'Address', business.officeAddress),
              const SizedBox(height: 12),
              // const Text(
              //   'Description',
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 14,
              //     color: Color(0xFF1E90FF),
              //   ),
              // ),
              // const SizedBox(height: 4),
              // Text(
              //   business['description'],
              //   style: const TextStyle(fontSize: 12, color: Colors.black87),
              // ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _makePhoneCall(business.mobile);
            },
            icon: const Icon(Icons.phone, color: Colors.white),
            label: const Text('Call Now', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E90FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1E90FF)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

}
