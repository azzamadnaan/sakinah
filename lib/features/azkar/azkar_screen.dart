import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // مهم جداً لإضافة الاهتزاز التفاعلي (Haptic Feedback)

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> with SingleTickerProviderStateMixin {
  int _counter = 0;
  final int _goal = 33; // الهدف الافتراضي للتسبيح

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // إعداد متحكم الحركة (Animation)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // سرعة النبضة
    );

    // إعداد تأثير التصغير والتكبير (Scale)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // إعادة الزر لحجمه الطبيعي بعد انتهاء الضغطة
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // دالة زيادة العداد مع تشغيل الحركة والاهتزاز
  void _incrementCounter() {
    HapticFeedback.lightImpact(); // اهتزاز خفيف جداً يشبه لمس حبة السبحة
    _animationController.forward(from: 0.0); // تشغيل حركة النبض
    
    setState(() {
      _counter++;
    });
  }

  // دالة تصفير العداد
  void _resetCounter() {
    HapticFeedback.mediumImpact(); // اهتزاز أقوى للتنبيه على التصفير
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // حساب نسبة التقدم في الدائرة
    double progress = (_counter % _goal) / _goal;
    if (_counter > 0 && _counter % _goal == 0) progress = 1.0;

    return Scaffold(
      // خلفية متناسقة مع الشاشة الرئيسية
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
              const Spacer(),
              _buildInteractiveMisbaha(progress),
              const Spacer(),
              _buildBottomText(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 1. الترويسة العلوية
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'المسبحة الإلكترونية',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F766E),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0F766E), size: 28),
            onPressed: _resetCounter,
            tooltip: 'تصفير العداد',
          ),
        ],
      ),
    );
  }

  // 2. المسبحة التفاعلية (الزر المركزي)
  Widget _buildInteractiveMisbaha(double progress) {
    return GestureDetector(
      onTap: _incrementCounter,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // الدائرة الخارجية (شريط التقدم)
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                backgroundColor: Colors.grey.shade200,
                color: const Color(0xFF14B8A6),
                strokeCap: StrokeCap.round,
              ),
            ),
            
            // الدائرة الداخلية (زر الضغط بمظهر زجاجي بارز)
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F766E).withOpacity(0.15),
                    blurRadius: 30,
                    spreadRadius: 10,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_counter',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                  Text(
                    'الهدف: $_goal',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. النص السفلي التشجيعي
  Widget _buildBottomText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Text(
        'سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F766E),
          height: 1.5,
        ),
      ),
    );
  }
}
