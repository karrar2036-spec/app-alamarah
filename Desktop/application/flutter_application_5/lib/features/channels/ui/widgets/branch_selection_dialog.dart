import 'package:flutter/material.dart';
import 'package:flutter_application_5/features/channels/ui/screens/admission_grades_screen.dart';

class BranchSelectionDialog extends StatefulWidget {
  final String selectedChannelName;

  const BranchSelectionDialog({
    super.key,
    this.selectedChannelName = "قناة عامة",
  });

  @override
  State<BranchSelectionDialog> createState() => _BranchSelectionDialogState();
}

class _BranchSelectionDialogState extends State<BranchSelectionDialog> {
  String? _selectedMainBranch;
  String? _selectedSubCategory; // لتحديد التجارة أو الصناعة داخل المهني

  int _getChannelId(String channelName) {
    switch (channelName) {
      case "قناة عامة":
      case "عامة":
        return 1;
      case "قناة الرعاية":
      case "الرعاية":
        return 2;
      case "ذوي الشهداء":
        return 3;
      case "ذوي الإعاقة":
      case "ذوي الاعاقة":
        return 4;
      case "قناة الأبطال الرياضيين":
      case "الابطال الرياضيين":
        return 5;
      case "قناة السجناء السياسيين":
      case "السجناء السياسيين":
        return 6;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.school, color: Color(0xFF16A34A)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getDialogTitle(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 320,
        height: 380,
        child: Column(
          children: [
            if (_selectedMainBranch != null) ...[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      if (_selectedSubCategory != null) {
                        _selectedSubCategory = null;
                      } else {
                        _selectedMainBranch = null;
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('رجوع'),
                ),
              ),
              const Divider(),
            ],
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _buildOptionsList(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إغلاق', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  String _getDialogTitle() {
    if (_selectedMainBranch == null) {
      return 'اختر الفرع الدراسي';
    } else if (_selectedMainBranch == 'علمي') {
      return 'اختر الفرع العلمي';
    } else if (_selectedMainBranch == 'مهني') {
      if (_selectedSubCategory == 'تجارة') return 'اختر تخصص التجارة';
      if (_selectedSubCategory == 'صناعة') return 'اختر تخصص الصناعة';
      return 'اختر فرع المهني';
    } else {
      return 'الخيار المحدد';
    }
  }

  List<Widget> _buildOptionsList() {
    // 1. القائمة الرئيسية (علمي = 1، أدبي = 2، مهني = 3)
    if (_selectedMainBranch == null) {
      return [
        _buildOptionTile('علمي', Icons.science, () {
          setState(() => _selectedMainBranch = 'علمي');
        }),
        _buildOptionTile('أدبي', Icons.menu_book, () {
          // الأدبي: brch1 = 2, brch2 = 0
          _promptForGrade(
            finalBranchName: 'أدبي',
            mainBranchId: 2,
            subBranchId: 0,
          );
        }),
        _buildOptionTile('مهني', Icons.engineering, () {
          setState(() => _selectedMainBranch = 'مهني');
        }),
      ];
    }

    // 2. تفرعات العلمي (brch1 = 1)
    if (_selectedMainBranch == 'علمي') {
      return [
        _buildOptionTile(
          'عام',
          Icons.book,
          () => _promptForGrade(
            finalBranchName: 'علمي - عام',
            mainBranchId: 1,
            subBranchId: 1, // عام
          ),
        ),
        _buildOptionTile(
          'أحيائي',
          Icons.biotech,
          () => _promptForGrade(
            finalBranchName: 'علمي - أحيائي',
            mainBranchId: 1,
            subBranchId: 2, // احيائي
          ),
        ),
        _buildOptionTile(
          'تطبيقي',
          Icons.calculate,
          () => _promptForGrade(
            finalBranchName: 'علمي - تطبيقي',
            mainBranchId: 1,
            subBranchId: 3, // تطبيقي
          ),
        ),
      ];
    }

    // 3. تفرعات المهني الرئيسية (brch1 = 3)
    if (_selectedMainBranch == 'مهني' && _selectedSubCategory == null) {
      return [
        _buildOptionTile(
          'صناعة',
          Icons.precision_manufacturing,
          () => setState(() => _selectedSubCategory = 'صناعة'),
        ),
        _buildOptionTile(
          'تجارة',
          Icons.store,
          () => setState(() => _selectedSubCategory = 'تجارة'),
        ),
      ];
    }

    // 4. خيارات فرع التجارة (brch1 = 3, brch2 = 5)
    if (_selectedSubCategory == 'تجارة') {
      final List<String> tradeBranches = ['عام', 'إدارة', 'محاسبة'];
      return tradeBranches.map((trade) {
        return _buildOptionTile(
          trade,
          Icons.domain,
          () => _promptForGrade(
            finalBranchName: 'مهني - تجارة ($trade)',
            mainBranchId: 3,
            subBranchId: 5, // 5 = تجارة حسب جدول التفرعات
          ),
        );
      }).toList();
    }

    // 5. تخصصات فرع الصناعة (brch1 = 3, brch2 = 4)
    if (_selectedSubCategory == 'صناعة') {
      final List<String> industrialSpecialties = [
        "تكنولوجيا صناعية",
        "ميكاترونكس سيارات",
        "خزف وزجاج",
        "معالجة المياه وشبكاتها",
        "طباعة",
        "نسيج",
        "تكييف الهواء",
        "سيارات",
        "نجارة",
        "لحام وتشكيل المعادن",
        "صيانة المصاعد الكهربائية",
        "مكننة زراعية",
        "ميكانيك",
        "أدوات",
        "تجميع مكائن",
        "مكائن",
        "تشغيل",
        "خراطة",
        "قاطرات",
        "قوى",
        "فريزة",
        "محركات",
        "تدفئة",
        "معادن",
        "مكائن ومعدات",
        "مضخات وتوربينات",
        "إنتاج",
        "تبريد وتكييف",
        "نماذج",
        "غزل",
        "تكنولوجيا السباكة",
        "إلكترونيك وسيطرة",
        "حاسبات",
        "شبكات الحاسوب",
        "تكييف الهواء والتثليج",
        "تكرير النفط ومعالجة الغاز",
        "صناعات بتروكيمياوية",
        "كهرباء",
        "القوة الكهربائية",
        "مكائن كهربائية",
        "ميكاترونيك",
        "اتصالات",
        "توليد الطاقة الكهربائية ونقلها",
        "أجهزة طبية",
        "صيانة منظومات الليزر",
        "صيانة حاسوب",
        "تجميع وصيانة الحاسوب",
        "حاسوب والهواتف المحمولة",
        "أجهزة الهاتف والحاسوب المحمول",
        "الاكترونيك وسيطرة الاكترون",
      ];

      return industrialSpecialties.map((specName) {
        return _buildOptionTile(
          specName,
          Icons.build,
          () => _promptForGrade(
            finalBranchName: 'صناعة - $specName',
            mainBranchId: 3,
            subBranchId: 4, // 4 = صناعة حسب جدول التفرعات
          ),
        );
      }).toList();
    }

    return [];
  }

  Widget _buildOptionTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF16A34A)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _promptForGrade({
    required String finalBranchName,
    required int mainBranchId,
    required int subBranchId,
  }) {
    Navigator.of(context).pop();

    TextEditingController gradeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('أدخل معدلك ($finalBranchName)'),
          content: TextField(
            controller: gradeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'مثال: 75.5',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
              ),
              onPressed: () {
                double? studentGrade = double.tryParse(gradeController.text);
                if (studentGrade != null) {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdmissionGradesScreen(
                        selectedBranch: finalBranchName,
                        studentGrade: studentGrade,
                        channelId: _getChannelId(widget.selectedChannelName),
                        branch1Id: mainBranchId,
                        branch2Id: subBranchId,
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'عرض الأقسام المقبولة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
