import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateStudyGroupScreen extends StatelessWidget {
  const CreateStudyGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : const Color(0xFFEAF2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create Study Group',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Create group form - To be implemented',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      ),
    );
  }
}
