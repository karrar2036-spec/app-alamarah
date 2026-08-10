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

// نافذة إدخال الرقم الامتحاني مع أيقونة الهوية المومضة
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
    builder: (context) {
      return _TuitionResultAnimatedDialog(
        studentCode: studentCode,
        goldColor: goldColor,
      );
    },
  );
}

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
    extends State<_TuitionResultAnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<Color?> _iconColorAnimation;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 38,
            color: widget.goldColor,
          ),
          const SizedBox(height: 6),
          const Text(
            'حالة القسط الدراسي -قسم النفط',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'الرقم الامتحاني: ${widget.studentCode}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
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
              // --- المرحلة الأولى ---
              _buildSectionHeader('المرحلة الأولى', isDark),
              const SizedBox(height: 6),
              _buildPaymentRowWithDiscount(
                'القسط الأول',
                'تخفيض مليون',
                'تم تسديد مليون د.ع',
                widget.goldColor,
              ),
              const SizedBox(height: 6),
              _buildStandardPaymentRow(
                'القسط الثاني',
                'تم تسديد مليون د.ع',
                Colors.green,
                Icons.check_circle,
              ),
              const SizedBox(height: 6),
              _buildStandardPaymentRow(
                'القسط الثالث',
                'تم تسديد خمسمائة ألف د.ع',
                Colors.green,
                Icons.check_circle,
              ),
              const SizedBox(height: 6),
              _buildStandardPaymentRow(
                'القسط الرابع',
                'تم تسديد خمسمائة ألف د.ع',
                Colors.green,
                Icons.check_circle,
              ),
              const SizedBox(height: 6),
              _buildSummaryRow(
                'مجموع قسط المرحلة الأولى',
                ' ثلاثة ملاين د.ع',
                Colors.green,
              ),

              const SizedBox(height: 16),

              // --- المرحلة الثانية ---
              _buildSectionHeader('المرحلة الثانية', isDark),
              const SizedBox(height: 6),
              _buildPaymentRowWithDiscount(
                'القسط الأول',
                'تخفيض مليون',
                'تم تسديد مليون د.ع',
                widget.goldColor,
              ),
              const SizedBox(height: 6),
              _buildStandardPaymentRow(
                'القسط الثاني',
                'تم تسديد مليون د.ع',
                Colors.green,
                Icons.check_circle,
              ),
              const SizedBox(height: 6),
              _buildStandardPaymentRow(
                'القسط الثالث',
                'تم تسديد خمسمائة ألف د.ع',
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
                'ثلاثة ملاين د.ع',
                widget.goldColor,
              ),
              const SizedBox(height: 4),
              _buildSummaryRow(
                'المتبقي من القسط',
                'خمسمائة ألف د.ع',
                Colors.red,
              ),

              const Divider(height: 20),

              // ملاحظة توضيحية
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade700),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber, size: 18),
                    SizedBox(width: 8),
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
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.goldColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إغلاق',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // عنوان المقطع للمرحلة
  Widget _buildSectionHeader(String title, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: widget.goldColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: widget.goldColor.withOpacity(0.5)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF002366),
        ),
      ),
    );
  }

  // صف القسط الذي يحتوي على تخفيض (تم تصحيح ترتيب الأيقونة لتظهر أقصى اليسار)
  Widget _buildPaymentRowWithDiscount(
    String title,
    String discountText,
    String mainStatus,
    Color goldColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  discountText,
                  style: TextStyle(
                    color: goldColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: goldColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 4),
                const Text(
                  '/',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    mainStatus,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedBuilder(
                  animation: _iconColorAnimation,
                  builder: (context, child) {
                    return Icon(
                      Icons.check_circle,
                      color: _iconColorAnimation.value,
                      size: 18,
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

  // صف القسط القياسي
  Widget _buildStandardPaymentRow(
    String title,
    String status,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedBuilder(
                animation: _iconColorAnimation,
                builder: (context, child) {
                  return Icon(
                    icon,
                    color: _iconColorAnimation.value,
                    size: 18,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // صف ملخص المجموع/المتبقي
  Widget _buildSummaryRow(String title, String value, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
