import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileAvatar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 4.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: Image.asset(
            'photo/1.png',
            width: 36,
            height: 36,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const CircleAvatar(
              backgroundColor: Color(0xFFD4AF37),
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
