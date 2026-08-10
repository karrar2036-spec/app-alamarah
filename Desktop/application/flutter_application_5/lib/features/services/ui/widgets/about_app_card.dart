import 'package:flutter/material.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _iconColorAnimation;

  final Color goldColor = const Color(0xFFD4AF37);
  final Color royalBlueColor = const Color(0xFF002366);

  @override
  void initState() {
    super.initState();

    // أنيميشن الوميض التفاعلي بين الذهبي والأزرق الداكن
    _colorController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _iconColorAnimation = ColorTween(
      begin: goldColor,
      end: royalBlueColor,
    ).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color primaryColor =
        isDark ? const Color(0xFF60A5FA) : const Color(0xFF002366);
    final Color textColor = Theme.of(context).textTheme.bodyLarge?.color ??
        (isDark ? Colors.white : Colors.black87);
    final Color cardBg = Theme.of(context).cardColor;
    final Color borderColor = isDark ? Colors.white24 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'دليل خدمات التطبيق',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                      : [const Color(0xFF002366), const Color(0xFF00153D)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.menu_book_rounded, size: 48, color: goldColor),
                  const SizedBox(height: 12),
                  const Text(
                    'دليل استخدام خدمات التطبيق',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'شرح مفصل لكافة الأيقونات والخدمات التفاعلية المتاحة في تطبيق جامعة العمارة الأهلية لتسهيل الوصول إليها والاستفادة منها.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader(
                '🏛️ الخدمات الطلابية والأكاديمية', primaryColor),
            const SizedBox(height: 12),

            _buildServiceItem(
              context,
              icon: Icons.rate_review,
              iconColor: Colors.amber,
              title: 'تقييم الأساتذة',
              description:
                  'تتيح للطلبة تقييم التدريسيين باختيار القسم ثم أستاذ المادة وتحديد عدد النجوم (كل نجمة تعادل درجتين) مع إمكانية إرفاق ملاحظات.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.workspace_premium,
              iconColor: Colors.orange,
              title: 'الطلبة الأوائل',
              description:
                  'تتيح استعراض أسماء الطلبة الثلاثة الأوائل بعد تحديد القسم والمرحلة الدراسية.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.calendar_month,
              iconColor: Colors.blue,
              title: 'الجداول الأسبوعية',
              description:
                  'عرض الجدول الدراسي الأسبوعي عبر اختيار القسم، المرحلة، نوع الدراسة (صباحي/مسائي)، والشعبة.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.assignment_outlined,
              iconColor: Colors.teal,
              title: 'الجداول الامتحانية',
              description:
                  'متابعة أوقات ومواعيد الامتحانات حسب القسم والمرحلة ونوع الدراسة والشعبة.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.report_problem_outlined,
              iconColor: Colors.redAccent,
              title: 'الشكاوى الطلابية',
              description:
                  'نافذة مخصصة لكتابة الشكاوى والمقترحات بسرية تامة دون المطالبة بأي بيانات شخصية مثل الرقم أو الإيميل.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.quiz_outlined,
              iconColor: Colors.purple,
              title: 'اختبارات امتحانية',
              description:
                  'اختبارات تجريبية تفاعلية وأسئلة وإجابات لكافة المواد الدراسية الخاصة بقسم الطالب.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.school,
              iconColor: Colors.indigo,
              title: 'مواعيد حفلات التخرج',
              description:
                  'استعراض مواعيد وجداول حفلات التخرج عند اختيار القسم والدفعة الخاصة بالطالب.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.menu_book,
              iconColor: Colors.brown,
              title: 'المواد الدراسية',
              description:
                  'الاطلاع على قائمة المواد والمناهج المعتمدة عند اختيار القسم والمرحلة الدراسية.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.notifications_active_outlined,
              iconColor: Colors.deepOrange,
              title: 'التنبيهات',
              description:
                  'إشعارات وتنبيهات مباشرة تنبه الطالب حول الملاحظات والتعليمات المهمة الصادرة من الجامعة.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.note_alt_outlined,
              iconColor: Colors.green,
              title: 'ملاحظات',
              description:
                  'ملاحظات ونقاط أساسية توجيهية لابد للطالب من الاطلاع عليها ومراعاتها.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('🌐 التواصل والمعلومات العامة', primaryColor),
            const SizedBox(height: 12),

            _buildServiceItem(
              context,
              icon: Icons.school_outlined,
              iconColor: primaryColor,
              title: 'حول الجامعة',
              description:
                  'شرح وإحاطة شاملة حول تأسيس جامعة العمارة الأهلية ورؤيتها وأهدافها التعليمية.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.location_on_outlined,
              iconColor: Colors.red,
              title: 'موقع الجامعة',
              description:
                  'زر تفاعلي ينقلك مباشرة إلى خرائط Google رؤية الموقع الميداني الحقيقي للجامعة.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.apps,
              iconColor: Colors.lightBlue,
              title: 'التطبيقات الوزارية',
              description:
                  'دليل مباشر يضم روابط كافة التطبيقات والمنصات الرسمية الخاصة بوزارة التعليم العالي.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.phone_in_talk_outlined,
              iconColor: Colors.green.shade700,
              title: 'تواصل مع الجامعة',
              description:
                  'وسائل التواصل المباشرة المتاحة عبر الأرقام الرسمية والبريد الإلكتروني للجامعة.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.rate_review_outlined,
              iconColor: Colors.deepPurple,
              title: 'ملاحظات حول التطبيق',
              description:
                  'صندوق لاستقبال الملاحظات واقتراحات إضافة ميزات جديدة للتطبيق ليتم مراجعتها وتدقيقها.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.headset_mic_outlined,
              iconColor: Colors.cyan.shade700,
              title: 'الدعم الفني',
              description:
                  'التواصل المباشر مع مدير التطبيق للحصول على المساعدة التقنية في حال مواجهة أي خلل.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),

            const SizedBox(height: 24),
            _buildSectionHeader(
                '⭐ المميزات العلوية والشريط العام', primaryColor),
            const SizedBox(height: 12),

            _buildServiceItem(
              context,
              icon: Icons.account_balance,
              iconColor: Colors.red.shade700,
              title: 'تمثال ميسان (الصورة الحمراء العلوية)',
              description:
                  'عند الضغط على الصورة الحمراء في أعلى الشاشة الرئيسية، تظهر نافذة تشرح تاريخ وحضارة محافظة ميسان.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.smart_toy_outlined,
              iconColor: Colors.blue.shade700,
              title: 'المساعد الذكي (أيقونة الروبوت)',
              description:
                  'أيقونة الروبوت المجاوة لفتح نافذة المحادثة التفاعلية مع الذكاء الاصطناعي للإجابة عن التساؤلات.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.alt_route,
              iconColor: goldColor,
              title: 'قنوات التقديم (للطلبة الجدد)',
              description:
                  'تضم القناة العامة، قناة ذوي الشهداء، الإعاقة، السجناء، والأبطال الرياضيين مع رابط التقديم.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildServiceItem(
              context,
              icon: Icons.widgets,
              iconColor: primaryColor,
              title: 'الأقسام الأكاديمية (22 قسم)',
              description:
                  'استعراض كافة أقسام الجامعة، وعند الضغط على أي قسم تظهر رؤية ورسالة وأهداف القسم.',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),

            const SizedBox(height: 30),

            // مربع الهوية البصرية للمبرمج بتصميم وتنسيق مخصص
            AnimatedBuilder(
              animation: _iconColorAnimation,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _iconColorAnimation.value ?? goldColor,
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_iconColorAnimation.value ?? goldColor)
                            .withOpacity(0.12),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.developer_mode_rounded,
                            size: 22,
                            color: _iconColorAnimation.value,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'تم برمجة التطبيق بواسطة المبرمج',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textColor.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: (_iconColorAnimation.value ?? goldColor)
                              .withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.code_rounded,
                              size: 18,
                              color: _iconColorAnimation.value,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'كرار ناصر سعد',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD4AF37),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'جميع الحقوق محفوظة © 2026',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: textColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.75),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
