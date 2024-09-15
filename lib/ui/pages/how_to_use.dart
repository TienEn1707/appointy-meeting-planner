import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/custom_app_bar2.dart';
import '../theme.dart';

class HowToUsePage extends StatefulWidget {
  const HowToUsePage({super.key});

  @override
  State createState() => _HowToUsePageState();
}

class _HowToUsePageState extends State<HowToUsePage> {
  int? _expandedCardIndex; // Menyimpan indeks kartu yang terbuka

  final List<HowToUseCard> cards = [
    HowToUseCard(
      title: 'How to add company',
      contents: [
        HowToUseStep(
            '1. Press the "+ Add" button located at the bottom of the homepage.',
            'assets/images/howtouse_images/htu_add_button.png'),
        HowToUseStep(
            '2. Choose add company.', 'assets/images/howtouse_images/htu_menu_option.png'),
        HowToUseStep(
            '3. Fill the column and press “Add Company” to save the company.',
            'assets/images/howtouse_images/htu_add_company.png'),
      ],
    ),
    HowToUseCard(
      title: 'How to set a new meeting',
      contents: [
        HowToUseStep(
            '1. Press the "+ Add" button located at the bottom of the homepage.',
            'assets/images/howtouse_images/htu_add_button.png'),
        HowToUseStep(
            '2. Choose add meeting.', 'assets/images/howtouse_images/htu_menu_option.png'),
        HowToUseStep(
            '3. Fill the columns and press “Add Meeting” to save the new meeting.',
            'assets/images/howtouse_images/htu_add_meeting.png'),
      ],
    ),
    HowToUseCard(
      title: 'How to edit a meeting',
      contents: [
        HowToUseStep('1. Press the meeting you want to edit.',
            'assets/images/howtouse_images/htu_meeting_activity.png'),
        HowToUseStep('2. Choose edit meeting.',
            'assets/images/howtouse_images/htu_menu_option2.png'),
      ],
    ),
    HowToUseCard(
      title: 'How to delete a meeting',
      contents: [
        HowToUseStep('1. Press the meeting you want to delete.',
            'assets/images/howtouse_images/htu_meeting_activity.png'),
        HowToUseStep('2. Choose delete meeting.',
            'assets/images/howtouse_images/htu_menu_option2.png'),
      ],
    ),
    HowToUseCard(
      title: 'How to view all meetings',
      contents: [
        HowToUseStep(
            '1. Press setting button located at the top of the homepage.',
            'assets/images/howtouse_images/htu_setting.png'),
        HowToUseStep('2. Choose “All meetings”.',
            'assets/images/howtouse_images/htu_setting_page.png'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar2(title: 'How to Use'),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        itemCount: cards.length,
        itemBuilder: (context, index) => ExpandableCard(
          card: cards[index],
          isExpanded: _expandedCardIndex == index,
          onTap: () {
            setState(() {
              // Jika kartu yang sama diklik lagi, tutup kartu, jika tidak buka kartu tersebut
              _expandedCardIndex = _expandedCardIndex == index ? null : index;
            });
          },
        ),
      ),
    );
  }
}

class HowToUseCard {
  final String title;
  final List<HowToUseStep> contents;

  HowToUseCard({required this.title, required this.contents});
}

class HowToUseStep {
  final String text;
  final String imagePath;

  HowToUseStep(this.text, this.imagePath);
}

class ExpandableCard extends StatefulWidget {
  final HowToUseCard card;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableCard({
    super.key,
    required this.card,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: ShapeDecoration(
        color: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadows: const [
          BoxShadow(color: shadowClr, blurRadius: 6, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.card.title,
                style: customTextCompany.copyWith(letterSpacing: -1.0)),
            trailing: AnimatedRotation(
              turns: widget.isExpanded ? 0.25 : -0.25,
              duration: const Duration(milliseconds: 300),
              child: SvgPicture.asset('assets/images/icon_images/back_icon.svg',
                  color: primaryClr1, width: 24, height: 24),
            ),
            onTap: widget.onTap,
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: _buildExpandedContent(),
            crossFadeState: widget.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.card.contents.map((step) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(step.text, style: subHomeStyle.copyWith(color: darkGreyClr)),
              const SizedBox(height: 8),
              Image.asset(step.imagePath,
                  width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
