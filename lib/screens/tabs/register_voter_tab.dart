import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/voter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/voter_provider.dart';
import '../scan/scan_id_screen.dart';

class RegisterVoterTab extends StatefulWidget {
  const RegisterVoterTab({super.key});

  @override
  State<RegisterVoterTab> createState() => _RegisterVoterTabState();
}

class _RegisterVoterTabState extends State<RegisterVoterTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _registrarController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthProvider>().currentUser;
    _registrarController.text = user?.id ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('تسجيل الناخب', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'الاسم', prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'ادخل الاسم' : null,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nidController,
                          decoration: const InputDecoration(labelText: 'رقم البطاقة', prefixIcon: Icon(Icons.credit_card)),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'ادخل رقم البطاقة' : null,
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'مسح البطاقة',
                        onPressed: () async {
                          final result = await Navigator.of(context).push<String>(
                            MaterialPageRoute(builder: (_) => const ScanIdScreen()),
                          );
                          if (result != null && result.isNotEmpty) {
                            _nidController.text = result;
                            await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('تم'),
                                content: const Text('تم جلب رقم البطاقة بالمسح'),
                                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _registrarController,
                    decoration: const InputDecoration(labelText: 'الرقم التعريفي للمسجل', prefixIcon: Icon(Icons.badge_outlined)),
                    readOnly: true,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      final user = context.read<AuthProvider>().currentUser;
                      if (user == null) return;
                      final voter = Voter(
                        nationalId: _nidController.text.trim(),
                        fullName: _nameController.text.trim(),
                        registrarId: user.id,
                      );
                      await context.read<VoterProvider>().addVoter(voter);
                      if (!mounted) return;
                      _nameController.clear();
                      _nidController.clear();
                      await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('تم'),
                          content: const Text('تم تسجيل الناخب بنجاح'),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
                        ),
                      );
                    },
                    child: const Text('حفظ'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


