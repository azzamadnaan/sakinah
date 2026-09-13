import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية بتدرج لوني ناعم جداً مريح للعين
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2F1), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              _buildHeader(),
              const SizedBox(height: 35),
              _buildNextPrayerCard(context),
              const SizedBox(height: 35),
              _buildDailyProgress(),
            ],
          ),
        ),
      ),
    );
  }

  // 1. قسم الترحيب العلوي
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'السلام عليكم،',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              'كيف حال قلبك اليوم؟ 🌿',
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF0F766E)
              ),
            ),
          ],
        ),
        // الأفاتار الشخصي (يمكن تغييره لاحقاً)
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F766E).withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color(0xFF0F766E), size: 30),
          ),
        ),
      ],
    );
  }

  // 2. بطاقة الصلاة القادمة (تصميم بارز وجذاب)
  Widget _buildNextPrayerCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)], // تدرج Teal
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الصلاة القادمة',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
              ),
              const Icon(Icons.notifications_active, color: Colors.white, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'صلاة العصر',
            style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'متبقي 01:24:30',
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
          ),
        ],
      ),
    );
  }

  // 3. قسم الإنجاز والورد اليومي
  Widget _buildDailyProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إنجاز اليوم',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildProgressCard('القرآن', '2/4 صفحات', 0.5, Icons.menu_book_rounded)),
            const SizedBox(width: 16),
            Expanded(child: _buildProgressCard('الأذكار', 'مكتمل', 1.0, Icons.favorite_rounded)),
          ],
        ),
      ],
    );
  }

  // ويدجت مصغر لبناء بطاقات الإنجاز (لتجنب تكرار الكود)
  Widget _buildProgressCard(String title, String subtitle, double progress, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0F766E), size: 24),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xFF14B8A6),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
