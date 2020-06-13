import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle kTextStyleAction(Color color) => GoogleFonts.lato(
      textStyle: TextStyle(
        color: color,
        letterSpacing: .5,
        fontWeight: FontWeight.w600,
      ),
    );

TextStyle kTextStyleVerse() => GoogleFonts.lato(
      textStyle: TextStyle(
        color: Colors.white,
        letterSpacing: .5,
        fontWeight: FontWeight.w600,
        fontSize: 16,
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
