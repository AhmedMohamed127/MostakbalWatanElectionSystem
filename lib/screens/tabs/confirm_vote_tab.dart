import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/voter_provider.dart';
import '../../models/voter.dart';

class ConfirmVoteTab extends StatefulWidget {
  const ConfirmVoteTab({super.key});

  @override
  State<ConfirmVoteTab> createState() => _ConfirmVoteTabState();
}

class _ConfirmVoteTabState extends State<ConfirmVoteTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<VoterProvider>().loadAll());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final voters = context.watch<VoterProvider>().voters;
    return Column(
      children: [
        const SizedBox(height: 12),
        if (user != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'المستخدم: ${user.name} | الرقم: ${user.id}',
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => context.read<VoterProvider>().loadAll(search: v),
            decoration: const InputDecoration(
              hintText: 'ابحث برقم أو اسم كل الناخبين المسجلين',
              prefixIcon: Icon(Icons.search),
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: voters.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final Voter v = voters[index];
              return ListTile(
                leading: CircleAvatar(child: Text(v.fullName.isNotEmpty ? v.fullName[0] : '?')),
                title: Text(v.fullName, textDirection: TextDirection.rtl),
                subtitle: Text('رقم: ${v.nationalId}', textDirection: TextDirection.rtl),
                trailing: Checkbox(
                  value: v.isVoted,
                  onChanged: (value) async {
                    if (v.localId == null) return;
                    await context.read<VoterProvider>().setVoted(v.localId!, value ?? false);
                    if (!mounted) return;
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('تم'),
                        content: const Text('تم تحديث حالة التأكيد'),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
                      ),
                    );
                  },
                  activeColor: Colors.green,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}



