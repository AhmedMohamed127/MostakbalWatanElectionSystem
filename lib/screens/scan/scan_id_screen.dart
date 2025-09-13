import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanIdScreen extends StatefulWidget {
  const ScanIdScreen({super.key});

  @override
  State<ScanIdScreen> createState() => _ScanIdScreenState();
}

class _ScanIdScreenState extends State<ScanIdScreen> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مسح البطاقة')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_handled) return;
              final barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;
              final value = barcodes.first.rawValue ?? '';
              if (value.isEmpty) return;
              _handled = true;
              Navigator.pop(context, value);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text('وجّه الكاميرا نحو رمز البطاقة', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}



