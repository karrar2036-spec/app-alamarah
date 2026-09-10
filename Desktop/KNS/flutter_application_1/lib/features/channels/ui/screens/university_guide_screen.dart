import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// =========================================================================
// 1. مكون رأس الصفحة والترحيب (HomeHeaderSection)
// =========================================================================
class HomeHeaderSection extends StatefulWidget {
  const HomeHeaderSection({super.key});

  @override
  State<HomeHeaderSection> createState() => _HomeHeaderSectionState();
}

class _HomeHeaderSectionState extends State<HomeHeaderSection>
    with WidgetsBindingObserver {
  late Future<String> _newsFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _newsFuture = _fetchNews();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // هذه الدالة تتفعل تلقائياً عندما يرجع المستخدم للتطبيق من الخلفية أو نافذة أخرى
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshNews();
    }
  }

  // دالة لإعادة جلب البيانات وتحديث واجهة المستخدم فوراً
  void _refreshNews() {
    if (mounted) {
      setState(() {
        _newsFuture = _fetchNews();
      });
    }
  }

  Future<String> _fetchNews() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://app-alamarah.com/api/news1'),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data is Map) {
          return data['text'] ??
              data['title'] ??
              'أهلاً بكم في جامعة العمارة الاهلية';
        } else if (data is List && data.isNotEmpty) {
          return data[0]['text'] ??
              data[0]['title'] ??
              'أهلاً بكم في جامعة العمارة الاهلية';
        }
      }
    } catch (e) {
      // خطأ في الاتصال
    }
    return 'جاري التحميل.... تأكد من الاتصال بالإنترنت';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0A192F), Color(0xFF1E3A8A)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'photo/1.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFD4AF37),
                    child: Icon(
                      Icons.account_balance,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'جامعة العمارة الاهلية',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // استخدام FutureBuilder مع المستقبل المحدث لضمان جلب البيانات فور الرجوع
        FutureBuilder<String>(
          future: _newsFuture,
          builder: (context, snapshot) {
            String newsText = 'جاري تحميل الإعلانات...';
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              newsText = snapshot.data!;
            }
            return NewsTickerBar(text: newsText);
          },
        ),

        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: const Color(0xFFD4AF37),
          ),
          onPressed: () async {
            // عند الانتقال والرجوع من هذه الصفحة، نقوم بتحديث البيانات فوراً عند العودة
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GuidePdfScreen()),
            );
            _refreshNews(); // تحديث فوري فور الرجوع من صفحة الدليل
          },
          icon: const Icon(Icons.menu_book),
          label: const Text('دليل الجامعة الشامل'),
        ),
      ],
    );
  }
}

// =========================================================================
// 2. ويدجت الشريط الإخباري المتحرك (NewsTickerBar)
// =========================================================================
class NewsTickerBar extends StatefulWidget {
  final String text;

  const NewsTickerBar({super.key, required this.text});

  @override
  State<NewsTickerBar> createState() => _NewsTickerBarState();
}

class _NewsTickerBarState extends State<NewsTickerBar>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 23),
    )..addListener(() {
        if (_scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(_animController.value * maxScroll);
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repeatedText = '${widget.text}                    ${widget.text}';

    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF0A192F),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFD4AF37),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.campaign, color: Color(0xFF0A192F), size: 20),
                SizedBox(width: 4),
                Text(
                  'إعلان',
                  style: TextStyle(
                    color: Color(0xFF0A192F),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Text(
                    repeatedText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 3. شاشة دليل الجامعة الشامل (GuidePdfScreen)
// =========================================================================
class GuidePdfScreen extends StatelessWidget {
  const GuidePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('دليل جامعة العمارة الأهلية'),
        backgroundColor: const Color(0xFF0A192F),
        foregroundColor: const Color(0xFFD4AF37),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A192F), Color(0xFF1E3A8A)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'photo/1.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFD4AF37),
                        child: Icon(Icons.account_balance,
                            size: 40, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'جامعة العمارة الاهلية',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'دليل الجامعة التعريفي والأكاديمي - صرح علمي في محافظة ميسان',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'نبذة عن الجامعة',
              icon: Icons.info_outline,
              iconColor: Colors.blue,
              content:
                  'تأسست كلية العمارة الجامعة سنة 2017 استناداً لقرار مجلس الوزراء المرقم (358) لتكون صرحاً علمياً وحضارياً متميزاً يسهم في إعداد ملاكات متخصصة تأخذ دورها الفاعل في بناء نهضة العراق الحديثة.',
            ),
            _buildSectionCard(
              title: 'الرؤية والرسالة والأهداف',
              icon: Icons.visibility_outlined,
              iconColor: Colors.orange,
              content:
                  '• رؤية الجامعة: الريادة والتميز في التعليم الأكاديمي والبحث العلمي وخدمة المجتمع محلياً ودولياً والالتزام بمعايير الجودة الشاملة.\n\n• رسالة الجامعة: إعداد خريجين أكفياء مزودين بالمعرفة والمهارات العلمية والتقنية لتلبية احتياجات سوق العمل.',
            ),
            _buildExpansionCategory(
              title: 'الأقسام الطبية والصحية',
              icon: Icons.medical_services,
              color: Colors.redAccent,
              items: [
                'طب الأسنان',
                'الصيدلة',
                'تقنيات التخدير',
                'تقنيات صناعة الأسنان',
                'علوم فيزياء طبية',
                'تقنيات الأشعة والسونار',
                'علوم تحليلات مرضية',
                'التجميل والليزر',
              ],
            ),
            _buildExpansionCategory(
              title: 'الأقسام الهندسية والتقنية',
              icon: Icons.engineering,
              color: Colors.indigo,
              items: [
                'هندسة النفط',
                'الهندسة المدنية',
                'الهندسة الكيمياوية والصناعات النفطية',
                'هندسة الذكاء الاصطناعي',
                'هندسة تقنيات ميكانيك القوى',
                'هندسة تقنيات الأمن السيبراني',
                'هندسة تقنيات الوقود والطاقة',
                'تقنيات الهندسة الكهربائية',
                'هندسة تقنيات الأجهزة الطبية',
              ],
            ),
            _buildExpansionCategory(
              title: 'الأقسام الإدارية والإنسانية والتربوية',
              icon: Icons.school,
              color: Colors.green,
              items: [
                'المحاسبة',
                'القانون',
                'إدارة وتسويق النفط والغاز',
                'التربية الإنجليزية',
                'التربية البدنية وعلوم الرياضة',
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'محافظة ميسان - مدينة العمارة | www.alamarahuc.edu.iq',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title,
      required IconData icon,
      required Color iconColor,
      required String content}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A192F))),
            ],
          ),
          const Divider(height: 20),
          Text(content,
              style: const TextStyle(
                  fontSize: 14, color: Colors.black87, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildExpansionCategory(
      {required String title,
      required IconData icon,
      required Color color,
      required List<String> items}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A192F)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: items
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                size: 16, color: Color(0xFFD4AF37)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text(item,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87))),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
