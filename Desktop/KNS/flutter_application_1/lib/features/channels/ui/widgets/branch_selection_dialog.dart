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

class _BranchSelectionDialogState extends State<BranchSelectionDialog>
    with SingleTickerProviderStateMixin {
  String? _selectedMainBranch;
  String? _selectedSubCategory;

  late AnimationController _blinkController;
  late Animation<double> _glowAnimation;

  // اللون المطلوب: #002366
  static const Color primaryRoyalBlue = Color(0xFF002366);

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

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
          _buildShiningIcon(Icons.school),
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
                  icon: const Icon(Icons.arrow_back,
                      size: 16, color: primaryRoyalBlue),
                  label: const Text('رجوع',
                      style: TextStyle(color: primaryRoyalBlue)),
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

  Widget _buildShiningIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _glowAnimation.value,
          child: Icon(
            icon,
            color: primaryRoyalBlue,
            shadows: [
              BoxShadow(
                color: primaryRoyalBlue.withValues(
                    alpha: _glowAnimation.value * 0.8),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
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
    // 1. القائمة الرئيسية
    if (_selectedMainBranch == null) {
      return [
        _buildOptionTile('علمي', Icons.science, () {
          setState(() => _selectedMainBranch = 'علمي');
        }),
        _buildOptionTile('أدبي', Icons.menu_book, () {
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

    // 2. تفرعات العلمي
    if (_selectedMainBranch == 'علمي') {
      return [
        _buildOptionTile(
          'عام',
          Icons.book,
          () => _promptForGrade(
            finalBranchName: 'علمي - عام',
            mainBranchId: 1,
            subBranchId: 1,
          ),
        ),
        _buildOptionTile(
          'أحيائي',
          Icons.biotech,
          () => _promptForGrade(
            finalBranchName: 'علمي - أحيائي',
            mainBranchId: 1,
            subBranchId: 2,
          ),
        ),
        _buildOptionTile(
          'تطبيقي',
          Icons.calculate,
          () => _promptForGrade(
            finalBranchName: 'علمي - تطبيقي',
            mainBranchId: 1,
            subBranchId: 3,
          ),
        ),
      ];
    }

    // 3. تفرعات المهني (صناعة، تجارة، زراعة)
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
        _buildOptionTile(
          'زراعة',
          Icons.agriculture,
          () => _promptForGrade(
            finalBranchName: 'مهني - زراعة',
            mainBranchId: 3,
            subBranchId: 6,
          ),
        ),
      ];
    }

    // 4. خيارات فرع التجارة
    if (_selectedSubCategory == 'تجارة') {
      final List<String> tradeBranches = ['عام', 'إدارة', 'محاسبة'];
      return tradeBranches.map((trade) {
        return _buildOptionTile(
          trade,
          Icons.domain,
          () => _promptForGrade(
            finalBranchName: 'مهني - تجارة ($trade)',
            mainBranchId: 3,
            subBranchId: 5,
          ),
        );
      }).toList();
    }

    // 5. تخصصات فرع الصناعة
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
            subBranchId: 4,
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
        leading: _buildShiningIcon(icon),
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
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text('أدخل معدلك ($finalBranchName)'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: gradeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    autofocus: true,
                    onChanged: (_) {
                      if (errorMessage != null) {
                        setDialogState(() => errorMessage = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'مثال: 75.5',
                      errorText: errorMessage,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRoyalBlue,
                  ),
                  onPressed: () {
                    double? studentGrade =
                        double.tryParse(gradeController.text.trim());

                    // شرط التحقق المعدل: يجب أن يكون بين 50 و 100
                    if (studentGrade == null ||
                        studentGrade < 50 ||
                        studentGrade > 100) {
                      setDialogState(() {
                        errorMessage = 'يرجى إدخال معدل صحيح بين 50 و 100';
                      });
                      return;
                    }

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
      },
    );
  }
}
