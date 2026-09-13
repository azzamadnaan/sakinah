import 'package:flutter/material.dart';

// شاشات التطبيق (سيتم برمجتها في الخطوات القادمة)
import '../../features/home/home_screen.dart';
import '../../features/prayer/prayer_screen.dart';
import '../../features/quran/quran_screen.dart';
import '../../features/azkar/azkar_screen.dart';
import '../../features/ai_assistant/ai_chat_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 2; // البدء بالصفحة الرئيسية

  // قائمة الشاشات الرئيسية
  final List<Widget> _screens = const [
    PrayerScreen(),
    QuranScreen(),
    HomeScreen(),
    AzkarScreen(),
    AIChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
      // الكرة الناعمة العائمة (Floating Glass Ball) للوصول السريع للمساعد الذكي
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F766E).withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _currentIndex = 4; // الانتقال مباشرة لشاشة المساعد الذكي
            });
          },
          backgroundColor: const Color(0xFF0F766E),
          elevation: 0,
          shape: const CircleBorder(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.psychology, color: Colors.white, size: 28),
              // لمسة أباتار / نقطة نشطة ذكية
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.amberAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // شريط التنقل السفلي الاحترافي
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.access_time_rounded),
            label: 'المواقيت',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_rounded),
            label: 'القرآن',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_rounded),
            label: 'الأذكار',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_rounded),
            label: 'المساعد',
          ),
        ],
      ),
    );
  }
}

