import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/task_controller.dart';
import '../widgets/custom_app_bar2.dart';
import '../theme.dart';
import 'all_meeting.dart';
import 'how_to_use.dart';
import 'app_info.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isMuted = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMuted = prefs.getBool('isMuted') ?? false;
    });
  }

  _saveSettings(bool value) async {
    await prefs.setBool('isMuted', value);
    Get.find<TaskController>().setMuted(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar2(
        title: 'Settings',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        children: [
          _buildCard(_buildSwitchListTile()),
          _buildCard(_buildListTile('All meetings', 'assets/images/icon_images/activity_icon.svg',
              () async {
            await Get.to(() => const AllMeetingPage());
          })),
          _buildCard(_buildListTile('How to use', 'assets/images/icon_images/question_icon.svg',
              () async {
            await Get.to(() => const HowToUsePage());
          })),
          _buildCard(
              _buildListTile('App info', 'assets/images/icon_images/info_icon.svg', () async {
            await Get.to(() => const AppInfoPage());
          })),
        ],
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: ShapeDecoration(
        color: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: shadowClr,
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSwitchListTile() {
    return ListTile(
      title: Text('Mute bell ring', style: customTextHome2),
      leading: SvgPicture.asset(
        _isMuted ? 'assets/images/icon_images/mute_icon.svg' : 'assets/images/icon_images/un_mute_icon.svg',
        color: primaryClr1,
        width: 24,
        height: 24,
      ),
      trailing: Switch(
        value: _isMuted,
        onChanged: (value) {
          setState(() {
            _isMuted = value;
          });
          _saveSettings(value);
        },
        activeTrackColor: Colors.green,
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return white;
          }
          return darkGreyClr.withOpacity(0.6);
        }),
      ),
    );
  }

  Widget _buildListTile(String title, String svgPath, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: customTextHome2),
      leading: SvgPicture.asset(
        svgPath,
        color: primaryClr1,
        width: 24,
        height: 24,
      ),
      trailing: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationZ(3.14159),
        child: SvgPicture.asset(
          'assets/images/icon_images/back_icon.svg',
          color: primaryClr1,
          width: 24,
          height: 24,
        ),
      ),
      onTap: onTap,
    );
  }
}
