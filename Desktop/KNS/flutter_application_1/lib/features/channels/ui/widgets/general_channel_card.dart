import 'package:flutter/material.dart';

class GeneralChannelCard extends StatelessWidget {
  final String channelName;
  final bool isSelected;
  final VoidCallback onTap;

  const GeneralChannelCard({
    super.key,
    this.channelName = "قناة عامة",
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _CircularChannelWidget(
      channelName: channelName,
      icon: Icons.public,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}

class _CircularChannelWidget extends StatefulWidget {
  final String channelName;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CircularChannelWidget({
    required this.channelName,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CircularChannelWidget> createState() => _CircularChannelWidgetState();
}

class _CircularChannelWidgetState extends State<_CircularChannelWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color getTextColor() {
      if (widget.isSelected || isHovered) {
        return const Color(0xFF004085);
      } else {
        return const Color(0xFF002366);
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (widget.isSelected || isHovered)
                ? const Color(0xFF002366).withOpacity(0.12)
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: (widget.isSelected || isHovered)
                    ? const Color(0xFF002366).withOpacity(0.15)
                    : Colors.black.withOpacity(0.04),
                blurRadius: (widget.isSelected || isHovered) ? 8 : 2,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: (widget.isSelected || isHovered)
                  ? const Color(0xFFD4AF37)
                  : Colors.grey.withOpacity(0.15),
              width: widget.isSelected ? 2.0 : 1.0,
            ),
          ),
          padding: const EdgeInsets.all(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isSelected
                  ? _BlinkingIcon(icon: widget.icon)
                  : Icon(
                      widget.icon,
                      size: 18,
                      color: isHovered
                          ? const Color(0xFF002366)
                          : const Color(0xFFD4AF37),
                    ),
              const SizedBox(height: 2),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    widget.channelName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: (widget.isSelected || isHovered)
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: getTextColor(),
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlinkingIcon extends StatefulWidget {
  final IconData icon;
  const _BlinkingIcon({required this.icon});

  @override
  State<_BlinkingIcon> createState() => _BlinkingIconState();
}

class _BlinkingIconState extends State<_BlinkingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);

    _animation = ColorTween(
      begin: const Color(0xFF002366),
      end: const Color(0xFFD4AF37),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Icon(
          widget.icon,
          size: 18,
          color: _animation.value,
        );
      },
    );
  }
}
