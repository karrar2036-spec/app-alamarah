import 'package:flutter/material.dart';

// =========================================================================
// 1. مكون رأس الصفحة والترحيب (HomeHeaderSection)
// =========================================================================
class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

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

        Card(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'تُبارك جامعة العمارة للطلبة الناجحين في مرحلة السادس الإعدادي، وأهلاً وسهلاً بكم في رحاب جامعتنا!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: const Color(0xFFD4AF37),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GuidePdfScreen()),
            );
          },
          icon: const Icon(Icons.menu_book),
          label: const Text('دليل الجامعة الشامل'),
        ),
      ],
    );
  }
}

// =========================================================================
// 2. شاشة دليل الجامعة الشامل (GuidePdfScreen)
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
                    'جامعة العمارة الأهلية',
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