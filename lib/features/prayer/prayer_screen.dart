import 'package:flutter/material.dart';
import 'dart:async'; // نحتاجها لتشغيل العداد الزمني (Timer)

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  // بيانات وهمية مؤقتة (سيتم جلبها لاحقاً من PrayerService بناءً على موقع المستخدم)
  final String _nextPrayerName = 'العصر';
  Duration _timeLeft = const Duration(hours: 1, minutes: 24, seconds: 30);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  // دالة تشغيل العداد التنازلي كل ثانية
  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft.inSeconds > 0) {
            _timeLeft = _timeLeft - const Duration(seconds: 1);
          } else {
            // هنا سيتم تحديث الصلاة القادمة عند انتهاء الوقت
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // إيقاف العداد عند الخروج من الشاشة لتوفير البطارية
    super.dispose();
  }

  // دالة لتنسيق الوقت بشكل جميل (HH:MM:SS)
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // نفس تدرج الألوان لتوحيد الهوية البصرية للتطبيق
      body: Container(
        width: double.infinity,
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
              _buildCountdownHero(),
              const SizedBox(height: 25),
              Expanded(child: _buildPrayerList()),
            ],
          ),
        ),
      ),
    );
  }

  // 1. الترويسة
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'مواقيت الصلاة',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F766E),
            ),
          ),
          // زر تحديد الموقع أو الإعدادات
          IconButton(
            icon: const Icon(Icons.location_on_rounded, color: Color(0xFF0F766E), size: 28),
            onPressed: () {},
            tooltip: 'تحديث الموقع',
          ),
        ],
      ),
    );
  }

  // 2. بطاقة العداد التنازلي الكبيرة (Hero Card)
  Widget _buildCountdownHero() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)], // تدرج أخضر مزرق أنيق
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'الوقت المتبقي لصلاة $_nextPrayerName',
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
          ),
          const SizedBox(height: 15),
          Text(
            _formatDuration(_timeLeft), // عرض الوقت الحي
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: 2, // مسافة بين الأرقام لتبدو كالساعة الرقمية
            ),
          ),
        ],
      ),
    );
  }

  // 3. قائمة مواقيت الصلاة لليوم
  Widget _buildPrayerList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(), // تأثير سحب مرن
        children: [
          _buildPrayerTile(name: 'الفجر', time: '04:30 ص', icon: Icons.nights_stay),
          _buildPrayerTile(name: 'الشروق', time: '05:50 ص', icon: Icons.wb_twilight),
          _buildPrayerTile(name: 'الظهر', time: '12:00 م', icon: Icons.wb_sunny),
          _buildPrayerTile(name: 'العصر', time: '03:15 م', icon: Icons.wb_sunny_outlined, isNext: true),
          _buildPrayerTile(name: 'المغرب', time: '06:05 م', icon: Icons.brightness_3),
          _buildPrayerTile(name: 'العشاء', time: '07:30 م', icon: Icons.star_border),
          const SizedBox(height: 100), // مساحة سفلية لعدم تغطية الشريط السفلي
        ],
      ),
    );
  }

  // ويدجت مصغر لبناء كل صلاة في القائمة
  Widget _buildPrayerTile({
    required String name,
    required String time,
    required IconData icon,
    bool isNext = false, // لتحديد ما إذا كانت هذه هي الصلاة القادمة لتمييزها
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNext ? const Color(0xFF0F766E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isNext)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          if (isNext)
            BoxShadow(
              color: const Color(0xFF0F766E).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isNext ? Colors.white : const Color(0xFF0F766E),
                size: 28,
              ),
              const SizedBox(width: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                  color: isNext ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isNext ? Colors.white : const Color(0xFF0F766E),
            ),
          ),
        ],
      ),
    );
  }
}
