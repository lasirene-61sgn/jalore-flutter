import 'package:flutter/material.dart';
import 'package:flutter_app/screens/matrimoney/model/matrimony_model.dart';
import 'package:flutter_app/screens/matrimoney/notifier/matrimony_notifier.dart';
import 'package:flutter_app/screens/matrimoney/ui/matrimoney_details.dart';
import 'package:flutter_app/screens/member_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme.dart';
import 'package:flutter_app/screens/members/notifier/member_notifier.dart';
import 'package:flutter_app/screens/members/model/member_model.dart';

class MatrimoneyScreen extends ConsumerStatefulWidget {
  const MatrimoneyScreen({super.key});

  @override
  ConsumerState<MatrimoneyScreen> createState() =>
      _MatrimoneyScreenState();
}

class _MatrimoneyScreenState extends ConsumerState<MatrimoneyScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // 1. Set default selection to male
      ref.read(matrimoneyNotifierProvider.notifier).setGenderFilter('male');

      // 2. Load the initial data
      ref.read(matrimoneyNotifierProvider.notifier)
          .loadMatrimoney('api/customer/customers-matrimony');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // void _showAgeFilterPopup() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Container(
  //         padding: const EdgeInsets.symmetric(vertical: 20),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text("Filter by Age",
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //             const Divider(),
  //             Expanded(
  //               child: ListView(
  //                 children: [
  //                   _buildPopupItem("All", null),
  //                   _buildPopupItem("18 to 25", "18-25"),
  //                   _buildPopupItem("25 to 30", "25-30"),
  //                   const Divider(),
  //                   const Padding(
  //                     padding: EdgeInsets.only(left: 16, top: 8),
  //                     child: Text("Specific Age", style: TextStyle(color: Colors.grey)),
  //                   ),
  //                   // List of ages 18 to 60
  //                   ...List.generate(43, (index) {
  //                     final age = (index + 18).toString();
  //                     return _buildPopupItem(age, age);
  //                   }),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  void _showAgeFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setPopupState) {
          final state = ref.watch(matrimoneyNotifierProvider);

          return Container(
            padding: EdgeInsets.only(
              left: 20, right: 20, top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Filter By Age", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),

                // --- SECTION 1: QUICK SELECT (TOP) ---
                // const Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text("Quick Options", style: TextStyle(color: Colors.grey, fontSize: 13)),
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     _ageChip("All", null),
                //     _ageChip("18-25", "18-25"),
                //     _ageChip("20-24", "20-24"),
                //     _ageChip("25-30", "25-30"),
                //   ],
                // ),
                //
                // const SizedBox(height: 25),
                //
                // // --- SECTION 2: CUSTOM RANGE (BOTTOM) ---
                // const Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text("Custom Range", style: TextStyle(color: Colors.grey, fontSize: 13)),
                // ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: state.startAge,
                        hint: const Text("Start"),
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        items: List.generate(43, (i) => i + 18).map((a) =>
                            DropdownMenuItem(value: a, child: Text("$a"))).toList(),
                        onChanged: (val) {
                          ref.read(matrimoneyNotifierProvider.notifier).setCustomAgeRange(val, state.endAge);
                          setPopupState(() {}); // Updates dropdown checkmark locally
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("to")),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: state.endAge,
                        hint: const Text("End"),
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        items: List.generate(43, (i) => i + 18).map((a) =>
                            DropdownMenuItem(value: a, child: Text("$a"))).toList(),
                        onChanged: (val) {
                          ref.read(matrimoneyNotifierProvider.notifier).setCustomAgeRange(state.startAge, val);
                          setPopupState(() {});
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                SafeArea(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.ssjsSecondaryBlue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Apply Filter", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

bool searchShow = false;
  @override
  Widget build(BuildContext context) {
    final memberState = ref.watch(matrimoneyNotifierProvider);

    Widget _buildBody() {
      final state = ref.watch(matrimoneyNotifierProvider);
      // This uses the logic in matrimony_notifier.dart that filters by gender and age range
      final displayList = state.filteredList;

      if (state.isLoading && displayList.isEmpty) return const Center(child: CircularProgressIndicator());
      if (state.error != null) return Center(child: Text(state.error!));

      if (displayList.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_search, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No matching profiles found', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: displayList.length,
        padding: const EdgeInsets.only(bottom: 20),
        itemBuilder: (context, index) => _buildMemberTile(displayList[index]),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        title: const Text('Matrimony'),
        elevation: 0,
        actions: [
          // Inside AppBar actions
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchController.clear();
              final notifier = ref.read(matrimoneyNotifierProvider.notifier);
              notifier.clearAllFilters(); // Re-apply default
              notifier.loadMatrimoney('api/customer/customers-matrimony');
              notifier.setGenderFilter("male");
            },
          ),
          if(!searchShow)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _searchController.clear();
              setState(() => searchShow = !searchShow);
              final notifier = ref.read(matrimoneyNotifierProvider.notifier);
              notifier.setGenderFilter(ref.read(matrimoneyNotifierProvider).genderFilter); // Ensure "Boy" stays selected
              notifier.loadMatrimoney('api/customer/customers-matrimony');
            },
          )
// Inside TextField suffixIcon

        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if(searchShow)
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => searchShow = false);
                      final notifier = ref.read(matrimoneyNotifierProvider.notifier);
                      notifier.setGenderFilter(ref.read(matrimoneyNotifierProvider).genderFilter); // Ensure "Boy" stays selected
                      notifier.loadMatrimoney('api/customer/customers-matrimony');
                    },
                  )
                ),
              ),
            ),
// Inside build() method, above Expanded(child: _buildBody())
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildGenderButton(label: "Boy", value: "male", icon: Icons.male),
                  const SizedBox(width: 12),
                  _buildGenderButton(label: "Girl", value: "female", icon: Icons.female),
                  const SizedBox(width: 12),
                  _buildFilterButton(),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }
  Widget _buildFilterButton() {
    final state = ref.watch(matrimoneyNotifierProvider);
    final bool isActive = state.startAge != null || state.endAge != null;

    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () => _showAgeFilterPopup(),
        icon: Icon(
          Icons.filter_list_alt,
          color: isActive ? Colors.white : AppTheme.primaryBlue,
        ),
        label: const Text("Filter"),
        style: OutlinedButton.styleFrom(
          backgroundColor:
          isActive ? AppTheme.ssjsSecondaryBlue : Colors.transparent,
          foregroundColor:
          isActive ? Colors.white : AppTheme.primaryBlue,
          side: BorderSide(color: AppTheme.ssjsSecondaryBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
  Widget _buildGenderButton({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final currentGender = ref.watch(matrimoneyNotifierProvider).genderFilter;
    final isSelected = currentGender == value;

    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {
          // ✅ Do NOT allow unselect
          if (!isSelected) {
            ref
                .read(matrimoneyNotifierProvider.notifier)
                .setGenderFilter(value);
          }
        },
        icon: Icon(
          icon,
          color: isSelected ? Colors.white : AppTheme.primaryBlue,
        ),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor:
          isSelected ? AppTheme.ssjsSecondaryBlue : Colors.transparent,
          foregroundColor:
          isSelected ? Colors.white : AppTheme.primaryBlue,
          side: BorderSide(color: AppTheme.ssjsSecondaryBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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

    if (state.matrimoneyList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search,
                size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No help_support found',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.matrimoneyList.length,
      padding: const EdgeInsets.only(bottom: 20),
      itemBuilder: (context, index) {
        return _buildMemberTile(state.matrimoneyList[index]);
      },
    );
  }

  Widget _buildMemberTile(Matrimoney member) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MatrimoneyDetailScreen(matrimoney: member),
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
                child:
                // (member != null &&
                //     member.image!.isNotEmpty)
                //     ? Image.network(
                //   member.image!,
                //   fit: BoxFit.cover,
                //   errorBuilder:
                //       (context, error, stackTrace) =>
                //   const Icon(Icons.person,
                //       color:
                //       AppTheme.primaryBlue),
                // )
                //     :
                const Icon(Icons.person,
                    color: AppTheme.primaryBlue),
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
                        member.familyMemberMobile.toString(),
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
            const Icon(Icons.chevron_right,
                color: AppTheme.dividerGrey),
          ],
        ),
      ),
    );
  }
}
