import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/student_complaints_card.dart';
import '../widgets/tech_support_card.dart';
import '../widgets/app_feedback_card.dart';
import '../widgets/language_selector_card.dart';
import '../widgets/about_university_card.dart';
import '../widgets/notifications_card.dart';
import '../widgets/student_notes_card.dart';
import '../widgets/weekly_schedule_card.dart';
import '../widgets/exam_schedule_card.dart';
import '../widgets/academic_subjects_card.dart';
import '../widgets/ministry_apps_card.dart';
import '../widgets/contact_university_card.dart';
import '../widgets/professor_evaluation_card.dart';
import '../widgets/top_students_card.dart';
import '../widgets/about_app_card.dart';
import '../widgets/registration_dept_card.dart';
import '../widgets/student_tuition_card.dart';
import '../widgets/practice_exams_card.dart';
import '../widgets/exam_halls_card.dart';
import '../widgets/electronic_library_card.dart';
import '../widgets/graduation_dates_card.dart'; // استيراد ملف مواعيد حفلات التخرج

class ServicesScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final bool isDarkMode;

  const ServicesScreen({
    super.key,
    this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  final Color goldColor = const Color(0xFFD4AF37);
  final Color royalBlueColor = const Color(0xFF002366);

  String _selectedLanguage = 'العربية';

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

  final List<String> studyTypes = [
    'صباحي',
    'مسائي',
  ];

  final List<String> sections = [
    'A',
    'B',
    'C',
    'D',
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
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

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح الرابط'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openUniversityLocation() async {
    await _launchURL(
      'https://www.google.com/maps?ll=31.88562,47.10994&z=13&t=m&hl=ar-IQ&gl=US&mapclient=embed&cid=3629837595474568579',
    );
  }

  void _showSelectionDialog(
    BuildContext context, {
    required bool isExam,
  }) {
    String? selectedDepartment;
    String? selectedLevel;
    String? selectedStudyType;
    String? selectedSection;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color subtitleColor = isDark ? Colors.white70 : Colors.grey.shade700;

    final Color primaryButtonColor = isDark ? goldColor : royalBlueColor;

    final Color buttonTextColor = isDark ? Colors.black : Colors.white;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setStateDialog,
          ) {
            return AlertDialog(
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(
                    isExam ? Icons.assignment_outlined : Icons.calendar_month,
                    color: goldColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isExam ? 'الجداول الامتحانية' : 'الجدول الأسبوعي',
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
                      'الرجاء حدد تفاصيل القسم للوصول للجدول:',
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
                        prefixIcon: const Icon(
                          Icons.school_outlined,
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
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
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
                        prefixIcon: const Icon(
                          Icons.format_list_numbered,
                        ),
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
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
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
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      dropdownColor: Theme.of(context).cardColor,
                      decoration: InputDecoration(
                        labelText: 'نوع الدراسة',
                        prefixIcon: const Icon(
                          Icons.wb_sunny_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: selectedStudyType,
                      items: studyTypes
                          .map(
                            (type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedStudyType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      dropdownColor: Theme.of(context).cardColor,
                      decoration: InputDecoration(
                        labelText: 'اختر الشعبة',
                        prefixIcon: const Icon(
                          Icons.groups_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: selectedSection,
                      items: sections
                          .map(
                            (section) => DropdownMenuItem<String>(
                              value: 'شعبة $section',
                              child: Text(
                                'شعبة $section',
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedSection = value;
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
                    style: TextStyle(
                      color: subtitleColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryButtonColor,
                    foregroundColor: buttonTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (selectedDepartment != null &&
                        selectedLevel != null &&
                        selectedStudyType != null &&
                        selectedSection != null) {
                      Navigator.pop(dialogContext);

                      if (isExam) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExamScheduleScreen(
                              department: selectedDepartment!,
                              level: selectedLevel!,
                              studyType: selectedStudyType!,
                              section: selectedSection!,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WeeklyScheduleScreen(
                              department: selectedDepartment!,
                              level: selectedLevel!,
                              studyType: selectedStudyType!,
                              section: selectedSection!,
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'يرجى إكمال جميع الاختيارات',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'عرض الجدول',
                    style: TextStyle(
                      color: buttonTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSubjectsDialog(BuildContext context) {
    String? selectedDepartment;
    String? selectedLevel;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color subtitleColor = isDark ? Colors.white70 : Colors.grey.shade700;

    final Color primaryButtonColor = isDark ? goldColor : royalBlueColor;

    final Color buttonTextColor = isDark ? Colors.black : Colors.white;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setStateDialog,
          ) {
            return AlertDialog(
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              title: const Text('المواد الدراسية'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'اختر القسم والمرحلة لعرض المواد:',
                      style: TextStyle(
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      dropdownColor: Theme.of(context).cardColor,
                      decoration: const InputDecoration(
                        labelText: 'اختر القسم',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedDepartment,
                      items: departments
                          .map(
                            (dept) => DropdownMenuItem<String>(
                              value: dept,
                              child: Text(dept),
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
                      decoration: const InputDecoration(
                        labelText: 'اختر المرحلة',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedLevel,
                      items: levels
                          .map(
                            (level) => DropdownMenuItem<String>(
                              value: level,
                              child: Text(level),
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
                    style: TextStyle(
                      color: subtitleColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryButtonColor,
                    foregroundColor: buttonTextColor,
                  ),
                  onPressed: () {
                    if (selectedDepartment != null && selectedLevel != null) {
                      Navigator.pop(dialogContext);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubjectsListScreen(
                            department: selectedDepartment!,
                            level: selectedLevel!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'يرجى تحديد القسم والمرحلة',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'عرض المواد',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    final Color textColor = Theme.of(context).textTheme.bodyLarge?.color ??
        (isDark ? Colors.white : Colors.black);

    final Color activeBlueColor =
        isDark ? const Color(0xFF60A5FA) : royalBlueColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: goldColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(55),
                    border: Border.all(
                      color: goldColor,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'photo/1.png',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return CircleAvatar(
                          radius: 45,
                          backgroundColor: goldColor,
                          child: const Icon(
                            Icons.apartment,
                            size: 50,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'جامعة العمارة الاهلية',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                Icons.dashboard_outlined,
                color: goldColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'خدمات الجامعة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              // --- 1. قسم التسجيل ---
              _buildAnimatedServiceCard(
                context,
                title: 'قسم التسجيل',
                icon: Icons.app_registration_outlined,
                onTap: () => showRegistrationDeptDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              // --- 2. قسط الطالب ---
              _buildAnimatedServiceCard(
                context,
                title: 'قسط الطالب',
                icon: Icons.payments_outlined,
                onTap: () => showStudentTuitionDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              // --- 3. قاعات امتحانية ---
              _buildAnimatedServiceCard(
                context,
                title: 'قاعات امتحانية',
                icon: Icons.meeting_room_outlined,
                onTap: () => showExamHallsDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              // --- 4. المكتبة الإلكترونية ---
              _buildAnimatedServiceCard(
                context,
                title: 'المكتبة الإلكترونية',
                icon: Icons.local_library_outlined,
                onTap: () => showElectronicLibraryDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              // --- بقية الخدمات ---
              _buildAnimatedServiceCard(
                context,
                title: 'تقييم الأساتذة',
                icon: Icons.rate_review,
                onTap: () => showProfessorEvaluationDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'الطلبة الأوائل',
                icon: Icons.workspace_premium,
                onTap: () => showTopStudentsDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'الجداول الاسبوعية',
                icon: Icons.calendar_month,
                onTap: () => _showSelectionDialog(
                  context,
                  isExam: false,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'الجداول الامتحانية',
                icon: Icons.assignment_outlined,
                onTap: () => _showSelectionDialog(
                  context,
                  isExam: true,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'الشكاوى الطلابية',
                icon: Icons.report_problem_outlined,
                onTap: () => showStudentComplaintDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'اختبارات امتحانية',
                icon: Icons.quiz_outlined,
                onTap: () => showPracticeExamsDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'مواعيد حفلات التخرج',
                icon: Icons.school,
                onTap: () => showGraduationDatesDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'المواد الدراسية',
                icon: Icons.menu_book,
                onTap: () => _showSubjectsDialog(context),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'التنبيهات',
                icon: Icons.notifications_active_outlined,
                onTap: () => showNotificationsDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'ملاحظات',
                icon: Icons.note_alt_outlined,
                onTap: () => showNotesDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'حول الجامعة',
                icon: Icons.school_outlined,
                onTap: () => showAboutUniversityDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'موقع الجامعة',
                icon: Icons.location_on_outlined,
                onTap: _openUniversityLocation,
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'التطبيقات الوزارية',
                icon: Icons.apps,
                onTap: () => showMinisterialAppsDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'تواصل مع الجامعة',
                icon: Icons.phone_in_talk_outlined,
                onTap: () => showUniversityContactDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'ملاحظات حول التطبيق',
                icon: Icons.rate_review_outlined,
                onTap: () => showAppFeedbackDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'الدعم الفني',
                icon: Icons.headset_mic_outlined,
                onTap: () => showTechnicalSupportDialog(
                  context,
                  activeBlueColor,
                  goldColor,
                ),
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'حول التطبيق',
                icon: Icons.info_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutAppScreen(),
                    ),
                  );
                },
              ),
              _buildAnimatedServiceCard(
                context,
                title: 'اللغة ($_selectedLanguage)',
                icon: Icons.translate,
                onTap: () async {
                  final lang = await showLanguageDialog(
                    context,
                    activeBlueColor,
                    goldColor,
                    _selectedLanguage,
                  );

                  if (lang != null && mounted) {
                    setState(() {
                      _selectedLanguage = lang;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: widget.onToggleTheme,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: isDark ? const Color(0xFFFDE047) : goldColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isDark ? 'الوضع الداكن مفعل' : 'الوضع الفاتح مفعل',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (_) {
                      widget.onToggleTheme?.call();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: borderColor),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'تابعنا على منصات التواصل الاجتماعي',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
                label: 'فيسبوك',
                onTap: () => _launchURL(
                  'https://www.facebook.com/share/1BedujDguC/',
                ),
              ),
              const SizedBox(width: 16),
              _buildSocialButton(
                icon: Icons.camera_alt,
                color: const Color(0xFFE4405F),
                label: 'إنستغرام',
                onTap: () => _launchURL(
                  'https://www.instagram.com/alamarahuc',
                ),
              ),
              const SizedBox(width: 16),
              _buildSocialButton(
                icon: Icons.send,
                color: const Color(0xFF229ED9),
                label: 'تليغرام',
                onTap: () => _launchURL(
                  'https://t.me/alamarhuc',
                ),
              ),
              const SizedBox(width: 16),
              _buildSocialButton(
                icon: Icons.music_note,
                color: isDark ? Colors.white : Colors.black,
                label: 'تيك توك',
                onTap: () => _launchURL(
                  'https://www.tiktok.com/@alamarahuc',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAnimatedServiceCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    final Color textColor = Theme.of(context).textTheme.bodyMedium?.color ??
        (isDark ? Colors.white : Colors.black);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return Icon(
                  icon,
                  color: _colorAnimation.value,
                  size: 20,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 26,
        ),
      ),
    );
  }
}
