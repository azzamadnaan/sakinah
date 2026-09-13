import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  bool _isAlarmEnabled = true;
  final String _alarmTime = '04:30 ص';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2F1), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildMainAlarmCard(),
              const SizedBox(height: 25),
              Expanded(child: _buildVerificationInfoSection()),
            ],
          ),
        ),
      ),
    );
  }

  // 1. ترويسة الشاشة
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'المنبه الذكي للفجر',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F766E),
            ),
          ),
          Switch(
            value: _isAlarmEnabled,
            activeColor: const Color(0xFF0F766E),
            onChanged: (value) {
              setState(() {
                _isAlarmEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // 2. بطاقة المنبه الرئيسية
  Widget _buildMainAlarmCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isAlarmEnabled
              ? [const Color(0xFF0F766E), const Color(0xFF14B8A6)]
              : [Colors.grey.shade400, Colors.grey.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: (_isAlarmEnabled ? const Color(0xFF0F766E) : Colors.grey)
                .withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.alarm_rounded, color: Colors.white, size: 50),
          const SizedBox(height: 15),
          Text(
            _alarmTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _isAlarmEnabled ? 'المنبه مفعل مع تحدي الاستيقاظ' : 'المنبه متوقف',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // 3. قسم شرح تحدي الكاميرا والذكاء الاصطناعي
  Widget _buildVerificationInfoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'شروط إيقاف المنبه',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F766E),
            ),
          ),
          const SizedBox(height: 15),
          _buildInfoCard(
            icon: Icons.camera_alt_rounded,
            title: 'التحقق البصري (TFLite)',
            description: 'لن يتوقف صوت المنبه إلا عند توجيه الكاميرا وتصوير "سجادة الصلاة" أو "المصحف الشريف" للتأكد من استيقاظك الفعلي.',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.psychology_rounded,
            title: 'بدون إنترنت (Offline)',
            description: 'النموذج يعمل محلياً على هاتفك تماماً لضمان الخصوصية وسرعة الاستجابة حتى بدون اتصال.',
          ),
        ],
      ),
    );
  }

  // ويدجت مصغر لعرض مميزات التحدي
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF0F766E), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
