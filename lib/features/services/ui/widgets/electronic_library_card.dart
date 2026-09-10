import 'package:flutter/material.dart';

void showElectronicLibraryDialog(
  BuildContext context,
  Color primaryColor,
  Color accentColor,
) {
  final List<String> departments = [
    'طب الأسنان',
    'الصيدلة',
    'صناعة الأسنان',
    'التحليلات المرضية',
    'الأشعة والسونار',
    'التجميل بالليزر',
    'القانون',
    'اللغة الإنكليزية',
    'قسم المحاسبة',
    'إدارة وتسويق النفط والغاز',
    'هندسة النفط',
    'هندسة الكيمياويات والصناعات النفطية',
    'هندسة تقنيات الميكانيك',
    'هندسة المدني',
    'هندسة الذكاء الاصطناعي',
    'هندسة تقنيات الأجهزة الطبية',
    'هندسة الكهرباء',
    'هندسة تقنيات الأمن السيبراني',
  ];

  final List<String> levels = [
    'المرحلة الأولى',
    'المرحلة الثانية',
    'المرحلة الثالثة',
    'المرحلة الرابعة',
  ];

  String? selectedDepartment;
  String? selectedLevel;

  showDialog(
    context: context,
    builder: (dialogContext) {
      final bool isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final Color subtitleColor =
          isDark ? Colors.white70 : Colors.grey.shade700;

      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const AnimatedFlashingIcon(
                  icon: Icons.local_library_outlined,
                  size: 26,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'مكتبة جامعة العمارة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يرجى تحديد القسم والمرحلة للوصول إلى أقسام المكتبة:',
                  style: TextStyle(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 16),

                // اختيار القسم
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  dropdownColor: Theme.of(context).cardColor,
                  decoration: InputDecoration(
                    labelText: 'اختر القسم',
                    prefixIcon: const AnimatedFlashingIcon(
                      icon: Icons.school_outlined,
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: selectedDepartment,
                  items: departments
                      .map(
                        (dept) => DropdownMenuItem<String>(
                          value: dept,
                          child: Text(
                            dept,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedDepartment = value;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // اختيار المرحلة
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  dropdownColor: Theme.of(context).cardColor,
                  decoration: InputDecoration(
                    labelText: 'اختر المرحلة',
                    prefixIcon: const AnimatedFlashingIcon(
                      icon: Icons.format_list_numbered,
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: selectedLevel,
                  items: levels
                      .map(
                        (level) => DropdownMenuItem<String>(
                          value: level,
                          child: Text(
                            level,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedLevel = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'إلغاء',
                  style: TextStyle(color: subtitleColor),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? const Color(0xFFD4AF37) : primaryColor,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (selectedDepartment != null && selectedLevel != null) {
                    Navigator.pop(dialogContext);

                    // فتح نافذة أقسام المكتبة
                    _showLibraryCategoriesDialog(
                      context: context,
                      department: selectedDepartment!,
                      level: selectedLevel!,
                      primaryColor: primaryColor,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'يرجى تحديد القسم والمرحلة',
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Text(
                  'الدخول إلى أقسام المكتبة',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

// نافذة عرض أقسام المكتبة بعد إتمام الاختيار
void _showLibraryCategoriesDialog({
  required BuildContext context,
  required String department,
  required String level,
  required Color primaryColor,
}) {
  final List<Map<String, dynamic>> libraryCategories = [
    {
      'title': 'كتب المنهج',
      'subtitle': 'حسب القسم والمرحلة',
      'icon': Icons.menu_book_rounded,
    },
    {
      'title': 'محاضرات',
      'subtitle': 'PDF أو ملفات المادة',
      'icon': Icons.description_outlined,
    },
    {
      'title': 'أسئلة سنوات سابقة',
      'subtitle': 'امتحانات سابقة',
      'icon': Icons.quiz_outlined,
    },
    {
      'title': 'مراجع إضافية',
      'subtitle': 'كتب ومصادر تساعد الطالب',
      'icon': Icons.library_books_outlined,
    },
    {
      'title': 'مشاريع التخرج',
      'subtitle': 'مشاريع الطلاب السابقة',
      'icon': Icons.school_outlined,
    },
    {
      'title': 'مصادر إلكترونية',
      'subtitle': 'روابط لمصادر علمية',
      'icon': Icons.link_rounded,
    },
  ];

  String? selectedCategoryTitle;

  showDialog(
    context: context,
    builder: (context) {
      final bool isDark = Theme.of(context).brightness == Brightness.dark;
      final Color subtitleColor =
          isDark ? Colors.white70 : Colors.grey.shade700;

      return StatefulBuilder(
        builder: (context, setStateCategories) {
          return AlertDialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const AnimatedFlashingIcon(
                  icon: Icons.local_library_outlined,
                  size: 26,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'أقسام المكتبة الإلكترونية',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عرض القسم والمرحلة المختارة
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const AnimatedFlashingIcon(
                            icon: Icons.bookmark_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '$department - $level',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // إظهار تنبيه داخلي ضمن النافذة عند الضغط على أي قسم
                    if (selectedCategoryTitle != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF334155)
                              : Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.amber.shade600,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.hourglass_top_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'قسم ($selectedCategoryTitle) يتم العمل عليه قريباً.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // عرض الأقسام بأيقونات تومض
                    ...libraryCategories.map((category) {
                      final bool isSelected =
                          selectedCategoryTitle == category['title'];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 0,
                        color: isSelected
                            ? const Color(0xFFD4AF37).withOpacity(0.15)
                            : Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFFD4AF37)
                                : (isDark
                                    ? Colors.white24
                                    : Colors.grey.shade300),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: AnimatedFlashingIcon(
                            icon: category['icon'] as IconData,
                            size: 22,
                          ),
                          title: Text(
                            category['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          subtitle: Text(
                            category['subtitle'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              color: subtitleColor,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: isDark
                                ? const Color(0xFF60A5FA)
                                : const Color(0xFF002366),
                          ),
                          onTap: () {
                            setStateCategories(() {
                              selectedCategoryTitle =
                                  category['title'] as String;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إغلاق',
                    style: TextStyle(color: subtitleColor),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

// ويدجت أيقونة تومض باللونين الذهبي والأزرق الملكي
class AnimatedFlashingIcon extends StatefulWidget {
  final IconData icon;
  final double size;

  const AnimatedFlashingIcon({
    super.key,
    required this.icon,
    this.size = 24,
  });

  @override
  State<AnimatedFlashingIcon> createState() => _AnimatedFlashingIconState();
}

class _AnimatedFlashingIconState extends State<AnimatedFlashingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  final Color goldColor = const Color(0xFFD4AF37);
  final Color royalBlueColor = const Color(0xFF002366);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: goldColor,
      end: royalBlueColor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Icon(
          widget.icon,
          color: _colorAnimation.value,
          size: widget.size,
        );
      },
    );
  }
}
