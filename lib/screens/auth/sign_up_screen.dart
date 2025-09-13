import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
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
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'الاسم',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'ادخل الاسم' : null,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _idController,
                          decoration: const InputDecoration(
                            labelText: 'الرقم التعريفي',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'ادخل الرقم التعريفي' : null,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'الهاتف',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'ادخل الهاتف' : null,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _loading
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) return;
                                  setState(() => _loading = true);
                                  try {
                                    await context.read<AuthProvider>().signUp(
                                          id: _idController.text.trim(),
                                          name: _nameController.text.trim(),
                                          phone: _phoneController.text.trim(),
                                        );
                                    if (!mounted) return;
                                    await showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('تم'),
                                        content: const Text('تم إنشاء الحساب بنجاح'),
                                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
                                      ),
                                    );
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                  } catch (e) {
                                    if (!mounted) return;
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('خطأ'),
                                        content: const Text('فشل إنشاء الحساب. قد يكون المعرف مستخدماً.'),
                                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
                                      ),
                                    );
                                  } finally {
                                    if (mounted) setState(() => _loading = false);
                                  }
                                },
                          child: _loading ? const CircularProgressIndicator() : const Text('تسجيل'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



