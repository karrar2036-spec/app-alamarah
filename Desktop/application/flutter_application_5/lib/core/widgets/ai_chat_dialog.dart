import 'package:flutter/material.dart';

class AiChatDialog extends StatefulWidget {
  const AiChatDialog({super.key});

  @override
  State<AiChatDialog> createState() => _AiChatDialogState();
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class _AiChatDialogState extends State<AiChatDialog> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _controller.clear();
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 500), () {
      String botReply = _getBotResponse(text);
      setState(() {
        _messages.add(Message(text: botReply, isUser: false));
      });
      _scrollToBottom();
    });
  }

  String _getBotResponse(String userMessage) {
    String query = userMessage.trim().toLowerCase();

    if (query.contains('منو انت') ||
        query.contains('من أنت') ||
        query.contains('شنو انت') ||
        query.contains('تعريف عن نفسك')) {
      return 'انا مجرد مساعد تم برمجتي بواسطة احد المبرمجين.';
    } else if (query.contains('من المبرمج') ||
        query.contains('من هو المبرمج') ||
        query.contains('مبرمجك') ||
        query.contains('المبرمج')) {
      return 'المبرمج كرار ناصر سعد احد موظفي جامعة العمارة الاهلية.';
    } else if (query.contains('سلام') ||
        query.contains('مرحبا') ||
        query.contains('مراحب') ||
        query.contains('هلا') ||
        query.contains('اهلآ')) {
      return 'وعليكم السلام ورحمة الله وبركاته، أهلاً بك في جامعة العمارة الاهلية. كيف يمكنني مساعدتك اليوم؟';
    } else if (query.contains('شلونك') ||
        query.contains('كيف حالك') ||
        query.contains('الحال')) {
      return 'الحمد لله أنا بخير وبخدمتك دائماً! تفضل اطرح سؤالك.';
    } else if (query.contains('اقسام') ||
        query.contains('أقسام') ||
        query.contains('قسمكم') ||
        query.contains('كم قسم')) {
      return '''أقسام جامعة العمارة الاهلية:
1. طب الأسنان
2. الصيدلة
3. هندسة النفط
4. الهندسة الكيمياوية والصناعات النفطية
5. هندسة الذكاء الاصطناعي
6. الهندسة المدنية
7. هندسة تقنيات ميكانيك القوى
8. هندسة تقنيات الأمن السيبراني
9. هندسة تقنيات الوقود والطاقة
10. تقنيات الهندسة الكهربائية
11. هندسة تقنيات الأجهزة الطبية
12. المحاسبة
13. إدارة وتسويق النفط والغاز
14. القانون
15. تقنيات صناعة الأسنان
16. تقنيات التخدير
17. تقنيات الأشعة والسونار
18. التجميل والليزر
19. التربية الإنكليزية
20. التربية البدنية وعلوم الرياضة
21. علوم تحليلات مرضية
22. علوم فيزياء طبية''';
    } else if (query.contains('اسنان') ||
        query.contains('أسنان') ||
        query.contains('طب الأسنان')) {
      return 'قسم طب الأسنان (صباحي فقط): معدل القبول 89.5 - فرع علمي (أحيائي).';
    } else if (query.contains('صيدلة')) {
      return 'قسم الصيدلة (صباحي فقط): معدل القبول 89.5 - فرع علمي (أحيائي).';
    } else if (query.contains('نفط')) {
      return 'قسم هندسة النفط: صباحي (معدل 70.5) / مسائي (معدل 59.5) - فرع علمي (تطبيقي).';
    } else if (query.contains('كيمياوية') || query.contains('صناعات نفطية')) {
      return 'قسم الهندسة الكيمياوية والصناعات النفطية: صباحي (معدل 70.5) / مسائي (معدل 59.5) - فرع (أحيائي - تطبيقي - علمي).';
    } else if (query.contains('ذكاء') || query.contains('اصطناعي')) {
      return 'قسم هندسة الذكاء الاصطناعي: صباحي (معدل 60.5) / مسائي (معدل 59.5) - فرع (علمي - أحيائي - تطبيقي).';
    } else if (query.contains('مدنية')) {
      return 'قسم الهندسة المدنية: صباحي (معدل 62.5) / مسائي (معدل 59.5) - فرع (علمي - تطبيقي).';
    } else if (query.contains('ميكانيك') || query.contains('قوى')) {
      return 'قسم هندسة تقنيات ميكانيك القوى: صباحي (59.5) / مسائي (57.5) للأحيائي والتطبيقي والعلمي، ولخريجي الصناعة صباحي (61.5) ومسائي (59.5).';
    } else if (query.contains('سيبراني') || query.contains('امن سيبراني')) {
      return 'قسم هندسة تقنيات الأمن السيبراني: صباحي (59.5) / مسائي (57.5) للعلمي والأحيائي والتطبيقي، ولخريجي الصناعة والحاسوب صباحي (61.5) ومسائي (59.5).';
    } else if (query.contains('وقود') || query.contains('طاقة')) {
      return 'قسم هندسة تقنيات الوقود والطاقة: صباحي (59.5 و 61.5) / مسائي (57.5 و 59.5) حسب الفروع (علمي وصناعة).';
    } else if (query.contains('كهربائية')) {
      return 'قسم تقنيات الهندسة الكهربائية: صباحي (59.5 و 61.5) / مسائي (57.5 و 59.5) حسب الفروع (علمي وصناعة وحاسوب).';
    } else if (query.contains('أجهزة طبية') || query.contains('اجهزة طبية')) {
      return 'قسم هندسة تقنيات الأجهزة الطبية: صباحي (59.5 و 61.5) / مسائي (57.5 و 59.5) حسب الفروع (علمي وصناعة).';
    } else if (query.contains('محاسبة')) {
      return 'قسم المحاسبة: صباحي (معدل 50) / مسائي (معدل 50) - فروع (علمي، أحيائي، تطبيقي، أدبي، التجارة، مفوضي الشرطة).';
    } else if (query.contains('تسويق') || query.contains('إدارة وتسويق')) {
      return 'قسم إدارة وتسويق النفط والغاز: صباحي (معدل 50) / مسائي (معدل 50) - فروع (أدبي، علمي، أحيائي، تطبيقي، التجارة، مفوضي الشرطة).';
    } else if (query.contains('قانون')) {
      return 'قسم القانون: صباحي (معدل 64.5) / مسائي (معدل 60.5) - فروع (علمي، أحيائي، تطبيقي، أدبي، مفوضي الشرطة).';
    } else if (query.contains('صناعة الأسنان')) {
      return 'قسم تقنيات صناعة الأسنان: صباحي (معدل 69.5) / مسائي (معدل 64.5) - فرع علمي (أحيائي).';
    } else if (query.contains('تخدير')) {
      return 'قسم تقنيات التخدير: صباحي (معدل 69.5) / مسائي (معدل 64.5) - فرع علمي (أحيائي).';
    } else if (query.contains('سونار') || query.contains('أشعة')) {
      return 'قسم تقنيات الأشعة والسونار: صباحي (معدل 69.5) / مسائي (معدل 64.5) - فرع علمي (أحيائي).';
    } else if (query.contains('تجميل') || query.contains('ليزر')) {
      return 'قسم التجميل والليزر: صباحي (معدل 69.5) / مسائي (معدل 64.5) - فرع علمي (أحيائي).';
    } else if (query.contains('تربية انقليزية') ||
        query.contains('إنكليزية') ||
        query.contains('انجليزي')) {
      return 'قسم التربية الإنكليزية: صباحي (معدل 50) / مسائي (معدل 50) - فروع (علمي، أحيائي، تطبيقي، أدبي، مفوضي الشرطة، معهد إعداد المعلمين).';
    } else if (query.contains('رياضة') || query.contains('تربية بدنية')) {
      return 'قسم التربية البدنية وعلوم الرياضة: صباحي (معدل 50) / مسائي (معدل 50) - فروع (علمي، أدبي، صناعة، تجارة، زراعة، فنون تطبيقية وغيرها).';
    } else if (query.contains('تحليلات') || query.contains('تحليلات مرضية')) {
      return 'قسم علوم تحليلات مرضية: صباحي (معدل 56.5) / مسائي (معدل 54.5) - فرع علمي (أحيائي).';
    } else if (query.contains('فيزياء طبية')) {
      return 'قسم علوم فيزياء طبية: صباحي (معدل 56.5) / مسائي (معدل 54.5) - فرع (علمي، أحيائي، تطبيقي).';
    } else if (query.contains('تخفيض') || query.contains('عدكم تخفيض')) {
      return 'نعم موجود تخفيض لقناة الرعاية، وقناة الشهداء، وقناة ذوي الاعاقة، وقناة السجناء السياسيين، وقناة الابطال.';
    } else if (query.contains('نسبه') ||
        query.contains('نسبة') ||
        query.contains('شكد نسبة') ||
        query.contains('كم نسبة')) {
      return 'نسبة التخفيض للقنوات المشمولة هي 50 بالمية.';
    } else if (query.contains('اخ') ||
        query.contains('أخ') ||
        query.contains('بنفس الجامعة') ||
        query.contains('اخوة')) {
      return 'نعم، إذا كان لديك أخ بنفس الجامعة يصيرلك تخفيض 10 بالمية.';
    } else if (query.contains('تاييد') ||
        query.contains('تأييد') ||
        query.contains('تاييدات') ||
        query.contains('تخرج')) {
      return 'بخصوص تأييدات التخرج، يرجى مراجعة الجامعة مباشرة.';
    } else if (query.contains('وثائق') ||
        query.contains('الوثائق') ||
        query.contains('وثيقة')) {
      return 'بخصوص الوثائق الدراسية، يرجى مراجعة الجامعة مباشرة.';
    } else if (query.contains('اقساط') ||
        query.contains('أقساط') ||
        query.contains('اجور') ||
        query.contains('أجور')) {
      return 'الأجور الدراسية تتناسب مع الأقسام المختلفة وتتوفر تسهيلات في الدفع. يمكنك مراجعة قسم التسجيل لمعرفة التفاصيل المالية بدقة.';
    } else if (query.contains('عنوان') ||
        query.contains('موقع') ||
        query.contains('وين مكان')) {
      return 'تقع جامعة العمارة الاهلية في محافظة ميسان - مركز العمارة.';
    }

    return 'انا اسف جدا لازلت في مرحلة التطوير لكن اوعدك ساجيب عن كل اسئلتك في الايام المقبلة.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعد الذكي - جامعة العمارة الاهلية'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: const Color(0xFFD4AF37),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? const Color(0xFFD4AF37).withOpacity(0.2)
                          : const Color(0xFF002366).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser
                            ? Colors.black87
                            : const Color(0xFF002366),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF002366), width: 2),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF002366)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
