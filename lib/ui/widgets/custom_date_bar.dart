import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime startDate;
  final DateTime selectedDate;
  final Function(DateTime) onDateChange;

  const CustomDatePicker({
    super.key,
    required this.startDate,
    required this.selectedDate,
    required this.onDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 31,
        itemBuilder: (context, index) {
          final date = startDate.add(Duration(days: index));
          final isSelected = date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          return GestureDetector(
            onTap: () => onDateChange(date),
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? null : white,
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: gradientClr1,
                      )
                    : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: darkGreyClr.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                        )
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MMM').format(date),
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        color: isSelected ? white : primaryClr1,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    date.day.toString(),
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        color: isSelected ? white : primaryClr1,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('E').format(date),
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        color: isSelected ? white : primaryClr1,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
