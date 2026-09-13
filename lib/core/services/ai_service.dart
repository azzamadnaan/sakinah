import 'dart:convert';
import 'package:http/http.dart' as http; // (سيتم إضافته في pubspec.yaml لاحقاً)

class AIService {
  // مفتاح الAPI ورابط النموذج (مثلاً Gemini API)
  static const String _apiKey = "AQ.Ab8RN6I7df0sZwvo-keVTSAEKEENB6F6e5OXdFxFf158lBRZ9w";
  static const String _baseUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

  static Future<String> sendMessageToAI(String prompt) async {
    try {
      // هيكل الاتصال المستقبلي بالذكاء الاصطناعي
      // يمكن استبداله حالياً برد تجريبي حتى يتم تفعيل المفتاح
      await Future.delayed(const Duration(seconds: 1));
      return "هذا رد تجريبي من خدمة AIService. تم استلام سؤالك: '$prompt'";
    } catch (e) {
      return "عذراً، حدث خطأ أثناء الاتصال بالمساعد الذكي.";
    }
  }
}

