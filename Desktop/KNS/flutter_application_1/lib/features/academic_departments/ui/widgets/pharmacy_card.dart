import 'package:flutter/material.dart';

class PharmacyCard extends StatelessWidget {
  final Animation<Color?> colorAnimation;
  final ValueChanged<Map<String, dynamic>> onTap;

  const PharmacyCard({
    super.key,
    required this.colorAnimation,
    required this.onTap,
  });

  static const Map<String, dynamic> data = {
    "name": "الصيدلة",
    "icon": Icons.local_pharmacy,
    "studyType": "صباحي",
    "years": "5 سنوات",
    "degree": "بكالوريوس",
    "system": "فصلي",
    "tuition": "null",
    "installments": "4 دفعات",
    "vision":
        "التميز في التعليم الصيدلاني والبحث العلمي والخدمات الدوائية على مستوى العراق.",
    "message":
        "تخريج صيادلة يمتلكون المعرفة العلمية والمهارات المهنية للتعامل الفعال مع الأدوية والرعاية الصحية.",
    "goals":
        "1. فهم خصائص المركبات الدوائية وتصنيعها.\n2. تعزيز الدور السريري للصيدلاني في الفريق الصحي.\n3. دعم الأبحاث الدوائية المبتكرة."
  };

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => onTap(data),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF002366).withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: colorAnimation,
                builder: (context, child) => Icon(
                  data['icon'] as IconData,
                  size: 22,
                  color: colorAnimation.value,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data['name'] as String,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white70 : const Color(0xFF002366),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}