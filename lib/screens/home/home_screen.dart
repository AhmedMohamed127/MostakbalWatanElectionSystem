import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../tabs/register_voter_tab.dart';
import '../tabs/confirm_vote_tab.dart';
import '../tabs/finalize_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final List<Widget> _tabs = const [
    RegisterVoterTab(),
    ConfirmVoteTab(),
    FinalizeTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(user != null ? 'مرحباً، ${user.name}' : 'الصفحة الرئيسية'),
      ),
      body: _tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.how_to_vote_outlined), label: 'تسجيل الناخب'),
          NavigationDestination(icon: Icon(Icons.checklist_outlined), label: 'تأكيد الانتخاب'),
          NavigationDestination(icon: Icon(Icons.verified_user_outlined), label: 'اعتماد الإجراءات'),
        ],
      ),
    );
  }
}



