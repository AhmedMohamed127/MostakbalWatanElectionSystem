import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/voter_provider.dart';
import '../../models/voter.dart';

class FinalizeTab extends StatefulWidget {
  const FinalizeTab({super.key});

  @override
  State<FinalizeTab> createState() => _FinalizeTabState();
}

class _FinalizeTabState extends State<FinalizeTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<VoterProvider>().loadAll());
  }

  @override
  Widget build(BuildContext context) {
    final voters = context.watch<VoterProvider>().voters;
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('الناخبون قيد الاعتماد', textDirection: TextDirection.rtl),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(value: v.isVoted, onChanged: null, activeColor: Colors.green),
                    const SizedBox(width: 8),
                    Checkbox(
                      value: v.isProcessConfirmed,
                      onChanged: (value) async {
                        if (v.localId == null) return;
                        await context.read<VoterProvider>().setProcessConfirmed(v.localId!, value ?? false);
                        if (!mounted) return;
                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('تم'),
                            content: const Text('تم اعتماد الإجراءات'),
                            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
                          ),
                        );
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}



