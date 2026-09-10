import 'package:flutter/material.dart';

void showStudentTuitionDialog(
  BuildContext context,
  Color activeBlueColor,
  Color goldColor,
) {
  showDialog(
    context: context,
    builder: (context) {
      return _TuitionCodeInputDialog(
        activeBlueColor: activeBlueColor,
        goldColor: goldColor,
      );
    },
  );
}

// ---------------------------------------------------------------------------
// 1. نافذة إدخال الرقم الامتحاني
// ---------------------------------------------------------------------------
class _TuitionCodeInputDialog extends StatefulWidget {
  final Color activeBlueColor;
  final Color goldColor;

  const _TuitionCodeInputDialog({
    required this.activeBlueColor,
    required this.goldColor,
  });

  @override
  State<_TuitionCodeInputDialog> createState() =>
      __TuitionCodeInputDialogState();
}

class __TuitionCodeInputDialogState extends State<_TuitionCodeInputDialog>
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
          Icon(Icons.payments_outlined, color: widget.goldColor),
          const SizedBox(width: 8),
          const Text(
            'التحقق من القسط',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'يرجى إدخال الرقم الامتحاني للتحقق من القسط الدراسي',
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
              _showTuitionStatusResult(
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

void _showTuitionStatusResult(
  BuildContext context, {
  required String studentCode,
  required Color goldColor,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return _TuitionResultAnimatedDialog(
        studentCode: studentCode,
        goldColor: goldColor,
      );
    },
  );
}

// ---------------------------------------------------------------------------
// 2. نافذة عرض وصل التسديد بتأثير خروج الوصل من الطابعة (مع تصميم وصل حقيقي)
// ---------------------------------------------------------------------------
class _TuitionResultAnimatedDialog extends StatefulWidget {
  final String studentCode;
  final Color goldColor;

  const _TuitionResultAnimatedDialog({
    required this.studentCode,
    required this.goldColor,
  });

  @override
  State<_TuitionResultAnimatedDialog> createState() =>
      __TuitionResultAnimatedDialogState();
}

class __TuitionResultAnimatedDialogState
    extends State<_TuitionResultAnimatedDialog> with TickerProviderStateMixin {
  late AnimationController _printController;
  late Animation<double> _slideAnimation;

  late AnimationController _pulseController;
  late Animation<Color?> _iconColorAnimation;

  @override
  void initState() {
    super.initState();

    _printController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
                  // --- أ) جسم الوصل الورقي الحقيقي المتحرك ---
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
                        clipper: ReceiptClipper(), // قطع حواف الوصل المشرشرة
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

                              // 1. شعار الوصل (صورة chat.png)
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
                                        Icons.person_pin,
                                        size: 40,
                                        color: widget.goldColor,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // 2. اسم الطالب الثلاثي والرقم الامتحاني
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
                              const SizedBox(height: 6),
                              Text(
                                'هندسة النفط',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: widget.goldColor,
                                ),
                              ),

                              const SizedBox(height: 10),
                              _buildDottedLine(isDark),
                              const SizedBox(height: 10),

                              // 3. تفاصيل الأقساط والمراحل
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // --- المرحلة الأولى ---
                                  _buildSectionHeader('المرحلة الأولى', isDark),
                                  const SizedBox(height: 6),
                                  _buildPaymentRowWithDiscount(
                                    'القسط الأول',
                                    'تخفيض مليون',
                                    'تم تسديد 1,000,000 د.ع',
                                    widget.goldColor,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildStandardPaymentRow(
                                    'القسط الثاني',
                                    'تم تسديد 1,000,000 د.ع',
                                    Colors.green,
                                    Icons.check_circle,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildStandardPaymentRow(
                                    'القسط الثالث',
                                    'تم تسديد 500,000 د.ع',
                                    Colors.green,
                                    Icons.check_circle,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildStandardPaymentRow(
                                    'القسط الرابع',
                                    'تم تسديد 500,000 د.ع',
                                    Colors.green,
                                    Icons.check_circle,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildSummaryRow(
                                    'مجموع قسط المرحلة الأولى',
                                    '3,000,000 د.ع',
                                    Colors.green,
                                  ),

                                  const SizedBox(height: 14),

                                  // --- المرحلة الثانية ---
                                  _buildSectionHeader(
                                      'المرحلة الثانية', isDark),
                                  const SizedBox(height: 6),
                                  _buildPaymentRowWithDiscount(
                                    'القسط الأول',
                                    'تخفيض مليون',
                                    'تم تسديد 1,000,000 د.ع',
                                    widget.goldColor,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildStandardPaymentRow(
                                    'القسط الثاني',
                                    'تم تسديد 1,000,000 د.ع',
                                    Colors.green,
                                    Icons.check_circle,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildStandardPaymentRow(
                                    'القسط الثالث',
                                    'تم تسديد 500,000 د.ع',
                                    Colors.green,
                                    Icons.check_circle,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildStandardPaymentRow(
                                    'القسط الرابع',
                                    'لم يتم التسديد',
                                    Colors.red,
                                    Icons.cancel,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildSummaryRow(
                                    'مجموع قسط المرحلة الثانية',
                                    '3,000,000 د.ع',
                                    widget.goldColor,
                                  ),
                                  const SizedBox(height: 4),
                                  _buildSummaryRow(
                                    'المتبقي من القسط الكلي',
                                    '500,000 د.ع',
                                    Colors.red,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),
                              _buildDottedLine(isDark),
                              const SizedBox(height: 12),

                              // 4. رسم الباركود اسفل الوصل
                              _buildBarcodeWidget(isDark, widget.studentCode),

                              const SizedBox(height: 12),

                              // 5. ملاحظة توضيحية
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
                                        ' سيتم تفعيل قريبا',
                                        style: TextStyle(
                                          fontSize: 10,
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

                  // --- ب) فتحة الطابعة العلوية ---
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

  // رسم فاصل نقطي كأنه وصل طباعة حرارية
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

  // رسم عنصر الباركود اسفل الوصل
  Widget _buildBarcodeWidget(bool isDark, String studentCode) {
    return Column(
      children: [
        SizedBox(
          height: 38,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(42, (index) {
              final double lineWidth = (index % 3 == 0)
                  ? 3.0
                  : (index % 2 == 0)
                      ? 1.5
                      : 2.0;
              final bool isSpace = (index % 5 == 0);
              return Container(
                width: isSpace ? 2.5 : lineWidth,
                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                color: isSpace
                    ? Colors.transparent
                    : (isDark ? Colors.white70 : Colors.black87),
              );
            }),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '* REC-$studentCode-PAY *',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2,
            fontFamily: 'monospace',
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: widget.goldColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: widget.goldColor.withOpacity(0.4)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF002366),
        ),
      ),
    );
  }

  Widget _buildPaymentRowWithDiscount(
    String title,
    String discountText,
    String mainStatus,
    Color goldColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.06),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  discountText,
                  style: TextStyle(
                    color: goldColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('/', style: TextStyle(fontSize: 10)),
                const SizedBox(width: 4),
                Text(
                  mainStatus,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedBuilder(
                  animation: _iconColorAnimation,
                  builder: (context, child) {
                    return Icon(
                      Icons.check_circle,
                      color: _iconColorAnimation.value,
                      size: 15,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardPaymentRow(
    String title,
    String status,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          Row(
            children: [
              Text(
                status,
                style: TextStyle(
                  color: color,
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

  Widget _buildSummaryRow(String title, String value, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Clipper لعمل زوايا وحواف الوصل المشرشرة (وصل حراري حقيقي)
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
