import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'main_layout.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const SplashScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _waveController;
  late AnimationController _blinkController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeIn,
      ),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _blinkAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _blinkController,
        curve: Curves.easeInOut,
      ),
    );

    _entryController.forward();

    Timer(const Duration(milliseconds: 3800), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainLayout(
            onToggleTheme: widget.onToggleTheme,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _waveController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color goldColor = Color(0xFFD4AF37);

    const List<String> words = [
      'جامعة',
      'العمارة',
      'الأهلية',
    ];

    const List<Color> unifiedGradientColors = [
      Color(0xFFFFD700),
      Color(0xFFFFF7C2),
      Color(0xFFD4AF37),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _entryController,
            _waveController,
            _blinkController,
          ]),
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(280, 280),
                                painter: _ExpandingRipplePainter(
                                  animationValue: _waveController.value,
                                  color: goldColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                  border: Border.all(
                                    color: goldColor.withOpacity(
                                      _blinkAnimation.value,
                                    ),
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: goldColor.withOpacity(
                                        _blinkAnimation.value * 0.4,
                                      ),
                                      blurRadius: 25,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'photo/1.png',
                                    width: 115,
                                    height: 115,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.school,
                                        size: 80,
                                        color: goldColor,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          textDirection: TextDirection.rtl,
                          children: List.generate(
                            words.length,
                            (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: unifiedGradientColors,
                                      stops: [0.0, 0.5, 1.0],
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    words[index],
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black45,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'AL-AMARAH UNIVERSITY COLLEGE',
                          style: TextStyle(
                            color: goldColor.withOpacity(0.85),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ExpandingRipplePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _ExpandingRipplePainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    for (int i = 0; i < 3; i++) {
      final double progress = (animationValue + (i * 0.33)) % 1.0;

      final double radius = 70.0 + (progress * 70.0);

      double opacity = (1.0 - progress) * 0.5;

      if (opacity < 0) {
        opacity = 0;
      }

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      const double dashWidth = 10.0;
      const double dashSpace = 12.0;

      final double circumference = 2 * math.pi * radius;

      double currentAngle = 0.0;

      while (currentAngle < circumference) {
        final double startAngle = currentAngle / radius;

        final double sweepAngle = dashWidth / radius;

        canvas.drawArc(
          Rect.fromCircle(
            center: center,
            radius: radius,
          ),
          startAngle,
          sweepAngle,
          false,
          paint,
        );

        currentAngle += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant _ExpandingRipplePainter oldDelegate,
  ) {
    return oldDelegate.animationValue != animationValue;
  }
}
