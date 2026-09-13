import 'package:flutter/material.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مواقيت الصلاة')),
      body: const Center(
        child: Text(
          'واجهة مواقيت الصلاة (جاري التطوير...)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

