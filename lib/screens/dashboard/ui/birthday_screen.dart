import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Ensure these paths match your project structure
import 'package:flutter_app/config/theme.dart';
import 'package:flutter_app/screens/members/model/member_model.dart';
import 'package:flutter_app/screens/members/notifier/member_notifier.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  final _formatter = DateFormat('dd MMM');

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Initial data load
      ref.read(membersNotifierProvider.notifier).loadMembers('api/customer/customers');
    });
  }

  // Logic: Check if birthday is Today
  bool _isToday(DateTime dob) {
    final now = DateTime.now();
    return dob.day == now.day && dob.month == now.month;
  }

  // Logic: Range Filtering ignoring Year
  bool _isInRange(DateTime dob) {
    // Default to Today if no filter is active
    if (_startDate == null && _endDate == null) {
      return _isToday(dob);
    }

    // Convert to MMDD format (e.g., 305 for March 5th)
    final start = (_startDate ?? _endDate)!.month * 100 + (_startDate ?? _endDate)!.day;
    final end = (_endDate ?? _startDate)!.month * 100 + (_endDate ?? _startDate)!.day;
    final target = dob.month * 100 + dob.day;

    if (start <= end) {
      return target >= start && target <= end;
    } else {
      // Handles ranges crossing New Year (e.g., Dec to Jan)
      return target >= start || target <= end;
    }
  }

  // Picker that hides year selection by restricting range to current year
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, now.day),
      firstDate: DateTime(now.year, 1, 1), // Lock to current year
      lastDate: DateTime(now.year, 12, 31), // Lock to current year
      initialDatePickerMode: DatePickerMode.day,
      helpText: isStart ? 'START DAY & MONTH' : 'END DAY & MONTH',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.ssjsSecondaryBlue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            // Hide the year from the header if possible in the current Flutter version
            textTheme: const TextTheme(
              headlineMedium: TextStyle(fontSize: 20),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(membersNotifierProvider);

    final filteredMembers = state.membersList.where((m) {
      if (m.dateOfBirth == null) return false;
      return _isInRange(m.dateOfBirth!);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        title: const Text('Birthdays', style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(membersNotifierProvider.notifier).loadMembers('api/customer/customers'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  _buildFilterButton(
                    label: 'Today',
                    isSelected: _startDate == null && _endDate == null,
                    flex: 1,
                    onTap: () => setState(() {
                      _startDate = null;
                      _endDate = null;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterButton(
                    label: _startDate == null ? 'Start' : _formatter.format(_startDate!),
                    isSelected: _startDate != null,
                    flex: 2,
                    onTap: () => _pickDate(isStart: true),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterButton(
                    label: _endDate == null ? 'End' : _formatter.format(_endDate!),
                    isSelected: _endDate != null,
                    flex: 2,
                    onTap: () => _pickDate(isStart: false),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody(state, filteredMembers)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton({required String label, required bool isSelected, required int flex, required VoidCallback onTap}) {
    return Expanded(
      flex: flex,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? AppTheme.ssjsSecondaryBlue : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          side: BorderSide(color: isSelected ? AppTheme.ssjsSecondaryBlue : Colors.black12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBody(state, filteredMembers) {
    if (state.isLoading && filteredMembers.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.ssjsSecondaryBlue));
    }
    if (filteredMembers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cake_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              (_startDate != null || _endDate != null) ? 'No birthdays in this range' : 'No birthdays today 🎂',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) => _buildMemberTile(filteredMembers[index]),
    );
  }

  Widget _buildMemberTile(Member member) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.dividerGrey, width: 0.5))),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.backgroundGrey,
            backgroundImage: member.image != null ? NetworkImage(member.image!) : null,
            child: member.image == null ? const Icon(Icons.person, color: AppTheme.ssjsSecondaryBlue) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(DateFormat('dd MMM').format(member.dateOfBirth!), style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          if (_isToday(member.dateOfBirth!))
            const Chip(label: Text("TODAY", style: TextStyle(fontSize: 10, color: Colors.green)), backgroundColor: Color(0xFFE8F5E9)),
          const Icon(Icons.chevron_right, color: AppTheme.dividerGrey),
        ],
      ),
    );
  }
}