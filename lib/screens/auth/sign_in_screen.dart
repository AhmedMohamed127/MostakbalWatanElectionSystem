import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _idController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'تسجيل الدخول',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  Card(
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
                              controller: _idController,
                              decoration: const InputDecoration(
                                labelText: 'الرقم التعريفي',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'ادخل الرقم التعريفي' : null,
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: _loading
                                  ? null
                                  : () async {
                                      if (!_formKey.currentState!.validate()) return;
                                      setState(() => _loading = true);
                                      final ok = await context.read<AuthProvider>().signIn(id: _idController.text.trim());
                                      setState(() => _loading = false);
                                      if (ok && mounted) {
                                        await showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text('تم'),
                                            content: const Text('تم تسجيل الدخول بنجاح'),
                                            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
                                          ),
                                        );
                                        if (!mounted) return;
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                                      } else {
                                        if (!mounted) return;
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text('خطأ'),
                                            content: const Text('المستخدم غير موجود، قم بالتسجيل'),
                                            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
                                          ),
                                        );
                                      }
                                    },
                              child: _loading ? const CircularProgressIndicator() : const Text('دخول'),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignUpScreen()));
                              },
                              child: const Text('مستخدم جديد؟ إنشاء حساب'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



