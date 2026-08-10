import 'package:flutter/material.dart';

void showGraduationDatesDialog(
  BuildContext context,
  Color activeBlueColor,
  Color goldColor,
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

  final List<String> batches = [
    'دفعة 2023 - 2024',
    'دفعة 2024 - 2025',
    'دفعة 2025 - 2026',
    'دفعة 2026 - 2027',
    'دفعة 2027 - 2028',
  ];

  final Map<String, String> graduationDates = {
    'دفعة 2023 - 2024': '2024/10/19',
    'دفعة 2024 - 2025': '2027/10/20',
    'دفعة 2025 - 2026': '2028/10/18',
    'دفعة 2026 - 2027': '2029/10/22',
    'دفعة 2027 - 2028': '2030/10/25',
  };

  String? selectedDepartment;
  String? selectedBatch;

  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  final Color subtitleColor = isDark ? Colors.white70 : Colors.grey.shade700;
  final Color primaryButtonColor = isDark ? goldColor : activeBlueColor;
  final Color buttonTextColor = isDark ? Colors.black : Colors.white;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const AnimatedGraduationIcon(),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'مواعيد حفلات التخرج',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'اختر القسم والدفعة لعرض موعد حفل التخرج',
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // اختر القسم
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    dropdownColor: Theme.of(context).cardColor,
                    decoration: InputDecoration(
                      labelText: 'اختر القسم',
                      prefixIcon: Icon(
                        Icons.school_outlined,
                        color: goldColor,
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

                  // اختر الدفعة الدراسية
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    dropdownColor: Theme.of(context).cardColor,
                    decoration: InputDecoration(
                      labelText: 'اختر الدفعة ',
                      prefixIcon: Icon(
                        Icons.workspace_premium_outlined,
                        color: goldColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: selectedBatch,
                    items: batches
                        .map(
                          (batch) => DropdownMenuItem<String>(
                            value: batch,
                            child: Text(
                              batch,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedBatch = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'إلغاء',
                  style: TextStyle(color: subtitleColor),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryButtonColor,
                  foregroundColor: buttonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.stars, size: 18),
                label: const Text(
                  'إظهار الموعد',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (selectedDepartment != null && selectedBatch != null) {
                    final String date =
                        graduationDates[selectedBatch] ?? 'غير محدد';

                    Navigator.pop(dialogContext);

                    _showGraduationResultDialog(
                      context: context,
                      department: selectedDepartment!,
                      batch: selectedBatch!,
                      date: date,
                      goldColor: goldColor,
                      royalBlueColor: activeBlueColor,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى تحديد القسم والدفعة أولاً'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}

// نافذة عرض النتيجة النهائية للموعد
void _showGraduationResultDialog({
  required BuildContext context,
  required String department,
  required String batch,
  required String date,
  required Color goldColor,
  required Color royalBlueColor,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AnimatedGraduationIcon(size: 60),
            const SizedBox(height: 16),
            Text(
              'موعد حفل التخرج',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: goldColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: goldColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: goldColor, width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    department,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    batch,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event, color: royalBlueColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: royalBlueColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: goldColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('تم',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    },
  );
}

// ويدجت أيقونة التخرج المتحركة بالوميض بين الذهبي والأزرق
class AnimatedGraduationIcon extends StatefulWidget {
  final double size;
  const AnimatedGraduationIcon({super.key, this.size = 28});

  @override
  State<AnimatedGraduationIcon> createState() => _AnimatedGraduationIconState();
}

class _AnimatedGraduationIconState extends State<AnimatedGraduationIcon>
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
          Icons.school,
          color: _colorAnimation.value,
          size: widget.size,
        );
      },
    );
  }
}
