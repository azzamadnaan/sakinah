import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // مفتاح الـ API الخاص بـ Gemini (يمكنك استبداله بمفتاحك الخاص)
  static const String _apiKey = "AQ.Ab8RN6I7df0sZwvo-keVTSAEKEENB6F6e5OXdFxFf158lBRZ9w";
  
  // استخدام نموذج gemini-1.5-flash للأداء السريع والخفيف على الهواتف
  static const String _baseUrl = 
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  static Future<String> getAIResponse(String userMessage) async {
    try {
      final url = Uri.parse("$_baseUrl?key=$_apiKey");
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "contents": [
            {
              "parts": [
                {
                  "text": "أنت مساعد إسلامي ذكي ولطيف يدعى 'سكينة'. أجب عن السؤال التالي بطريقة شرعية صحيحة، مبسطة، وموجزة: $userMessage"
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final candidate = data['candidates']?[0];
        final text = candidate?['content']?['parts']?[0]?['text'];
        return text ?? "عذراً، لم أتمكن من صياغة الإجابة.";
      } else {
        return "عذراً، حدث خطأ في الاتصال بخدمة الذكاء الاصطناعي.";
      }
    } catch (e) {
      return "تأكد من اتصالك بالإنترنت لتفعيل ردود المساعد الذكي.";
    }
  }
}
