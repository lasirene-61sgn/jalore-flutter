import 'package:flutter/material.dart';
import 'package:flutter_app/screens/commitie/model/commitie_model.dart';
import 'package:flutter_app/screens/commitie/notifier/commitie_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme.dart';

class CommitteeScreen extends ConsumerStatefulWidget {
  const CommitteeScreen({super.key});

  @override
  ConsumerState<CommitteeScreen> createState() => _CommitteeScreenState();
}

class _CommitteeScreenState extends ConsumerState<CommitteeScreen> {
  List<CommitteeMember> _committeeMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(committeeNotifierProvider.notifier).loadCommittee();
    });
    // _loadCommitteeMembers();

  }

  // Future<void> _loadCommitteeMembers() async {
  //   try {
  //     final help_support = await DataService.getCommitteeMembers();
  //     setState(() {
  //       _committeeMembers = help_support;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final committeeState = ref.watch(committeeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        title: const Text('Committee Members'),
      ),
      body: SafeArea(
        child: committeeState.isLoading && committeeState.committeeList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : committeeState.committeeList.isEmpty
                ? const Center(child: Text('No committee help_support found'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.70,
                    ),
                    itemCount: committeeState.committeeList.length,
                    itemBuilder: (context, index) {
                      final member = committeeState.committeeList[index];
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
            child: member.imagePath != null
                ? ClipOval(
              child: Image.network(
                member.imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  color: AppTheme.primaryBlue,
                  size: 50,
                ),
              ),
            )
                : const Icon(
              Icons.person,
              color: AppTheme.primaryBlue,
              size: 50,
            ),
          ),

          const SizedBox(height: 10),

          /// 🔑 FLEXIBLE CONTENT
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    member.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Mobile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone,
                          size: 14, color: AppTheme.textGrey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          member.phone,
                          overflow: TextOverflow.ellipsis,
                          style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

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
              member.postName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.backgroundWhite,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

}
