import 'package:flutter/material.dart';

void showTopStudentsDialog(
  BuildContext context,
  Color primaryBlue,
  Color goldColor,
) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  final Color subtitleColor = isDark ? Colors.white70 : Colors.grey.shade700;

  String? selectedDepartment;
  String? selectedLevel;

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
                Icon(
                  Icons.workspace_premium,
                  color: goldColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'لوحة الشرف - الطلبة الأوائل',
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
                    'اختر القسم والمرحلة لعرض قوائم الأوائل:',
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    dropdownColor: Theme.of(context).cardColor,
                    decoration: InputDecoration(
                      labelText: 'اختر المرحلة',
                      prefixIcon: const Icon(Icons.format_list_numbered),
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
                  if (selectedDepartment != null && selectedLevel != null) {
                    Navigator.pop(dialogContext);
                    _showTopStudentsListModal(
                      context,
                      selectedDepartment!,
                      selectedLevel!,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى تحديد القسم والمرحلة'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('عرض الأوائل'),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showTopStudentsListModal(
  BuildContext context,
  String department,
  String level,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (modalContext) {
      return _TopStudentsListAnimatedWidget(
        department: department,
        level: level,
      );
    },
  );
}

class _TopStudentsListAnimatedWidget extends StatefulWidget {
  final String department;
  final String level;

  const _TopStudentsListAnimatedWidget({
    required this.department,
    required this.level,
  });

  @override
  State<_TopStudentsListAnimatedWidget> createState() =>
      __TopStudentsListAnimatedWidgetState();
}

class __TopStudentsListAnimatedWidgetState
    extends State<_TopStudentsListAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  late Animation<Color?> _goldAnimation;
  late Animation<Color?> _silverAnimation;
  late Animation<Color?> _bronzeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _goldAnimation = ColorTween(
      begin: const Color(0xFFFFD700),
      end: const Color(0xFFB8860B),
    ).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _silverAnimation = ColorTween(
      begin: const Color(0xFFC0C0C0),
      end: const Color(0xFF708090),
    ).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bronzeAnimation = ColorTween(
      begin: const Color(0xFFCD7F32),
      end: const Color(0xFF8B4513),
    ).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'الطلبة الأوائل - ${widget.department}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.level,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),

          // المركز الأول
          _buildAnimatedRankCard(
            rank: '1',
            name: 'علي حسين محمد',
            averageNumber: '94.8',
            colorAnimation: _goldAnimation,
          ),
          const SizedBox(height: 10),

          // المركز الثاني
          _buildAnimatedRankCard(
            rank: '2',
            name: 'زهراء أحمد كاظم',
            averageNumber: '92.5',
            colorAnimation: _silverAnimation,
          ),
          const SizedBox(height: 10),

          // المركز الثالث
          _buildAnimatedRankCard(
            rank: '3',
            name: 'حيدر عبد الله زكي',
            averageNumber: '90.1',
            colorAnimation: _bronzeAnimation,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAnimatedRankCard({
    required String rank,
    required String name,
    required String averageNumber,
    required Animation<Color?> colorAnimation,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: colorAnimation,
      builder: (context, child) {
        final Color animatedColor = colorAnimation.value ?? Colors.amber;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: animatedColor.withOpacity(isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: animatedColor.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: animatedColor,
                radius: 18,
                child: Text(
                  rank,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // اسم الطالب
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // صياغة النص لمنع الانعكاس تماماً
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'المعدل ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$averageNumber%',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: animatedColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
