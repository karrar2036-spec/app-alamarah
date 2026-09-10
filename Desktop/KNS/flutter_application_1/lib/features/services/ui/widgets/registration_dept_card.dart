import 'package:flutter/material.dart';

void showRegistrationDeptDialog(
  BuildContext context,
  Color activeBlueColor,
  Color goldColor,
) {
  showDialog(
    context: context,
    builder: (context) {
      return _RegistrationInputDialog(
        activeBlueColor: activeBlueColor,
        goldColor: goldColor,
      );
    },
  );
}

// ---------------------------------------------------------------------------
// 1. نافذة إدخال الرقم الامتحاني
// ---------------------------------------------------------------------------
class _RegistrationInputDialog extends StatefulWidget {
  final Color activeBlueColor;
  final Color goldColor;

  const _RegistrationInputDialog({
    required this.activeBlueColor,
    required this.goldColor,
  });

  @override
  State<_RegistrationInputDialog> createState() =>
      __RegistrationInputDialogState();
}

class __RegistrationInputDialogState extends State<_RegistrationInputDialog>
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
      begin: const Color(0xFFD4AF37),
      end: const Color(0xFF002366),
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
          Icon(Icons.app_registration_outlined, color: widget.goldColor),
          const SizedBox(width: 8),
          const Text(
            'قسم التسجيل',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'يرجى إدخال الرقم الامتحاني للتحقق من حالة الملف',
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
            backgroundColor: widget.activeBlueColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (codeController.text.trim().isNotEmpty) {
              final String studentCode = codeController.text.trim();
              Navigator.pop(context);
              _showRegistrationStatusResult(
                context,
                studentCode: studentCode,
                goldColor: widget.goldColor,
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

void _showRegistrationStatusResult(
  BuildContext context, {
  required String studentCode,
  required Color goldColor,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return _RegistrationResultAnimatedDialog(
        studentCode: studentCode,
        goldColor: goldColor,
      );
    },
  );
}

// ---------------------------------------------------------------------------
// 2. نافذة عرض وصل قسم التسجيل المطبوع (تصميم وصل حقيقي بدون باركود)
// ---------------------------------------------------------------------------
class _RegistrationResultAnimatedDialog extends StatefulWidget {
  final String studentCode;
  final Color goldColor;

  const _RegistrationResultAnimatedDialog({
    required this.studentCode,
    required this.goldColor,
  });

  @override
  State<_RegistrationResultAnimatedDialog> createState() =>
      __RegistrationResultAnimatedDialogState();
}

class __RegistrationResultAnimatedDialogState
    extends State<_RegistrationResultAnimatedDialog>
    with TickerProviderStateMixin {
  late AnimationController _printController;
  late Animation<double> _slideAnimation;

  late AnimationController _pulseController;
  late Animation<Color?> _iconColorAnimation;

  @override
  void initState() {
    super.initState();

    _printController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _printController,
        curve: Curves.easeOutCubic,
      ),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _iconColorAnimation = ColorTween(
      begin: const Color(0xFFD4AF37),
      end: const Color(0xFF002366),
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _printController.forward();
  }

  @override
  void dispose() {
    _printController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _reprintAnimation() {
    _printController.reset();
    _printController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  // --- أ) الورقة المطبوعة للوصل ---
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        return ClipRect(
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: _slideAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: ClipPath(
                        clipper: ReceiptClipper(), // حافة الوصل المشرشرة
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.88,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFFAFAFA),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),

                              // 1. صورة الشعار
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: widget.goldColor,
                                    width: 2,
                                  ),
                                  color: Colors.white,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'photo/chat.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.folder_shared_outlined,
                                        size: 36,
                                        color: widget.goldColor,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // 2. معلومات الطالب والتقرير
                              const Text(
                                'محمد أحمد علي', // اسم الطالب الثلاثي
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'الرقم الامتحاني: ${widget.studentCode}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'حالة ملف التسجيل',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: widget.goldColor,
                                ),
                              ),

                              const SizedBox(height: 10),
                              _buildDottedLine(isDark),
                              const SizedBox(height: 12),

                              // 3. بنود حالة الملف
                              _buildStatusRow(
                                'الوثيقة الدراسية',
                                'تم التسليم',
                                Colors.green,
                                Icons.check_circle,
                              ),
                              const SizedBox(height: 8),
                              _buildStatusRow(
                                'المستمسكات الشخصية',
                                'تم التسليم',
                                Colors.green,
                                Icons.check_circle,
                              ),
                              const SizedBox(height: 8),
                              _buildStatusRow(
                                'تأييد الكفيل',
                                'تم التسليم',
                                Colors.green,
                                Icons.check_circle,
                              ),
                              const SizedBox(height: 8),
                              _buildStatusRow(
                                'تطبيق Hepiq',
                                'تم تسديد المبلغ (66 ألف د.ع)',
                                Colors.green,
                                Icons.check_circle,
                              ),
                              const SizedBox(height: 8),
                              _buildStatusRow(
                                'الفحص الطبي',
                                'نقص في الملف',
                                Colors.red,
                                Icons.cancel,
                              ),

                              const SizedBox(height: 12),
                              _buildDottedLine(isDark),
                              const SizedBox(height: 12),

                              // 4. الملاحظة التوضيحية
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        Colors.amber.shade700.withOpacity(0.5),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'ملاحظة: هذه البيانات تجريبية وغير حقيقية، سيتم العمل عليها والتفعيل قريباً.',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: _reprintAnimation,
                                    icon: const Icon(Icons.replay),
                                    tooltip: 'إعادة الطباعة والحركة',
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: widget.goldColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.check,
                                        color: Colors.black, size: 18),
                                    label: const Text(
                                      'إغلاق',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- ب) فتحة خروج الوصل من الطابعة ---
                  Container(
                    width: 240,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 180,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // رسم فاصل نقطي حراري
  Widget _buildDottedLine(bool isDark) {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            height: 1,
            color: index % 2 == 0
                ? Colors.transparent
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  // بناء سطر الحالة
  Widget _buildStatusRow(
    String title,
    String status,
    Color statusColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedBuilder(
                animation: _iconColorAnimation,
                builder: (context, child) {
                  return Icon(
                    icon,
                    color: _iconColorAnimation.value,
                    size: 15,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Clipper لعمل زوايا وحواف الوصل المشرشرة
// ---------------------------------------------------------------------------
class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 10);

    // إضافة التشرشير أسفل ورقة الوصل
    double x = 0;
    double y = size.height - 10;
    double increment = size.width / 30;

    while (x < size.width) {
      x += increment;
      y = (y == size.height - 10) ? size.height : size.height - 10;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
