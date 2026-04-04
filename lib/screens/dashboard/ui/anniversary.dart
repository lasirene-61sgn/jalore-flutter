import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_app/config/theme.dart';
import 'package:flutter_app/screens/members/model/member_model.dart';
import 'package:flutter_app/screens/members/notifier/member_notifier.dart';

class AnniversaryScreen extends ConsumerStatefulWidget {
  const AnniversaryScreen({super.key});

  @override
  ConsumerState<AnniversaryScreen> createState() => _AnniversaryScreenState();
}

class _AnniversaryScreenState extends ConsumerState<AnniversaryScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  final _formatter = DateFormat('dd MMM');

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(membersNotifierProvider.notifier).loadMembers('api/customer/customers');
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day && date.month == now.month;
  }

  bool _isInRange(DateTime date) {
    if (_startDate == null && _endDate == null) {
      return _isToday(date);
    }

    final start = (_startDate ?? _endDate)!.month * 100 + (_startDate ?? _endDate)!.day;
    final end = (_endDate ?? _startDate)!.month * 100 + (_endDate ?? _startDate)!.day;
    final target = date.month * 100 + date.day;

    if (start <= end) {
      return target >= start && target <= end;
    } else {
      return target >= start || target <= end;
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, now.day),
      firstDate: DateTime(now.year, 1, 1),
      lastDate: DateTime(now.year, 12, 31),
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

    // Assuming your Member model has a field like 'anniversaryDate' or 'dateOfMarriage'
    // Replace 'dateOfBirth' with the correct field name from your Member model
    final filteredMembers = state.membersList.where((m) {
      if (m.anniversaryDate == null) return false;
      return _isInRange(m.anniversaryDate!);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        title: const Text('Anniversaries', style: TextStyle(color: Colors.white)),
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
            const Icon(Icons.favorite_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              (_startDate != null || _endDate != null) ? 'No anniversaries in this range' : 'No anniversaries today 💍',
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
                // Replace dateOfBirth with anniversaryDate field if it exists
                Text(DateFormat('dd MMM').format(member.anniversaryDate!), style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          if (_isToday(member.anniversaryDate!))
            const Chip(
                label: Text("TODAY", style: TextStyle(fontSize: 10, color: Colors.pink)),
                backgroundColor: Color(0xFFFCE4EC)
            ),
          const Icon(Icons.chevron_right, color: AppTheme.dividerGrey),
        ],
      ),
    );
  }
}