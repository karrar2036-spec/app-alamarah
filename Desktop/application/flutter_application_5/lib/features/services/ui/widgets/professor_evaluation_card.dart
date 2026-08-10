import 'package:flutter/material.dart';

void showProfessorEvaluationDialog(
  BuildContext context,
  Color primaryBlue,
  Color goldColor,
) {
  showDialog(
    context: context,
    builder: (context) {
      return _EvaluationCodeInputDialog(
        primaryBlue: primaryBlue,
        goldColor: goldColor,
      );
    },
  );
}

// 1. النافذة الأولى: إدخال الرقم الامتحاني
class _EvaluationCodeInputDialog extends StatefulWidget {
  final Color primaryBlue;
  final Color goldColor;

  const _EvaluationCodeInputDialog({
    required this.primaryBlue,
    required this.goldColor,
  });

  @override
  State<_EvaluationCodeInputDialog> createState() =>
      __EvaluationCodeInputDialogState();
}

class __EvaluationCodeInputDialogState extends State<_EvaluationCodeInputDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<Color?> _iconColorAnimation;
  final TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _iconColorAnimation = ColorTween(
      begin: const Color(0xFFD4AF37), // ذهبي
      end: const Color(0xFF002366), // أزرق ملكي
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.rate_review_outlined,
            color: widget.goldColor,
          ),
          const SizedBox(width: 8),
          const Text(
            'تقييم الأساتذة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'يرجى إدخال الرقم الامتحاني للمتابعة للتقييم',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: codeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'أدخل الرقم الامتحاني هنا',
              prefixIcon: AnimatedBuilder(
                animation: _iconColorAnimation,
                builder: (context, child) {
                  return Icon(
                    Icons.badge_outlined,
                    color: _iconColorAnimation.value,
                  );
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (codeController.text.trim().isNotEmpty) {
              Navigator.pop(context);
              _openMainEvaluationDialog(
                context,
                widget.primaryBlue,
                widget.goldColor,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('يرجى إدخال الرقم الامتحاني'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('تحقق', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// 2. النافذة الثانية: نافذة تقييم الأساتذة الرئيسية
void _openMainEvaluationDialog(
  BuildContext context,
  Color primaryBlue,
  Color goldColor,
) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  final Color subtitleColor = isDark ? Colors.white70 : Colors.grey.shade700;

  String? selectedDepartment;
  String? selectedDoctor;
  int starCount = 5; // الافتراضي 5 نجوم (يعادل 10/10)

  final Map<String, String> departmentProfessors = {
    'طب الأسنان': 'دكتور فارس',
    'الصيدلة': 'دكتور مجد',
    'صناعة الأسنان': 'دكتور محمد',
    'التحليلات المرضية': 'ست نبأ',
    'الأشعة والسونار': 'أستاذ محمد',
    'التجميل بالليزر': 'أستاذ منتظر',
    'القانون': 'أستاذ رشيد',
    'اللغة الإنكليزية': 'أستاذ علي',
    'قسم المحاسبة': 'أستاذ مظاهر',
    'إدارة وتسويق النفط والغاز': 'أستاذ علي',
    'هندسة النفط': 'دكتور عامر',
    'هندسة الكيمياويات والصناعات النفطية': 'دكتور مرتضى',
    'هندسة تقنيات الميكانيك': 'دكتور عبد الحسين',
    'هندسة المدني': 'أستاذ وليد',
    'هندسة الذكاء الاصطناعي': 'دكتور ضياء',
    'هندسة تقنيات الأجهزة الطبية': 'دكتور علي',
    'هندسة الكهرباء': 'أستاذ علي',
    'هندسة تقنيات الأمن السيبراني': 'أستاذ تحسين',
  };

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          List<String> availableProfessors = [];
          if (selectedDepartment != null &&
              departmentProfessors.containsKey(selectedDepartment)) {
            availableProfessors = [departmentProfessors[selectedDepartment]!];
          }

          int currentScore = starCount * 2; // حساب الدرجة من 10

          return AlertDialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: goldColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تقييم الأساتذة',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختر القسم الأكاديمي والأستاذ وحدد التقييم',
                    style: TextStyle(
                      fontSize: 12,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    dropdownColor: Theme.of(context).cardColor,
                    decoration: InputDecoration(
                      labelText: 'اختر القسم',
                      prefixIcon: const Icon(Icons.school_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: selectedDepartment,
                    items: departmentProfessors.keys
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
                        selectedDoctor = null;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    dropdownColor: Theme.of(context).cardColor,
                    decoration: InputDecoration(
                      labelText: 'اختر الأستاذ / الدكتور',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: selectedDoctor,
                    items: availableProfessors
                        .map(
                          (prof) => DropdownMenuItem<String>(
                            value: prof,
                            child: Text(
                              prof,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: selectedDepartment == null
                        ? null
                        : (value) {
                            setStateDialog(() {
                              selectedDoctor = value;
                            });
                          },
                  ),
                  const SizedBox(height: 18),

                  // --- قسم التقييم والنجوم ---
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                index < starCount
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: goldColor,
                                size: 36,
                              ),
                              onPressed: () {
                                setStateDialog(() {
                                  starCount = index + 1;
                                });
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 10),

                        // --- شريط التقييم البصري والدرجة ---
                        Row(
                          children: [
                            const Icon(Icons.align_horizontal_left_rounded,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: currentScore / 10.0,
                                  minHeight: 10,
                                  backgroundColor: isDark
                                      ? Colors.white10
                                      : Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    currentScore == 10
                                        ? Colors.green
                                        : (currentScore >= 6
                                            ? goldColor
                                            : Colors.orangeAccent),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$currentScore / 10',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: currentScore == 10
                                    ? Colors.green
                                    : (currentScore >= 6
                                        ? goldColor
                                        : Colors.orangeAccent),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? goldColor : primaryBlue,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (selectedDepartment != null && selectedDoctor != null) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'تم إرسال تقييمك ($currentScore/10) بنجاح، شكراً لمشاركتك!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى تحديد القسم والأستاذ'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('إرسال التقييم'),
              ),
            ],
          );
        },
      );
    },
  );
}
