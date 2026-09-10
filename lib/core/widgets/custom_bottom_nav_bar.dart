import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.55),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: const Color(0xFF38BDF8).withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double itemWidth = totalWidth / 5;

          return Stack(
            alignment: Alignment.centerRight,
            children: [
              // المؤشر المتحرك بتصميم قطرة الماء
              AnimatedPositioned(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOutCubic,
                right: currentIndex * itemWidth + (itemWidth - 52) / 2,
                top: (70 - 44) / 2,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOutCubic,
                  width: 52,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(22),
                      topRight: const Radius.circular(22),
                      bottomLeft:
                          Radius.circular(currentIndex % 2 == 0 ? 28 : 16),
                      bottomRight:
                          Radius.circular(currentIndex % 2 == 0 ? 16 : 28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD4AF37).withOpacity(0.5),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              // أزرار التنقل السفلية
              Row(
                children: [
                  _buildNavItem(Icons.school_outlined, 0, itemWidth),
                  _buildNavItem(Icons.campaign_outlined, 1, itemWidth),
                  _buildNavItem(Icons.article_outlined, 2, itemWidth),
                  _buildNavItem(Icons.grid_view_rounded, 3, itemWidth),
                  _buildNavItem(Icons.person_outline, 4, itemWidth),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, double width) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onItemSelected(index),
      child: SizedBox(
        width: width,
        height: 70,
        child: Center(
          child: AnimatedScale(
            scale: isSelected ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF0F172A)
                  : const Color(0xFF94A3B8),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
