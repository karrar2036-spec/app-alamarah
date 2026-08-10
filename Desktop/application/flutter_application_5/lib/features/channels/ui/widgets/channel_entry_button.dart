import 'package:flutter/material.dart';
import 'package:flutter_application_5/features/channels/ui/widgets/branch_selection_dialog.dart';

class ChannelEntryButton extends StatelessWidget {
  final String selectedChannelName;
  final VoidCallback? onCustomTap;

  const ChannelEntryButton({
    super.key,
    required this.selectedChannelName,
    this.onCustomTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD4AF37),
            Color(0xFFAA882E),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onCustomTap ??
              () {
                showDialog(
                  context: context,
                  builder: (context) => BranchSelectionDialog(
                    selectedChannelName: selectedChannelName,
                  ),
                );
              },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'الدخول إلى القناة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
