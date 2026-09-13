import 'package:flutter/material.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم')),
      body: const Center(
        child: Text(
          'واجهة القرآن الكريم (جاري التطوير...)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

