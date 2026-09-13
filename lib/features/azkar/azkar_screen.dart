import 'package:flutter/material.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأذكار اليومية')),
      body: const Center(
        child: Text(
          'واجهة الأذكار والسبحة (جاري التطوير...)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

