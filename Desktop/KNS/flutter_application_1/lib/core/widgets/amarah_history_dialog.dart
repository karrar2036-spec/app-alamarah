import 'dart:async';
import 'package:flutter/material.dart';

class AmarahHistoryDialog extends StatefulWidget {
  final double size;
  final Function(Offset)? onPositionChanged;

  const AmarahHistoryDialog({
    super.key,
    this.size = 42.0,
    this.onPositionChanged,
  });

  @override
  State<AmarahHistoryDialog> createState() => _AmarahHistoryDialogState();
}

class _AmarahHistoryDialogState extends State<AmarahHistoryDialog> {
  Timer? _holdTimer;

  // بدء تشغيل المؤقت الدوري كل 5 ثوانٍ عند الضغط
  void _startHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'هل تريد معرفة تاريخي؟ 📜',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFF002366),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  // إيقاف وتصفير المؤقت فور رفع الإصبع
  void _cancelHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  // دالة لعرض نافذة النص التاريخي لميسان
  void _showMisanHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.history_edu, color: Color(0xFFD4AF37)),
              SizedBox(width: 8),
              Text(
                'تاريخ محافظة ميسان',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Text(
                'تُعد محافظة ميسان من المحافظات العراقية ذات التاريخ العريق، إذ يعود تاريخ المنطقة إلى آلاف السنين، وترتبط باسم مملكة ميسان القديمة التي ظهرت في جنوب بلاد الرافدين خلال العصور الهلنستية. وقد اكتسبت المنطقة أهمية كبيرة بسبب موقعها الجغرافي القريب من الخليج العربي ووقوعها بين الأنهار والأهوار، مما جعلها مركزاً مهماً للتجارة والزراعة والنقل.\n\n'
                'ظهرت في المنطقة مملكة ميسان، التي عُرفت في المصادر القديمة باسم مملكة ميسان أو مملكة ميسان البحرية، وكانت من الممالك المهمة في جنوب بلاد الرافدين. واتخذت مدينة شاراكس مركزاً لها، وهي مدينة قديمة ارتبطت بالتجارة والنشاط الاقتصادي في المنطقة، واستفادت من موقع ميسان الذي كان يربط طرق التجارة بين بلاد الرافدين والخليج والمناطق الشرقية. واستمرت أهمية ميسان خلال العصور اللاحقة، وأصبحت المنطقة جزءاً من الحضارات والدول التي تعاقبت على العراق.\n\n'
                'بعد الفتح الإسلامي للعراق، أصبحت منطقة ميسان جزءاً من الدولة الإسلامية، واستمرت أهميتها بسبب موقعها وخصوبة أراضيها وكثرة الأنهار والمسطحات المائية فيها. وكانت مدينة المذار من المدن التاريخية المهمة في المنطقة، كما استمرت الزراعة وتربية الحيوانات وصيد الأسماك من أهم الأنشطة التي مارسها سكانها.\n\n'
                'ومع مرور القرون، تغيرت طبيعة المنطقة بسبب تغير مجاري الأنهار واتساع الأهوار وتراجع بعض المدن القديمة وظهور مراكز سكانية جديدة. وفي العهد العثماني بدأت مدينة العمارة الحديثة بالظهور، حيث تأسست مدينة العمارة سنة 1861م على نهر دجلة، وأصبحت مع مرور الوقت مركزاً إدارياً وتجارياً مهماً في جنوب العراق. وساعد موقعها على نهر دجلة في نموها وازدهار التجارة والنقل النهري والزراعة.\n\n'
                'خلال العهد العثماني أصبحت العمارة مركزاً إدارياً للمنطقة، واستمرت أهميتها بعد تأسيس الدولة العراقية الحديثة سنة 1921م، حيث أصبحت المنطقة تُعرف باسم لواء العمارة، وكانت مدينة العمارة مركز اللواء. وشهدت المنطقة خلال هذه الفترة تطوراً تدريجياً في الإدارة والخدمات والزراعة والتجارة، كما ارتبط اقتصادها بشكل كبير بالأنهار والأراضي الزراعية والأهوار.\n\n'
                'وفي عام 1976م تغير الاسم الإداري من لواء العمارة إلى محافظة ميسان، وذلك إحياءً للاسم التاريخي القديم للمنطقة، وأصبحت مدينة العمارة مركز محافظة ميسان. ومنذ الوقت الحين أصبح اسم ميسان هو الاسم الرسمي للمحافظة، بينما بقيت العمارة المدينة الرئيسية ومركزها الإداري.\n\n'
                'تتميز ميسان بطبيعتها الجغرافية التي تجمع بين نهر دجلة والأراضي الزراعية والأهوار والمناطق الحدودية. وقد لعبت الأهوار دوراً مهماً في تاريخ المحافظة، إذ اعتمد سكانها لقرون طويلة على صيد الأسماك وتربية الجاموس والزراعة وصناعة القوارب، وأصبحت حياة الأهوار جزءاً أساسياً من التراث الاجتماعي والثقافي لسكان ميسان.\n\n'
                'وخلال الحرب العراقية الإيرانية بين عامي 1980 و1988، تأثرت محافظة ميسان بشكل كبير بسبب موقعها الحدودي مع إيران، وشهدت مناطقها الشرقية والحدودية والأهوار عمليات عسكرية واسعة. كما تأثرت المحافظة بالأحداث التي شهدها جنوب العراق بعد عام 1991، وما رافقها من اضطرابات وتغيرات سياسية وأمنية، ثم تعرضت مناطق واسعة من الأهوار في تسعينيات القرن العشرين إلى عمليات تجفيف أدت إلى تغيرات بيئية واجتماعية كبيرة.\n\n'
                'بعد عام 2003 دخلت محافظة ميسان مرحلة جديدة من تاريخها، وشهدت إعادة تنظيم مؤسسات الدولة والإدارة المحلية، كما بدأت مشاريع جديدة في مجالات التعليم والصحة والطرق والخدمات والبنية التحتية. وأصبحت المحافظة أيضاً من المناطق النفطية المهمة في العراق، إذ تحتوي على عدد من الحقول النفطية الكبيرة، ومن أبرزها حقل الحلفاية وحقول البزركان والفكة وأبو غرب، مما جعل النفط أحد أهم مصادر النشاط الاقتصادي في المحافظة.\n\n'
                'وفي السنوات اللاحقة شهدت ميسان اهتماماً متزايداً بإعادة تأهيل الأهوار والحفاظ على بيئتها وتراثها، وأصبحت الأهوار جزءاً مهماً من الهوية السياحية والثقافية للمحافظة. وتتميز ميسان اليوم بتنوعها بين المدن والمناطق الزراعية والأهوار والحقول النفطية والمناطق الحدودية.\n\n'
                'وتُعد مدينة العمارة اليوم مركز محافظة ميسان وأكبر مدنها، وتقع المحافظة في جنوب شرق العراق وتحدها إيران من جهة الشرق. وتمثل ميسان امتداداً لتاريخ طويل بدأ مع مملكة ميسان القديمة، مروراً بالعصور الإسلامية والعثمانية، ثم تأسيس مدينة العمارة الحديثة عام 1861م، وتأسيس الدولة العراقية الحديثة، وصولاً إلى تغيير اسمها إلى محافظة ميسان عام 1976م. ولذلك فإن تاريخ ميسان يجمع بين الحضارة القديمة والتاريخ الإسلامي والعثماني والتاريخ العراقي الحديث، ويجعلها واحدة من المحافظات ذات المكانة التاريخية والجغرافية والاقتصادية المهمة في العراق.',
                style:
                    TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إغلاق',
                style: TextStyle(
                    color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startHoldTimer(),
      onTapUp: (_) => _cancelHoldTimer(),
      onTapCancel: () => _cancelHoldTimer(),
      onPanStart: (_) => _startHoldTimer(),
      onPanEnd: (_) => _cancelHoldTimer(),
      onPanUpdate: (details) {
        if (widget.onPositionChanged != null) {
          widget.onPositionChanged!(details.delta);
        }
      },
      onTap: () {
        _cancelHoldTimer();
        _showMisanHistoryDialog(context);
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: ClipOval(
          child: Image.asset(
            'photo/tesoehan.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported,
              size: 20,
              color: Color(0xFFD4AF37),
            ),
          ),
        ),
      ),
    );
  }
}
