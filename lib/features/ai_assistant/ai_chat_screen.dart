import 'package:flutter/material.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

// نستخدم SingleTickerProviderStateMixin لتشغيل الأنيميشن الخاص بالأفاتار
class _AIChatScreenState extends State<AIChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // قائمة وهمية للمحادثة (سنربطها لاحقاً بخدمة Gemini)
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'السلام عليكم ورحمة الله وبركاته،\nأنا مساعدك الذكي في "سكينة". كيف يمكنني مساعدتك اليوم في أمور دينك أو دُنياك؟ 🌿',
    }
  ];

  @override
  void initState() {
    super.initState();
    // إعداد تأثير النبض للأفاتار لجعله يبدو "حياً"
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // سرعة تنفس الأفاتار
    )..repeat(reverse: true); // يتكرر باستمرار (يكبر ويصغر بنعومة)

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // دالة إرسال الرسالة
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'isUser': true, 'text': text});
      _messageController.clear();
    });
    _scrollToBottom();

    // محاكاة تفكير المساعد الذكي ثم الرد
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'isUser': false,
            'text': 'هذا رد تجريبي. سيتم قريباً ربط هذا العقل الاصطناعي بخدمة GeminiService لتقديم إجابات حقيقية ودقيقة بإذن الله.',
          });
        });
        _scrollToBottom();
      }
    });
  }

  // دالة للنزول لآخر المحادثة تلقائياً
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFB), // لون خلفية هادئ جداً
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(
                    text: msg['text'],
                    isUser: msg['isUser'],
                  );
                },
              ),
            ),
            _buildMessageInputField(),
          ],
        ),
      ),
    );
  }

  // 1. شريط علوي مخصص يحتوي على أفاتار المساعد الننابض
  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // الأفاتار التفاعلي (ينبض)
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F766E).withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(Icons.auto_awesome, color: Color(0xFF0F766E), size: 24),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // اسم المساعد وحالته
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'سكينة AI',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F766E),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'متصل ويستمع إليك',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. تصميم فقاعات المحادثة (Chat Bubbles)
  Widget _buildMessageBubble({required String text, required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15, top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, // أقصى عرض للفقاعة
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF0F766E) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 0 : 20), // زاوية حادة لجهة المستخدم
            bottomRight: Radius.circular(isUser ? 20 : 0), // زاوية حادة لجهة المساعد
          ),
          boxShadow: [
            if (!isUser)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: isUser ? Colors.white : Colors.black87,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  // 3. حقل إدخال النص السفلي
  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // زر إضافة مرفقات أو صورة (للمستقبل)
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_rounded, color: Colors.grey),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F4),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'اسأل عن تفسير، فتوى، نصيحة...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSubmitted: (_) => _sendMessage(), // إرسال عند الضغط على Enter في الكيبورد
              ),
            ),
          ),
          const SizedBox(width: 8),
          // زر الإرسال الملون
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF0F766Eهذه هي اللحظة المنتظرة يا عزام! شاشة المساعد الذكي هي المكان الذي يتجلى فيه "عقل" التطبيق. 

لكي نجعل هذه الشاشة تنبض بالحياة، لن نستخدم مجرد صورة ثابتة للأفاتار، بل سنصنع **"أفاتاراً متوهجاً" (Glowing Avatar)** في أعلى الشاشة يعطي إيحاءً بأن الذكاء الاصطناعي "يستمع" و"يفكر" من خلال تأثير النبض (Pulse Animation). كما سنصمم فقاعات المحادثة (Chat Bubbles) ومربع الإدخال بأسلوب زجاجي عصري (Glassmorphism).

إليك الكود الاحترافي والمبتكر بالكامل لشاشة المساعد الذكي:

**المسار واسم الملف:** `lib/features/ai_assistant/ai_chat_screen.dart`

```dart
import 'package:flutter/material.dart';

// نموذج مبسط لرسائل المحادثة
class ChatMessage {
  final String text;
  final bool isMe;
  ChatMessage({required this.text, required this.isMe});
}

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // رسالة ترحيبية من المساعد الذكي عند فتح الشاشة
    _messages.add(
      ChatMessage(
        text: 'السلام عليكم يا عزام! أنا "سكينة"، مساعدك الذكي. كيف يمكنني إفادتك اليوم في وردك أو استفساراتك الدينية؟',
        isMe: false,
      ),
    );
  }

  // دالة إرسال الرسالة
  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessage(text: _textController.text, isMe: true));
      _isTyping = true;
      _textController.clear();
    });

    // محاكاة تأخير رد الذكاء الاصطناعي (سيتم ربطها بـ Gemini لاحقاً)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.insert(
            0,
            ChatMessage(
              text: 'هذا رد تجريبي من المساعد الذكي. قريباً سيتم ربطي بمحرك الذكاء الاصطناعي الفعلي لأجيب على كل أسئلتك بدقة!',
              isMe: false,
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0FDF4), Color(0xFFFFFFFF)], // تدرج أخضر فاتح جداً
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCustomHeader(),
              Expanded(child: _buildChatList()),
              if (_isTyping) _buildTypingIndicator(),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  // 1. الترويسة العلوية مع الأفاتار المتوهج
  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // الأفاتار النابض (Pulse Effect)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: 1.1),
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F766E).withOpacity(0.3 * (value - 1.0) * 10),
                      blurRadius: 15,
                      spreadRadius: 5 * value,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF0F766E),
                  child: Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                ),
              );
            },
            onEnd: () {
              // هذه الخدعة تجعل النبض مستمراً (يجب إدارتها بـ AnimationController في النسخة النهائية للمزيد من التحكم)
            },
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'المساعد "سكينة"',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('متصل ومستعد', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. قائمة المحادثة (الفقاعات)
  Widget _buildChatList() {
    return ListView.builder(
      reverse: true, // لجعل الرسائل الجديدة تظهر في الأسفل
      padding: const EdgeInsets.all(20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildChatBubble(message);
      },
    );
  }

  // تصميم فقاعة المحادثة
  Widget _buildChatBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, // أقصى عرض للفقاعة
        ),
        decoration: BoxDecoration(
          color: message.isMe ? const Color(0xFF0F766E) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isMe ? 0 : 20),
            bottomRight: Radius.circular(message.isMe ? 20 : 0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 15,
            color: message.isMe ? Colors.white : Colors.black87,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  // مؤشر الكتابة (عندما يفكر الذكاء الاصطناعي)
  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'سكينة تفكر...',
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  // 3. منطقة الإدخال السفلية (Glassmorphism Style)
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'اسألني عن تفسير آية، أو فضل دعاء...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0F766E),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
                             
