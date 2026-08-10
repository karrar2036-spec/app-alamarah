import 'dart:async';

import 'package:flutter/material.dart';

import '../../features/academic_departments/ui/screens/departments_screen.dart';
import '../../features/news_and_achievements/ui/screens/news_screen.dart';
import '../../features/student_posts/ui/screens/student_posts_screen.dart';
import '../../features/channels/ui/screens/channels_screen.dart';
import '../../features/services/ui/screens/services_screen.dart';

import 'amarah_history_dialog.dart';
import 'ai_chat_dialog.dart';
import 'custom_bottom_nav_bar.dart';

class MainLayout extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const MainLayout({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 3;

  Offset? _offset;

  final double _buttonSize = 49.0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const DepartmentsScreen(),
      const NewsScreen(),
      const StudentPostsScreen(),
      const ChannelsScreen(),
      ServicesScreen(
        onToggleTheme: widget.onToggleTheme,
        isDarkMode: widget.isDarkMode,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const double topBarHeight = 56.0;

              _offset ??= Offset(
                constraints.maxWidth - (_buttonSize + 210.0),
                (topBarHeight - _buttonSize) / 2,
              );

              final double minX = 0;
              final double maxX = constraints.maxWidth - _buttonSize;

              final double minY = 0;
              final double maxY = constraints.maxHeight - _buttonSize;

              return Stack(
                children: [
                  Positioned.fill(
                    top: topBarHeight,
                    child: IndexedStack(
                      index: _currentIndex,
                      children: _screens,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: topBarHeight,
                    child: Container(
                      color: Theme.of(context).appBarTheme.backgroundColor ??
                          Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                            ),
                            onPressed: () {
                              setState(() {
                                _currentIndex = 3;
                              });
                            },
                          ),
                          const Spacer(),
                          SizedBox(
                            width: _buttonSize + 8,
                          ),
                          const AmarahHistoryDialog(),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIndex = 4;
                              });
                            },
                            child: const CircleAvatar(
                              backgroundImage: AssetImage('photo/1.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: _offset!.dx.clamp(
                      minX,
                      maxX,
                    ),
                    top: _offset!.dy.clamp(
                      minY,
                      maxY,
                    ),
                    child: DraggableChatAvatar(
                      size: _buttonSize,
                      onPositionChanged: (delta) {
                        setState(() {
                          final double newX =
                              (_offset!.dx + delta.dx).clamp(minX, maxX);

                          final double newY =
                              (_offset!.dy + delta.dy).clamp(minY, maxY);

                          _offset = Offset(
                            newX,
                            newY,
                          );
                        });
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AiChatDialog(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

// =====================================================
// الأيقونة العائمة للمحادثة
// =====================================================

class DraggableChatAvatar extends StatefulWidget {
  final double size;
  final Function(Offset) onPositionChanged;
  final VoidCallback onTap;

  const DraggableChatAvatar({
    super.key,
    this.size = 49.0,
    required this.onPositionChanged,
    required this.onTap,
  });

  @override
  State<DraggableChatAvatar> createState() => _DraggableChatAvatarState();
}

class _DraggableChatAvatarState extends State<DraggableChatAvatar> {
  Timer? _holdTimer;

  void _startHoldTimer() {
    _cancelHoldTimer();

    _holdTimer = Timer(
      const Duration(seconds: 5),
      () {
        if (!mounted) return;

        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'ختنكت 😅',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
      },
    );
  }

  void _cancelHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  @override
  void dispose() {
    _cancelHoldTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startHoldTimer(),
      onTapUp: (_) => _cancelHoldTimer(),
      onTapCancel: _cancelHoldTimer,
      onPanStart: (_) => _startHoldTimer(),
      onPanEnd: (_) => _cancelHoldTimer(),
      onPanCancel: _cancelHoldTimer,
      onPanUpdate: (details) {
        widget.onPositionChanged(
          details.delta,
        );
      },
      onTap: () {
        _cancelHoldTimer();
        widget.onTap();
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: ClipOval(
          child: Image.asset(
            'photo/chat.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.chat,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
