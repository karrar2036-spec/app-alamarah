import 'package:flutter/material.dart';
import 'package:flutter_application_5/features/channels/ui/widgets/channel_entry_button.dart';
import 'package:flutter_application_5/features/channels/ui/widgets/general_channel_card.dart';
import 'package:flutter_application_5/features/channels/ui/widgets/social_care_channel_card.dart';
import 'package:flutter_application_5/features/channels/ui/widgets/martyrs_channel_card.dart';
import 'package:flutter_application_5/features/channels/ui/widgets/disability_channel_card.dart';
import 'package:flutter_application_5/features/channels/ui/widgets/athletes_channel_card.dart';
import 'package:flutter_application_5/features/channels/ui/widgets/political_prisoners_card.dart';
import 'university_guide_screen.dart';

class ChannelsScreen extends StatefulWidget {
  final String selectedChannel;
  final ValueChanged<String>? onChannelChanged;
  final VoidCallback? onEnterChannel;

  const ChannelsScreen({
    super.key,
    this.selectedChannel = "قناة عامة",
    this.onChannelChanged,
    this.onEnterChannel,
  });

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  late String _currentChannel;

  @override
  void initState() {
    super.initState();
    _currentChannel = widget.selectedChannel;
  }

  void _selectChannel(String channelName) {
    setState(() {
      _currentChannel = channelName;
    });
    if (widget.onChannelChanged != null) {
      widget.onChannelChanged!(channelName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeaderSection(),
          const SizedBox(height: 24),
          const Row(
            children: [
              Icon(
                Icons.broadcast_on_home,
                color: Color(0xFFD4AF37),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'القنوات المتاحة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // شبكة كروت القنوات الخارجية الـ 6
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.3,
            children: [
              GeneralChannelCard(
                channelName: "قناة عامة",
                isSelected: _currentChannel == "قناة عامة",
                onTap: () => _selectChannel("قناة عامة"),
              ),
              SocialCareChannelCard(
                channelName: "قناة الرعاية",
                isSelected: _currentChannel == "قناة الرعاية",
                onTap: () => _selectChannel("قناة الرعاية"),
              ),
              MartyrsChannelCard(
                channelName: "ذوي الشهداء",
                isSelected: _currentChannel == "ذوي الشهداء",
                onTap: () => _selectChannel("ذوي الشهداء"),
              ),
              DisabilityChannelCard(
                channelName: "ذوي الإعاقة",
                isSelected: _currentChannel == "ذوي الإعاقة",
                onTap: () => _selectChannel("ذوي الإعاقة"),
              ),
              AthletesChannelCard(
                channelName: "قناة الأبطال الرياضيين",
                isSelected: _currentChannel == "قناة الأبطال الرياضيين",
                onTap: () => _selectChannel("قناة الأبطال الرياضيين"),
              ),
              PoliticalPrisonersCard(
                channelName: "قناة السجناء السياسيين",
                isSelected: _currentChannel == "قناة السجناء السياسيين",
                onTap: () => _selectChannel("قناة السجناء السياسيين"),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // زر الدخول الموحد المنفصل
          ChannelEntryButton(
            selectedChannelName: _currentChannel,
            onCustomTap: widget.onEnterChannel,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
