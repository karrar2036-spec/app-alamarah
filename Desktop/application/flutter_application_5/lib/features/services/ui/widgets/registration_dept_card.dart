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

// نافذة إدخال كود الطالب مع أيقونة تومض باللونين
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
          child: const Text('إلغاء'),
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
              Navigator.pop(context);
              _showRegistrationStatusResult(
                context,
                studentCode: codeController.text.trim(),
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
    builder: (context) {
      return _RegistrationResultAnimatedDialog(
        studentCode: studentCode,
        goldColor: goldColor,
      );
    },
  );
}

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
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        children: [
          Icon(
            Icons.folder_shared_outlined,
            size: 40,
            color: widget.goldColor,
          ),
          const SizedBox(height: 8),
          const Text(
            'حالة ملف التسجيل',
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
            children: [
              const Divider(),
              _buildStatusRow(
                'الوثيقة الدراسية',
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
              const Divider(height: 24),
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

  Widget _buildStatusRow(
    String title,
    String status,
    Color statusColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
}
