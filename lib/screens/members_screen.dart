import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/data_service.dart';
import '../models/member.dart';
import 'member_detail_screen.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<Member> _allMembers = [];
  List<Member> _filteredMembers = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    try {
      final members = await DataService.getAllMembers();
      setState(() {
        _allMembers = members;
        _filteredMembers = members;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchMembers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredMembers = _allMembers;
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        return member.name.toLowerCase().contains(lowerQuery) ||
            member.mobile.contains(query) ||
            (member.businessType?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    });
  }

  Map<String, List<Member>> _groupMembersByInitial() {
    final Map<String, List<Member>> grouped = {};
    for (var member in _filteredMembers) {
      final initial = member.name.isNotEmpty ? member.name[0].toUpperCase() : '#';
      if (!grouped.containsKey(initial)) {
        grouped[initial] = [];
      }
      grouped[initial]!.add(member);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedMembers = _groupMembersByInitial();
    final sortedInitials = groupedMembers.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _searchMembers,
                decoration: InputDecoration(
                  hintText: 'Search member',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchMembers('');
                          },
                        )
                      : null,
                ),
              ),
            ),

            // Members List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredMembers.isEmpty
                      ? const Center(child: Text('No members found'))
                      : ListView.builder(
                          itemCount: sortedInitials.length,
                          itemBuilder: (context, index) {
                            final initial = sortedInitials[index];
                            final members = groupedMembers[initial]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Initial Header
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  color: AppTheme.backgroundGrey,
                                  child: Text(
                                    initial,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppTheme.primaryBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                // Members in this group
                                ...members.map((member) => _buildMemberTile(member)),
                              ],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(Member member) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemberDetailScreen(member: member),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.dividerGrey, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.backgroundGrey,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryBlue, width: 2),
              ),
              child: member.profileImageUrl != null
                  ? ClipOval(
                      child: Image.network(
                        member.profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            color: AppTheme.primaryBlue,
                            size: 30,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      color: AppTheme.primaryBlue,
                      size: 30,
                    ),
            ),
            const SizedBox(width: 16),
            // Member Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 16,
                        color: AppTheme.textGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        member.mobile,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
}
