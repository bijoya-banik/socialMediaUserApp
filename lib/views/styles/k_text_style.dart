import 'package:flutter/cupertino.dart';

import 'k_colors.dart';

/*
Focus: To maintain app wide design consistency all
the text style that are used in this app should be
declared here.

*Note: In special case: When let's say one title
text or textButton theme needsto be different,
say the color needs to be red instead of Black.
Don't create titleStyle1 (-_-). Just follow this:
Code Snippet:  (Applicable for all styles)
Text(segmentTitle,
style: AppTextStyle.titleStyle.copyWith(color: KColor.red)),
*/

class KTextStyle {
  static TextStyle headline1 = const TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w500,
    letterSpacing: -1.5,
    
  );

  static TextStyle headline2 = const TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w300,
    
  );

  static TextStyle headline3 = const TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    
  );

  static TextStyle headline4 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    
  );

  static TextStyle headline5 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    
  );

  static TextStyle headline7 = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.1,
    
  );

  static TextStyle headline8 = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.1,
    
    // color: KColor.primary,
  );

  static TextStyle subtitle1 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    
    //color: KColor.white
  );

  static TextStyle subtitle2 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    
  );

  static TextStyle bodyText1 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    
  );

  static TextStyle bodyText2 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    
  );

  static TextStyle bodyText3 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    
  );

  static TextStyle bodyText4 = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    
  );

  static TextStyle button = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.04,
    height: 1.6,
    
  );

  static TextStyle textButton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: KColor.primary,
  );

  static TextStyle caption = const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    
  );

  static TextStyle overline = const TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    
  );
} 
 