import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _iconFlashController;
  late Animation<Color?> _iconColorAnimation;

  late AnimationController _scrollController;
  final ScrollController _horizontalScrollController = ScrollController();

  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();

    _flashController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: const Color(0xFF002147),
    ).animate(_flashController);

    _iconFlashController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _iconColorAnimation = ColorTween(
      begin: const Color(0xFFD4AF37),
      end: const Color(0xFF002366),
    ).animate(_iconFlashController);

    _scrollController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )
      ..addListener(() {
        if (!_isUserInteracting && _horizontalScrollController.hasClients) {
          final maxScroll =
              _horizontalScrollController.position.maxScrollExtent;
          if (maxScroll > 0) {
            final scrollOffset = _scrollController.value * maxScroll;
            _horizontalScrollController.jumpTo(scrollOffset);
          }
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _flashController.dispose();
    _iconFlashController.dispose();
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    const Color primaryBlue = Color(0xFF002147);
    const Color accentGold = Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFFF5F5F0),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: accentGold,
            height: 3.0,
            width: 180,
          ),
        ),
        title: Text(
          'الأخبار العامة والإنجازات',
          style: TextStyle(
            color: isDarkMode ? Colors.white : primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? accentGold.withOpacity(0.1)
                  : accentGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: accentGold, width: 1),
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _colorAnimation.value,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'هام',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRect(
                    child: SizedBox(
                      height: 24,
                      child: Listener(
                        onPointerDown: (_) {
                          setState(() {
                            _isUserInteracting = true;
                          });
                        },
                        onPointerUp: (_) {
                          setState(() {
                            _isUserInteracting = false;
                          });
                        },
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: ListView(
                            controller: _horizontalScrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '                    أجرى الأستاذ الدكتور عادل مانع الكعبي رئيس اللجنة الوزارية المشرفة على الامتحانات التقويمية في محافظة ميسان، زيارة تفقدية إلى جامعة العمارة الأهلية، صباح اليوم الاحد الموافق 10/5/2026            ',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white70
                                          : primaryBlue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 400),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          NewsItem(
            title: 'تصنيف UI Green Metric 2024',
            body:
                'صُنفت جامعة العمارة ضمن تصنيف (UI Green Metric) لعام 2024, حيث شاركت 81 جامعة عراقية في هذا التصنيف من أصل 1,477 جامعة حول العالم.',
            icon: Icons.eco,
            iconAnimation: _iconColorAnimation,
          ),
          NewsItem(
            title: 'تصنيف Green Metric العالمي',
            body:
                'حصلت جامعة العمارة على المرتبة (19) بين الجامعات الأهلية والمرتبة (42) بين الجامعات العراقية بتصنيف Green Metric.',
            icon: Icons.emoji_events,
            iconAnimation: _iconColorAnimation,
          ),
          NewsItem(
            title: 'تصنيف RUR العالمي',
            body:
                'احتلت جامعة العمارة المرتبة 39 على مستوى الجامعات العراقية في تصنيف RUR لعام 2021.',
            icon: Icons.workspace_premium,
            iconAnimation: _iconColorAnimation,
          ),
          NewsItem(
            title: 'تصنيف Webometrics',
            body:
                'جامعة العمارة تحقق مرتبة 110 في التصنيف العالمي (Webometrics) بين الجامعات الحكومية والأهلية العراقية.',
            icon: Icons.language,
            iconAnimation: _iconColorAnimation,
          ),
          NewsItem(
            title: 'شهادة ISO 45001 للسلامة والصحة',
            body:
                'حصلت الجامعة على شهادة الجودة والسلامة المهنية من وزارة التعليم العالي والبحث العلمي.',
            icon: Icons.verified,
            iconAnimation: _iconColorAnimation,
          ),
          NewsItem(
            title: 'شهادة ISO 50001 لنظام الطاقة',
            body:
                'حصلت جامعة العمارة على شهادة ISO 50001 لنظام إدارة الطاقة, بعد توفر الشروط المطلوبة للحصول على هذه الشهادة.',
            icon: Icons.solar_power,
            iconAnimation: _iconColorAnimation,
          ),
        ],
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final Animation<Color?> iconAnimation;

  const NewsItem({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
    required this.iconAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryBlue = Color(0xFF002147);

    return Card(
      elevation: isDarkMode ? 1 : 2,
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? Colors.white12 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: iconAnimation,
                  builder: (context, child) {
                    return Icon(
                      icon,
                      color: iconAnimation.value,
                      size: 24,
                    );
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 20,
              color: isDarkMode ? Colors.white24 : Colors.grey[300],
            ),
            Text(
              body,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}