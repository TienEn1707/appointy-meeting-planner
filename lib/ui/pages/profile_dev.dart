import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_app_bar2.dart';
import '../theme.dart';

class ProfileDev extends StatefulWidget {
  const ProfileDev({super.key});

  @override
  State createState() => _ProfileDev();
}

class _ProfileDev extends State<ProfileDev> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
  }

  void _launchURL(String url) async {
    print('Attempting to launch: $url');
    try {
      if (await launchUrl(Uri.parse(url))) {
        print('URL launched successfully');
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  Widget _buildShape(String title, IconData icon, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: shadowClr,
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: primaryClr1),
            const SizedBox(height: 10),
            Text(
              title,
              style: customTextHome1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar2(title: 'Developer Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildShape('Mobile\nDeveloper', Icons.developer_mode_outlined,
                'https://bento.me/christianjs'),
          ],
        ),
      ),
    );
  }
}
