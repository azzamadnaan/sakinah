import 'package:flutter/material.dart';

class AIChatScreen extends StatelessWidget {
  const AIChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المساعد الذكي')),
      body: const Center(
        child: Text(
          'واجهة محادثة الذكاء الاصطناعي (جاري التطوير...)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

