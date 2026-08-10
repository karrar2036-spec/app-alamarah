import 'package:flutter/material.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnimation;

  final List<Map<String, dynamic>> departments = const [
    {
      "name": "طب الأسنان",
      "icon": Icons.medical_services,
      "vision":
          "الريادة والتميز في توفير خدمات تعليمية وعلاجية متقدمة في مجال طب وجراحة الفم والأسنان.",
      "message":
          "إعداد ملاكات طبية كفؤة مزودة بأحدث المعارف العلمية والمهارات السريرية لخدمة المجتمع.",
      "goals":
          "1. تقديم رعاية صحية عالية الجودة.\n2. مواكبة التطورات الحديثة في تقنيات طب الأسنان.\n3. تشجيع البحث العلمي والقيام بحملات التوعية المجتمعية."
    },
    {
      "name": "الصيدلة",
      "icon": Icons.local_pharmacy,
      "vision":
          "التميز في التعليم الصيدلاني والبحث العلمي والخدمات الدوائية على مستوى العراق.",
      "message":
          "تخريج صيادلة يمتلكون المعرفة العلمية والمهارات المهنية للتعامل الفعال مع الأدوية والرعاية الصحية.",
      "goals":
          "1. فهم خصائص المركبات الدوائية وتصنيعها.\n2. تعزيز الدور السريري للصيدلاني في الفريق الصحي.\n3. دعم الأبحاث الدوائية المبتكرة."
    },
    {
      "name": "هندسة النفط",
      "icon": Icons.business,
      "vision":
          "أن يكون القسم مرجعاً اكاديمياً وبحثياً رائداً في قطاع استخراج وتطوير الثرو النفطية.",
      "message":
          "إعداد مهندسي نفط أُكفاء قادرين على إدارة وتطوير العمليات النفطية وفق أحدث المعايير الهندسية والبيئية.",
      "goals":
          "1. استكشاف واستخراج النفط والغاز بأفضل الطرق الاقتصادية والآمنة.\n2. تقليل الأثر البيئي للصناعات النفطية.\n3. تعزيز التعاون مع الشركات القطاعية النفطية."
    },
    {
      "name": "الهندسة الكيمياوية والصناعات النفطية",
      "icon": Icons.science,
      "vision":
          "التميز في هندسة العمليات الكيمياوية والصناعات البتروكيمياوية لدعم التنمية المستدامة.",
      "message":
          "تأهيل مهندسين قادرة على تصميم وتشغيل وإدارة المصانع والوحدات الإنتاجية الكيمياوية والنفطية بكفاءة.",
      "goals":
          "1. تحسين كفاءة العمليات الصناعية وتكرير النفط.\n2. تطوير مواد وتقنيات صديقة للبيئة.\n3. تلبية احتياجات سوق العمل الهندسية والصناعية."
    },
    {
      "name": "هندسة الذكاء الاصطناعي",
      "icon": Icons.psychology,
      "vision":
          "بناء قاعدة رصينة في علوم الذكاء الاصطناعي وتطبيقاته الذكية محلياً وعالمياً.",
      "message":
          "رفد سوق العمل بمهندسين متخصصين في خوارزميات التعلم الآلي وتحليل البيانات الذكية لتطوير حلول المستقبل.",
      "goals":
          "1. تصميم نظم ذكية تحاكي التفكير البشري لحل المشكلات المعقدة.\n2. إجراء بحوث متقدمة في مجال الروبوتات ومعالجة البيانات.\n3. نشر ثقافة الابتكار الرقمي."
    },
    {
      "name": "الهندسة المدنية",
      "icon": Icons.engineering,
      "vision":
          "الريادة في التعليم الهندسي المدني وتصميم البنى التحتية المستدامة.",
      "message":
          "إعداد مهندسين مدنيين يمتلكون القدرة على التخطيط، التصميم، والإشراف على المشاريع الإنشائية بمعايير جودة عالية.",
      "goals":
          "1. تصميم المنشآت الحضرية والطرق والجسور بأمان واستدامة.\n2. استخدام أحدث البرمجيات الهندسية في التحليل والتنفيذ.\n3. الالتزام بأخلاقيات المهنة ومعايير السلامة العامة."
    },
    {
      "name": "هندسة تقنيات ميكانيك القوى",
      "icon": Icons.settings,
      "vision": "التميز في تخصص منظومات الطاقة وميكانيك القوى التطبيقية.",
      "message":
          "تخريج تقنيين ومهندسين قادرين على تشغيل وصيانة منظومات توليد الطاقة ومحطات القوى الميكانيكية.",
      "goals":
          "1. دراسة وتحسين كفاءة المحركات والتربينات ومنظومات التبريد والتكييف.\n2. تطبيق الحلول الهندسية لتوفير الطاقة.\n3. تلبية احتياجات قطاع الطاقة الوطني من الكفاءات."
    },
    {
      "name": "هندسة تقنيات الأمن السيبراني",
      "icon": Icons.security,
      "vision":
          "الوصول إلى بيئة رقمية آمنة ومحمية من التهديدات السيبرانية المتزايدة.",
      "message":
          "إعداد كوادر تقنية متخصصة لحماية شبكات المعلومات والأنظمة الرقمية لمؤسسات الدولة والقطاع الخاص.",
      "goals":
          "1. تأمين البيانات ضد الاختراقات والهجمات السيبرانية.\n2. تطوير أدوات وبرمجيات للكشف المبكر عن الثغرات الأمنية.\n3. نشر الوعي بأمن المعلومات الرقمية."
    },
    {
      "name": "هندسة تقنيات الوقود والطاقة",
      "icon": Icons.flash_on,
      "vision":
          "الريادة في استثمار مصادر الطاقة التقليدية والمتجددة وتطوير أنواع الوقود الحديثة.",
      "message":
          "تأهيل كوادر هندسية تقنية قادرة على التعامل مع تقنيات إنتاج واستدامة الطاقة والوقود.",
      "goals":
          "1. دراسة مصادر الطاقة البديلة والنظيفة.\n2. تحسين كفاءة استهلاك الوقود وتقليل الانبعاثات الضارة.\n3. دعم التحول نحو طاقة مستدامة آمنة."
    },
    {
      "name": "تقنيات الهندسة الكهربائية",
      "icon": Icons.electrical_services,
      "vision": "التميز في مجالات تقنيات القدرة والمنظومات الكهربائية الحديثة.",
      "message":
          "تخريج تقنيين بمهارات عالية في تصميم وفحص وتشغيل شبكات ومنظومات الطاقة الكهربائية.",
      "goals":
          "1. إدارة وتوزيع الأحمال الكهربائية بكفاءة عالية.\n2. صيانة وتشغيل محطات التحويل والتوليد.\n3. مواكبة التطورات التقنية في المعدات الكهربائية."
    },
    {
      "name": "هندسة تقنيات الأجهزة الطبية",
      "icon": Icons.monitor_heart,
      "vision":
          "أن يكون القسم دعامة أساسية لتطوير القطاع الصحي عبر هندسة وتقنيات الأجهزة الطبية.",
      "message":
          "إعداد مهندسين تقنيين قادرين على التعامل مع التقنيات الطبية الحديثة وصيانتها وتشخيص أعطالها.",
      "goals":
          "1. سد حاجة المستشفيات والمراكز الصحية لكوادر صيانة الأجهزة الطبية.\n2. فهم المبادئ الفيزيائية والبيولوجية للاجهزة العلاجية والتشخيصية.\n3. تعزيز جودة الخدمات الطبية بالتقنيات المتقدمة."
    },
    {
      "name": "المحاسبة",
      "icon": Icons.calculate,
      "vision": "الريادة الأكاديمية والمهنية في علوم المحاسبة والتدقيق المالي.",
      "message":
          "إعداد محاسبين مؤهلين علمياً وعملياً للعمل في القطاعين المالي والمصرفي وفق المعايير المحاسبية الحديثة.",
      "goals":
          "1. إتقان مهارات التسجيل والتحليل المالي والتدقيق.\n2. مواكبة النظم المحاسبية الإلكترونية الحديثة.\n3. تلبية متطلبات سوق العمل من الكفاءات المالية النزيهة."
    },
    {
      "name": "إدارة وتسويق النفط والغاز",
      "icon": Icons.trending_up,
      "vision":
          "التميز في إدارة سلاسل الإمداد والتسويق في قطاع الطاقة والنفط والغاز.",
      "message":
          "تخريج كوادر إدارية وتسويقية متخصصة تفهم اقتصاديات النفط والغاز وآليات السوق العالمي.",
      "goals":
          "1. دراسة آليات التسويق العالمي للنفط والمنتجات البتروكيمياوية.\n2. تطبيق استراتيجيات الإدارة الحديثة في المؤسسات النفطية.\n3. تحليل الجدوى الاقتصادية للمشاريع الطاقوية."
    },
    {
      "name": "القانون",
      "icon": Icons.gavel,
      "vision":
          "التميز في نشر الثقافة القانونية وإعداد جيل واعٍ بأحكام التشريعات والنظم القانونية.",
      "message":
          "تخريج قانونيين يمتلكون القدرة على تطبيق القانون والدفاع عن الحقوق وإرساء دعائم العدالة في المجتمع.",
      "goals":
          "1. الفهم العميق لمختلف فروع القانون العراقي والمقارن.\n2. تعزيز مهارات الصياغة القانونية والمرافعات.\n3. ترسيخ مبادئ سيادة القانون وحقوق الإنسان."
    },
    {
      "name": "تقنيات صناعة الأسنان",
      "icon": Icons.medical_information,
      "vision":
          "التميز في تقديم برامج تعليمية تقنية متطورة لإنتاج التعويضات السرية والاصطناعية بدقة عالية.",
      "message":
          "إعداد تقنيين مهرة قادرين على تصميم وصناعة مختلف أنواع التعويضات والجسور والأطقم السنية.",
      "goals":
          "1. استخدام التقنيات الرقمية والمواد الحديثة في صناعة الأسنان.\n2. التعاون الفعال مع عيادات وأطباء الأسنان.\n3. رفع المهارة اليدوية والتقنية للطلبة."
    },
    {
      "name": "تقنيات التخدير",
      "icon": Icons.healing,
      "vision":
          "الريادة في إعداد كوادر تخدير تقنية ذات كفاءة عالية تسهم في الارتقاء بالخدمات الطبية الجراحية.",
      "message":
          "تأهيل تقنيي تخدير مسلحين بالمعرفة العلمية والتدريب العملي لمساعدة أطباء التخدير وغرف العمليات.",
      "goals":
          "1. مراقبة المريض بدقة قبل وأثناء وبعد التخدير.\n2. التعامل الاحترافي مع أجهزة الإنعاش ومعدات التنفس الاصطناعي.\n3. الالتزام التام بمعايير السلامة والتعقيم."
    },
    {
      "name": "تقنيات الأشعة والسونار",
      "icon": Icons.biotech,
      "vision":
          "التميز في تقديم تعليم تقني متتقدم في مجالات التشخيص الطبي التصويري.",
      "message":
          "إعداد ملاكات تقنية مدربة على تشغيل الأجهزة الإشعاعية وأجهزة السونار بأعلى درجات الدقة والأمان.",
      "goals":
          "1. الحصول على صور تشخيصية واضحة ودقيقة لمساعدة الطبيب المعالج.\n2. تطبيق معايير الوقاية من الإشعاع لحماية المرضى والعاملين.\n3. مواكبة التقنيات الحديثة في التصوير الطبي."
    },
    {
      "name": "التجميل والليزر",
      "icon": Icons.face,
      "vision":
          "الريادة في علوم وتقنيات التجميل والعناية بالبشرة واستخدامات الليزر الطبي.",
      "message":
          "تخريج متخصصين مؤهلين علمياً وعملياً للعمل في مراكز التجميل الطبية والعلاجية الحديثة.",
      "goals":
          "1. إتقان استخدام تقنيات الليزر الحديثة لأغراض التجميل والعلاج.\n2. الالتزام بالمعايير الصحية والوقائية في العناية بالبشرة والجسم.\n3. مواكبة الابتكارات العالمية في مجال التجميل الطبي."
    },
    {
      "name": "التربية الإنجليزية",
      "icon": Icons.language,
      "vision":
          "التميز في إعداد تدريسيين وباحثين كفؤة في اللغة الإنجليزية وآدابها وطرق تدريسها.",
      "message":
          "رفد المؤسسات التعليمية بكوادر تدريسية تمتلك مهارات التواصل اللغوي والتربوي الفعال باللغة الإنجليزية.",
      "goals":
          "1. تطوير مهارات الاستماع والكلام والقراءة والكتابة لدى الطلبة.\n2. الإحاطة بأحدث طرائق التدريس والتقويم اللغوي.\n3. تشجيع الدراسات اللغوية والأدبية المقارنة."
    },
    {
      "name": "التربية البدنية وعلوم الرياضة",
      "icon": Icons.sports,
      "vision":
          "الريادة في نشر الثقافة الصحية والرياضية وإعداد قيادات كفؤة في علوم الرياضة.",
      "message":
          "إعداد معلمين ومدربين وباحثين في مجالات التربية البدنية وعلوم الحركة والتدريب الرياضي.",
      "goals":
          "1. تنمية اللياقة البدنية والمهارات الحركية بمختلف الألعاب الرياضية.\n2. تطبيق الأسس العلمية في التدريب الرياضي والصحي.\n3. تعزيز الروح الرياضية والعمل الجماعي."
    },
    {
      "name": "علوم تحليلات مرضية",
      "icon": Icons.biotech,
      "vision": "التميز في مجال التشخيص المخبري والبحوث الطبية التطبيقية.",
      "message":
          "تخريج باحثين ومحللين مختبريين ذوي كفاءة عالية في إجراء الفحوصات الطبية الدقيقة.",
      "goals":
          "1. دقة وسرعة في إنجاز الفحوصات المختبرية السريرية.\n2. التعامل الآمن مع العينات البيولوجية والأجهزة المخبرية المتقدمة.\n3. دعم البحث العلمي في تشخيص الأمراض والأوبئة."
    },
    {
      "name": "علوم فيزياء طبية",
      "icon": Icons.waves,
      "vision":
          "الريادة في تطبيق مبادئ الفيزياء لخدمة الطب الحديث والتشخيص والعلاج الإشعاعي.",
      "message":
          "إعداد متخصصين في الفيزياء الطبية لضمان كفاءة وأمان الأجهزة الطبية الإشعاعية والتشخيصية.",
      "goals":
          "1. حساب جرعات الإشعاع العلاجي بدقة للمرضى.\n2. إجراء الفحوصات الوقائية لضمان خلو الأجهزة من التسريب الإشعاعي.\n3. التعاون مع الطواقم الطبية في تطوير بروتوكولات العلاج."
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xFFD4AF37),
      end: const Color(0xFF002366),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDepartmentDetails(BuildContext context, Map<String, dynamic> dept) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => Icon(
                  Icons.school_rounded,
                  color: _colorAnimation.value,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  dept['name'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : const Color(0xFF002366),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSectionTitle('الرؤية :'),
                  const SizedBox(height: 4),
                  Text(
                    dept['vision'],
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSectionTitle('الرسالة :'),
                  const SizedBox(height: 4),
                  Text(
                    dept['message'],
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSectionTitle('الأهداف :'),
                  const SizedBox(height: 4),
                  Text(
                    dept['goals'],
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق',
                  style: TextStyle(
                      color: Color(0xFF002366), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF002366),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : const Color(0xFF002366),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF002366).withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) => Icon(
                      Icons.school_rounded,
                      size: 24,
                      color: _colorAnimation.value,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'الأقسام الأكاديمية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002366),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.6,
              ),
              itemCount: departments.length,
              itemBuilder: (context, index) {
                final dept = departments[index];
                return InkWell(
                  onTap: () {
                    _showDepartmentDetails(context, dept);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.4),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF002366).withOpacity(0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _colorAnimation,
                            builder: (context, child) => Icon(
                              dept['icon'] as IconData,
                              size: 22,
                              color: _colorAnimation.value,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dept['name'] as String,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white70
                                  : const Color(0xFF002366),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
