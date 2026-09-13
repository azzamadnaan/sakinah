import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class PrayerDayModel {
  final String date;
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerDayModel({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerDayModel.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'];
    final dateInfo = json['date'];
    
    String cleanTime(String time) {
      return time.split(' ').first;
    }

    return PrayerDayModel(
      date: dateInfo['readable'] ?? '',
      fajr: cleanTime(timings['Fajr'] ?? ''),
      sunrise: cleanTime(timings['Sunrise'] ?? ''),
      dhuhr: cleanTime(timings['Dhuhr'] ?? ''),
      asr: cleanTime(timings['Asr'] ?? ''),
      maghrib: cleanTime(timings['Maghrib'] ?? ''),
      isha: cleanTime(timings['Isha'] ?? ''),
    );
  }
}

class PrayerService {
  // دالة للحصول على إحداثيات الجهاز الحالي مع التحقق من الأذونات
  static Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }

  // جلب مواقيت الشهر كاملة باستخدام خطوط الطول والعرض الفعلي للمستخدم
  static Future<List<PrayerDayModel>> fetchMonthPrayerTimesByLocation({int method = 4}) async {
    try {
      Position? position = await _determinePosition();
      
      // إحداثيات افتراضية (مثل عدن/اليمن) في حال رفض إذن الموقع أو تعذر الحصول عليه
      double lat = position?.latitude ?? 12.7855;
      double lon = position?.longitude ?? 45.0187;

      final now = DateTime.now();
      // نقطة النهاية (Endpoint) الخاصة بـ AlAdhan تعتمد على الإحداثيات (Coordinates)
      final url = Uri.parse(
        'https://api.aladhan.com/v1/calendar?latitude=$lat&longitude=$lon&method=$method&month=${now.month}&year=${now.year}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          List daysList = data['data'];
          return daysList.map((day) => PrayerDayModel.fromJson(day)).toList();
        }
      }
      throw Exception('فشل جلب المواقيت');
    } catch (e) {
      return _getOfflineFallbackSchedule();
    }
  }

  // جدول احتياطي محلي يعمل تلقائياً في حال عدم توفر الإنترنت أو إذن الموقع
  static List<PrayerDayModel> _getOfflineFallbackSchedule() {
    List<PrayerDayModel> fallback = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      DateTime targetDate = now.add(Duration(days: i));
      fallback.add(
        PrayerDayModel(
          date: targetDate.toString().split(' ').first,
          fajr: '04:30',
          sunrise: '05:50',
          dhuhr: '12:00',
          asr: '03:15',
          maghrib: '06:05',
          isha: '07:30',
        ),
      );
    }
    return fallback;
  }
}

