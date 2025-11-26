import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/data_service.dart';
import '../models/committee_member.dart';

class CommitteeScreen extends StatefulWidget {
  const CommitteeScreen({super.key});

  @override
  State<CommitteeScreen> createState() => _CommitteeScreenState();
}

class _CommitteeScreenState extends State<CommitteeScreen> {
  List<CommitteeMember> _committeeMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCommitteeMembers();
  }

  Future<void> _loadCommitteeMembers() async {
    try {
      final members = await DataService.getCommitteeMembers();
      setState(() {
        _committeeMembers = members;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Committee Members'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _committeeMembers.isEmpty
                ? const Center(child: Text('No committee members found'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _committeeMembers.length,
                    itemBuilder: (context, index) {
                      final member = _committeeMembers[index];
                      return _buildCommitteeMemberCard(member);
                    },
                  ),
      ),
    );
  }

  Widget _buildCommitteeMemberCard(CommitteeMember member) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerGrey, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.backgroundGrey,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryBlue, width: 2),
            ),
            child: member.imageUrl != null
                ? ClipOval(
                    child: Image.network(
                      member.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          color: AppTheme.primaryBlue,
                          size: 50,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.person,
                    color: AppTheme.primaryBlue,
                    size: 50,
                  ),
          ),
          const SizedBox(height: 12),
          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              member.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          // Mobile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, size: 14, color: AppTheme.textGrey),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    member.mobile,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppTheme.dividerGrey,
          ),
          const SizedBox(height: 8),
          // Position
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              member.position,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.backgroundWhite,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
