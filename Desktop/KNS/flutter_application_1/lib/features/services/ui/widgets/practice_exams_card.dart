import 'package:flutter/material.dart';

void showPracticeExamsDialog(
  BuildContext context,
  Color activeBlueColor,
  Color goldColor,
) {
  String? selectedDepartment;
  String? selectedLevel;
  String? selectedCourse;
  String? selectedSubject;

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
    'هندسة الذكاء الاصطناعي',
    'هندسة تقنيات الأجهزة الطبية',
    'هندسة تقنيات الأمن السيبراني',
  ];

  final List<String> levels = [
    'المرحلة الأولى',
    'المرحلة الثانية',
    'المرحلة الثالثة',
    'المرحلة الرابعة',
  ];

  final List<String> courses = [
    'الكورس الأول',
    'الكورس الثاني',
  ];

  Map<String, List<String>> getSubjectsForCourse(String? course) {
    if (course == 'الكورس الأول') {
      return {
        'الكورس الأول': ['الحاسوب'],
      };
    } else if (course == 'الكورس الثاني') {
      return {
        'الكورس الثاني': ['الرياضيات'],
      };
    }
    return {};
  }

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          final availableSubjects = selectedCourse != null
              ? getSubjectsForCourse(selectedCourse)[selectedCourse] ?? []
              : <String>[];

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.quiz_outlined, color: goldColor),
                const SizedBox(width: 8),
                const Text(
                  'اختبارات امتحانية',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. القسم
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'اختر القسم',
                      prefixIcon: const Icon(Icons.apartment),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: selectedDepartment,
                    items: departments
                        .map(
                          (dept) => DropdownMenuItem(
                            value: dept,
                            child: Text(dept,
                                style: const TextStyle(fontSize: 13)),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setStateDialog(() => selectedDepartment = val),
                  ),
                  const SizedBox(height: 12),

                  // 2. المرحلة
                  DropdownButtonFormField<String>(
                    isExpanded: true,
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
                          (lvl) => DropdownMenuItem(
                            value: lvl,
                            child:
                                Text(lvl, style: const TextStyle(fontSize: 13)),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setStateDialog(() => selectedLevel = val),
                  ),
                  const SizedBox(height: 12),

                  // 3. الكورس
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'اختر الكورس',
                      prefixIcon: const Icon(Icons.class_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: selectedCourse,
                    items: courses
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child:
                                Text(c, style: const TextStyle(fontSize: 13)),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setStateDialog(() {
                        selectedCourse = val;
                        selectedSubject = null;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // 4. المادة
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'اختر المادة',
                      prefixIcon: const Icon(Icons.menu_book),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: selectedSubject,
                    items: availableSubjects
                        .map(
                          (sub) => DropdownMenuItem(
                            value: sub,
                            child:
                                Text(sub, style: const TextStyle(fontSize: 13)),
                          ),
                        )
                        .toList(),
                    onChanged: selectedCourse == null
                        ? null
                        : (val) => setStateDialog(() => selectedSubject = val),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (selectedDepartment != null &&
                      selectedLevel != null &&
                      selectedCourse != null &&
                      selectedSubject != null) {
                    Navigator.pop(dialogContext);

                    List<QuestionModel> examQuestions = [];
                    if (selectedSubject == 'الحاسوب') {
                      examQuestions = _computerQuestions;
                    } else if (selectedSubject == 'الرياضيات') {
                      examQuestions = _mathQuestions;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PracticeExamScreen(
                          department: selectedDepartment!,
                          level: selectedLevel!,
                          course: selectedCourse!,
                          subject: selectedSubject!,
                          questions: examQuestions,
                          goldColor: goldColor,
                          activeBlueColor: activeBlueColor,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى اختيار جميع الحقول أولاً'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('بدء الاختبار',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}

// -------------------------------------------------------------
// نموذج بيانات الأسئلة
// -------------------------------------------------------------
class QuestionModel {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

// 1. أسئلة الكورس الأول (مادة الحاسوب)
final List<QuestionModel> _computerQuestions = [
  QuestionModel(
    question: 'أ) أيٌّ مما يأتي يُعد من المكونات المادية للحاسوب؟',
    options: ['أ) نظام التشغيل', 'ب) لوحة المفاتيح', 'ج) برنامج Word'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'ب) أيٌّ مما يأتي يُعد من البرامج والتطبيقات؟',
    options: ['أ) الشاشة', 'ب) الفأرة', 'ج) نظام التشغيل Windows'],
    correctIndex: 2,
  ),
  QuestionModel(
    question: 'ج) ما المقصود بالمكونات المادية للحاسوب؟',
    options: [
      'أ) البرامج والتطبيقات',
      'ب) الأجزاء المادية التي يمكن لمسها في الحاسوب',
      'ج) الملفات المخزنة في الحاسوب'
    ],
    correctIndex: 1,
  ),
  QuestionModel(
    question:
        'د) أيٌّ مما يأتي يُستخدم لكتابة النصوص ويُعد من الأجزاء المادية؟',
    options: ['أ) لوحة المفاتيح', 'ب) Microsoft Word', 'ج) Windows'],
    correctIndex: 0,
  ),
];

// 2. أسئلة الكورس الثاني (مادة الرياضيات)
final List<QuestionModel> _mathQuestions = [
  QuestionModel(
    question: 'أ) ما هو الناتج عند حساب الدالة (f(x) = x²)؟',
    options: ['أ) x', 'ب) 2x', 'ج) x³'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'ب) ما نتيجة تبسيط المعادلة (f(x) = 3x² + 2x)؟',
    options: ['أ) 6x + 2', 'ب) 3x + 2', 'ج) 6x + 1'],
    correctIndex: 0,
  ),
  QuestionModel(
    question: 'ج) ما القيمة العامة الناتجة من العملية (2x)؟',
    options: ['أ) x² + C', 'ب) 2x² + C', 'ج) x + C'],
    correctIndex: 0,
  ),
  QuestionModel(
    question:
        'د) ما القيمة العددية الناتجة في الفترة المحددة من 0 إلى 2 للمتغير (x)؟',
    options: ['أ) 1', 'ب) 2', 'ج) 4'],
    correctIndex: 1,
  ),
];

// -------------------------------------------------------------
// شاشة أداء وتصحيح الاختبار التفاعلية
// -------------------------------------------------------------
class PracticeExamScreen extends StatefulWidget {
  final String department;
  final String level;
  final String course;
  final String subject;
  final List<QuestionModel> questions;
  final Color goldColor;
  final Color activeBlueColor;

  const PracticeExamScreen({
    super.key,
    required this.department,
    required this.level,
    required this.course,
    required this.subject,
    required this.questions,
    required this.goldColor,
    required this.activeBlueColor,
  });

  @override
  State<PracticeExamScreen> createState() => _PracticeExamScreenState();
}

class _PracticeExamScreenState extends State<PracticeExamScreen> {
  late Map<int, int> selectedAnswers;
  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    selectedAnswers = {};
  }

  int calculateScore() {
    int score = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (selectedAnswers[i] == widget.questions[i].correctIndex) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('اختبار ${widget.subject}'),
          backgroundColor:
              isDark ? Theme.of(context).cardColor : widget.activeBlueColor,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ترويسة تفاصيل الامتحان
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.goldColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.goldColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.department} - ${widget.level}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.course} - مادة: ${widget.subject}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // قائمة الأسئلة
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.questions.length,
                itemBuilder: (context, qIndex) {
                  final q = widget.questions[qIndex];
                  final userChoice = selectedAnswers[qIndex];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSubmitted
                            ? (userChoice == q.correctIndex
                                ? Colors.green
                                : Colors.red.shade300)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'السؤال ${qIndex + 1}: ${q.question}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children:
                                List.generate(q.options.length, (optIndex) {
                              final isSelected = userChoice == optIndex;
                              final isCorrect = q.correctIndex == optIndex;

                              Color tileColor = Colors.transparent;
                              if (isSubmitted) {
                                if (isCorrect) {
                                  tileColor = Colors.green.withOpacity(0.15);
                                } else if (isSelected && !isCorrect) {
                                  tileColor = Colors.red.withOpacity(0.15);
                                }
                              }

                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: tileColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: RadioListTile<int>(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 0),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          q.options[optIndex],
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (isSubmitted && isCorrect)
                                        const Icon(Icons.check_circle,
                                            color: Colors.green, size: 18),
                                      if (isSubmitted &&
                                          isSelected &&
                                          !isCorrect)
                                        const Icon(Icons.cancel,
                                            color: Colors.red, size: 18),
                                    ],
                                  ),
                                  value: optIndex,
                                  groupValue: selectedAnswers[qIndex],
                                  onChanged: isSubmitted
                                      ? null
                                      : (val) {
                                          setState(() {
                                            selectedAnswers[qIndex] = val!;
                                          });
                                        },
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // زر إنهاء وتصحيح الاختبار
              if (!isSubmitted)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.activeBlueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (selectedAnswers.length < widget.questions.length) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'يرجى الإجابة على جميع الأسئلة قبل الإنهاء'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isSubmitted = true;
                      });

                      final score = calculateScore();
                      _showResultDialog(
                          context, score, widget.questions.length);
                    },
                    child: const Text(
                      'إنهاء وتسليم الاختبار',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_outlined, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'تم تسليم الاختبار! الدرجة: ${calculateScore()} من ${widget.questions.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, int score, int total) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              children: [
                Icon(
                  score == total ? Icons.stars : Icons.analytics_outlined,
                  size: 45,
                  color: widget.goldColor,
                ),
                const SizedBox(height: 8),
                const Text(
                  'نتيجة الاختبار',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'حصلت على $score من $total',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  score == total
                      ? 'إجابة ممتازة! أحسنت العمل 👏'
                      : 'يمكنك مراجعة الإجابات الصحيحة والخاطئة الموضحة في الشاشة.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
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
                    'مراجعة الإجابات',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
