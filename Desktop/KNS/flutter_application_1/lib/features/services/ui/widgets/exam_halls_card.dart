import 'package:flutter/material.dart';

void showExamHallsDialog(
  BuildContext context,
  Color primaryColor,
  Color accentColor,
) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return _ExamHallCodeInputDialog(
        primaryColor: primaryColor,
        accentColor: accentColor,
      );
    },
  );
}

// 1. نافذة إدخال الرقم الامتحاني الموحدة
class _ExamHallCodeInputDialog extends StatefulWidget {
  final Color primaryColor;
  final Color accentColor;

  const _ExamHallCodeInputDialog({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  State<_ExamHallCodeInputDialog> createState() =>
      __ExamHallCodeInputDialogState();
}

class __ExamHallCodeInputDialogState extends State<_ExamHallCodeInputDialog>
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
            Icons.meeting_room_outlined,
            color: widget.accentColor,
          ),
          const SizedBox(width: 8),
          const Text(
            'قاعات امتحانية',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'يرجى إدخال الرقم الامتحاني للوصول لخريطة القاعة',
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
            backgroundColor: widget.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (codeController.text.trim().isNotEmpty) {
              Navigator.pop(context);
              _showHallDetailsDialog(
                context,
                widget.primaryColor,
                widget.accentColor,
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

// 2. النافذة الثانية: خريطة وتفاصيل القاعة الامتحانية
void _showHallDetailsDialog(
  BuildContext context,
  Color primaryColor,
  Color accentColor,
) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return ExamHallMapDialog(
        primaryColor: primaryColor,
        accentColor: accentColor,
      );
    },
  );
}

class ExamHallMapDialog extends StatefulWidget {
  final Color primaryColor;
  final Color accentColor;

  const ExamHallMapDialog({
    super.key,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  State<ExamHallMapDialog> createState() => _ExamHallMapDialogState();
}

class _ExamHallMapDialogState extends State<ExamHallMapDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _iconColorAnimation;

  final Map<String, List<String?>> hallRows = {
    'الخط 1': ['أحمد', 'باقر', 'علي', 'حيدر', 'محمد'],
    'الخط 2': [null, null, null, null, null],
    'الخط 3': ['إبراهيم', 'فاطمة', 'حيدر', 'حسين', 'زينب'],
    'الخط 4': [null, null, null, null, null],
    'الخط 5': ['أيمن', 'خالد', 'محمد', 'مهدي', 'رسل'],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    _iconColorAnimation = ColorTween(
      begin: const Color(0xFFD4AF37), // ذهبي
      end: const Color(0xFF002366), // أزرق ملكي
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: widget.primaryColor, width: 1),
            ),
            child: const Text(
              'قسم النفط',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.meeting_room, color: widget.accentColor, size: 18),
              const SizedBox(width: 6),
              const Text(
                'Auc-1-B-1-04: ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const Text(
                'رمز القاعة',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                'ــ البناية الثانية  / الطابق الاول / القاعة 4 ــ',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
            children: hallRows.entries.map((entry) {
              final String lineName = entry.key;
              final List<String?> seats = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.04)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lineName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        final String? studentName = seats[index];

                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: studentName != null
                                  ? Theme.of(context).cardColor
                                  : (isDark
                                      ? Colors.black26
                                      : Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: studentName != null
                                    ? widget.accentColor.withOpacity(0.5)
                                    : (isDark
                                        ? Colors.white10
                                        : Colors.grey.shade300),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedBuilder(
                                  animation: _iconColorAnimation,
                                  builder: (context, child) {
                                    return Icon(
                                      Icons.event_seat,
                                      size: 18,
                                      color: studentName != null
                                          ? _iconColorAnimation.value
                                          : Colors.grey.shade400,
                                    );
                                  },
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  studentName ?? 'فارغ',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: studentName != null
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: studentName != null
                                        ? (isDark ? Colors.white : Colors.black)
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'إغلاق',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
