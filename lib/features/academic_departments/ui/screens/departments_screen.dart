import 'package:flutter/material.dart';

// استيراد البطاقات من مجلد widgets
import '../widgets/dentistry_card.dart';
import '../widgets/pharmacy_card.dart';
import '../widgets/oil_engineering_card.dart';
import '../widgets/chemical_eng_card.dart';
import '../widgets/ai_engineering_card.dart';
import '../widgets/civil_eng_card.dart';
import '../widgets/mechanics_eng_card.dart';
import '../widgets/security_cyber_card.dart';
import '../widgets/fuel_energy_eng_card.dart';
import '../widgets/electrical_eng_tech_card.dart';
import '../widgets/medical_devices_eng_card.dart';
import '../widgets/accounting_card.dart';
import '../widgets/oil_gas_management_card.dart';
import '../widgets/law_card.dart';
import '../widgets/dental_technique_card.dart';
import '../widgets/anesthesia_technique_card.dart';
import '../widgets/radiology_sonar_card.dart';
import '../widgets/cosmetology_laser_card.dart';
import '../widgets/english_education_card.dart';
import '../widgets/sports_education_card.dart';
import '../widgets/pathological_analysis_card.dart';
import '../widgets/medical_physics_card.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xFFD4AF37),
      end: const Color(0xFF002366),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) => Icon(
              icon,
              size: 20,
              color: _colorAnimation.value,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : const Color(0xFF2C3E50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDepartmentDetails(BuildContext context, Map<String, dynamic> dept) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final bool isDarkMode =
            Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => Icon(
                  Icons.school_rounded,
                  color: _colorAnimation.value,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  dept['name'] as String? ?? '',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : const Color(0xFF002366),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSectionTitle('معلومات الدراسة :'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFF4F6F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.info_outline_rounded,
                          text: dept['studyType'] as String? ?? 'صباحي',
                          isDarkMode: isDarkMode,
                        ),
                        _buildInfoRow(
                          icon: Icons.timer_outlined,
                          text: dept['years'] as String? ?? '4 سنوات',
                          isDarkMode: isDarkMode,
                        ),
                        _buildInfoRow(
                          icon: Icons.school_outlined,
                          text: dept['degree'] as String? ?? 'بكالوريوس',
                          isDarkMode: isDarkMode,
                        ),
                        _buildInfoRow(
                          icon: Icons.menu_book_rounded,
                          text: dept['system'] as String? ?? 'مسار بولونيا',
                          isDarkMode: isDarkMode,
                        ),
                        _buildInfoRow(
                          icon: Icons.monetization_on_outlined,
                          text: "الرسوم السنوية: ${dept['tuition']}",
                          isDarkMode: isDarkMode,
                        ),
                        _buildInfoRow(
                          icon: Icons.payments_outlined,
                          text:
                              "عدد الدفعات: ${dept['installments'] ?? '4 دفعات'}",
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('الرؤية :'),
                  const SizedBox(height: 4),
                  Text(
                    dept['vision'] as String? ?? '',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSectionTitle('الرسالة :'),
                  const SizedBox(height: 4),
                  Text(
                    dept['message'] as String? ?? '',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSectionTitle('الأهداف :'),
                  const SizedBox(height: 4),
                  Text(
                    dept['goals'] as String? ?? '',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'إغلاق',
                style: TextStyle(
                  color: Color(0xFF002366),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF002366),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> departmentCards = [
      DentistryCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      PharmacyCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      OilEngineeringCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      ChemicalEngCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      AiEngineeringCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      CivilEngCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      MechanicsEngCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      SecurityCyberCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      FuelEnergyEngCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      ElectricalEngTechCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      MedicalDevicesEngCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      AccountingCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      OilGasManagementCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      LawCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      DentalTechniqueCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      AnesthesiaTechniqueCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      RadiologySonarCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      CosmetologyLaserCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      EnglishEducationCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      SportsEducationCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      PathologicalAnalysisCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
      MedicalPhysicsCard(
          colorAnimation: _colorAnimation,
          onTap: (data) => _showDepartmentDetails(context, data)),
    ];

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : const Color(0xFF002366),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF002366).withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) => Icon(
                      Icons.school_rounded,
                      size: 24,
                      color: _colorAnimation.value,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'الأقسام الأكاديمية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002366),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 2.0,
              ),
              itemCount: departmentCards.length,
              itemBuilder: (context, index) => departmentCards[index],
            ),
          ),
        ],
      ),
    );
  }
}
