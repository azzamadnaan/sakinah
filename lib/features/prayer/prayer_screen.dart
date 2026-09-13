import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/services/prayer_service.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  List<PrayerDayModel> _monthSchedule = [];
  bool _isLoading = true;
  Timer? _timer;
  Duration _timeLeft = const Duration(hours: 1, minutes: 24, seconds: 30);
  String _nextPrayerName = 'العصر';

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
    _startCountdown();
  }

  // جلب المواقيت عبر الـ API والخدمة التي أنشأناها
  Future<void> _loadPrayerTimes() async {
    setState(() => _isLoading = true);
    try {
      final schedule = await PrayerService.fetchMonthPrayerTimesByLocation();
      setState(() {
        _monthSchedule = schedule;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft.inSeconds > 0) {
            _timeLeft = _timeLeft - const Duration(seconds: 1);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    // جلب أوقات اليوم الحالي من الجدول إذا كان متوفراً
    PrayerDayModel? todayPrayer = _monthSchedule.isNotEmpty ? _monthSchedule.first : null;

    return Scaffold(
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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0F766E)),
                )
              : Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildCountdownHero(),
                    const SizedBox(height: 25),
                    Expanded(child: _buildPrayerList(todayPrayer)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'مواقيت الصلاة (تحديد تلقائي)',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F766E),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0F766E), size: 28),
            onPressed: _loadPrayerTimes,
            tooltip: 'تحديث المواقيت والموقع',
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownHero() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
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
            _formatDuration(_timeLeft),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerList(PrayerDayModel? today) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _buildPrayerTile(name: 'الفجر', time: today?.fajr ?? '--:--', icon: Icons.nights_stay),
          _buildPrayerTile(name: 'الشروق', time: today?.sunrise ?? '--:--', icon: Icons.wb_twilight),
          _buildPrayerTile(name: 'الظهر', time: today?.dhuhr ?? '--:--', icon: Icons.wb_sunny),
          _buildPrayerTile(name: 'العصر', time: today?.asr ?? '--:--', icon: Icons.wb_sunny_outlined, isNext: true),
          _buildPrayerTile(name: 'المغرب', time: today?.maghrib ?? '--:--', icon: Icons.brightness_3),
          _buildPrayerTile(name: 'العشاء', time: today?.isha ?? '--:--', icon: Icons.star_border),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPrayerTile({
    required String name,
    required String time,
    required IconData icon,
    bool isNext = false,
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
