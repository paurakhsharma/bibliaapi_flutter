import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesheep_test/utilities/responsive.dart';

TextStyle kTextStyleAction(context, Color color) => GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: isSmallScreen(context) ? 16: 24,
        color: color,
        letterSpacing: .5,
        fontWeight: FontWeight.w600,
      ),
    );

TextStyle kTextStyleVerse(context) => GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.white,
        letterSpacing: .5,
        fontWeight: isSmallScreen(context) ? FontWeight.w600: FontWeight.normal,
        fontSize: isSmallScreen(context) ? 16: 28,
      ),
    );

TextStyle kTextStyleTitle(context, size) => GoogleFonts.oldStandardTt(
      textStyle: TextStyle(
        color: Colors.white,
        letterSpacing: .5,
        fontWeight: FontWeight.w600,
        fontSize: size,
      ),
    );
