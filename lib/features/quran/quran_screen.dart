import 'package:flutter/material.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  // قائمة وهمية لبعض السور (سيتم ربطها لاحقاً بقاعدة بيانات أو ملف JSON كامل للقرآن)
  final List<Map<String, dynamic>> _surahs = [
    {'number': 1, 'name': 'سورة الفاتحة', 'type': 'مكية', 'verses': 7, 'page': 1},
    {'number': 2, 'name': 'سورة البقرة', 'type': 'مدنية', 'verses': 286, 'page': 2},
    {'number': 36, 'name': 'سورة يس', 'type': 'مكية', 'verses': 83, 'page': 440},
    {'number': 67, 'name': 'سورة الملك', 'type': 'مكية', 'verses': 30, 'page': 562},
    {'number': 112, 'name': 'سورة الإخلاص', 'type': 'مكية', 'verses': 4, 'page': 604},
  ];

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
              const SizedBox(height: 15),
              _buildDailyWirdCard(),
              const SizedBox(height: 20),
              Expanded(child: _buildSurahList()),
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
            'القرآن الكريم',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F766E),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_rounded, color: Color(0xFF0F766E), size: 28),
            onPressed: () {
              // الانتقال للعلامة المرجعية الأخيرة (قريباً)
            },
            tooltip: 'العلامة المرجعية',
          ),
        ],
      ),
    );
  }

  // 2. بطاقة الورد اليومي والختمة
  Widget _buildDailyWirdCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'وِردك اليومي الحالي',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 12),
                child: const Text('الجزء الأول', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'الصفحة 15 من 604',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 15 / 604,
              backgroundColor: Colors.white.withOpacity(0.2),
              color: Colors.amberAccent,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  // 3. قائمة السور
  Widget _buildSurahList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
          'فهرس السور',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _surahs.length,
            itemBuilder: (context, index) {
              final surah = _surahs[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE0F2F1),
                    child: Text(
                      '${surah['number']}',
                      style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    surah['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  ),
                  subtitle: Text(
                    '${surah['type']} • ${surah['verses']} آيات',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  trailing: Text(
                    'ص ${surah['page']}',
                    style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  onTap: () {
                    // هنا سيتم فتح صفحة القراءة الخاصة بالسورة لاحقاً
                  },
                ),
              );
            },
          ),
        ),
      ],
      ),
    );
  }
}
