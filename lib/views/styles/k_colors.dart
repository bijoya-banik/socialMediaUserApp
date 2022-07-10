import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/material.dart';

/*
Focus: To maintain app wide design consistency all
the colors that are used in this app should be declared here.
*/

class KColor extends ChangeNotifier {
  static setLight() {
    primary = const Color(0xFF2374E1);
    secondary = Colors.white;
    darkAppBackground = const Color(0xFFF7F7F9);
    appBackground = const Color(0xFFF7F7F9);
    textBackground = Colors.white;
    appThemeColor = primary;
    storyColorLeft = const Color(0xFF6e48aa);
    storyColorRight = const Color(0xFF9d50bb);
    divineTheme = const Color(0xFF34465d);
    appBarTitle = Colors.black;
    errorRedText = const Color(0xFFEF6061);
    timeGreyText = const Color(0xFFA1A6AB);
    buttonBackground = primary;
    shadowColor = const Color.fromRGBO(0, 0, 0, 0.04);
    facebookLogoColor = const Color.fromRGBO(59, 87, 157, 1);
    twitterLogoColor = const Color.fromRGBO(85, 172, 238, 1);
    youtubeLogoColor = const Color.fromRGBO(230, 33, 23, 1);
    instagramLogoColor = const Color.fromRGBO(63, 114, 155, 1);
    linkedinLogoColor = const Color.fromRGBO(26, 132, 188, 1);
    adobeLogoColor = const Color(0xFFF40F02);
    progressBlue = const Color(0xFF2d8cf0);
    seenGreen = const Color(0xFF5FCF7F);
    logoGreen = const Color(0xFF8DB600);
    closeText = Colors.black54;
    menuTitle = const Color(0x0091959b);
    feedActionButton = const Color(0xFF65676b);
    feedActionCircle = AppMode.darkMode ? const Color(0xFF353C48) : const Color(0xFFF0F2F5);
    lovePink = primary;
    black = Colors.black;
    black87 = Colors.black87;
    black38 = Colors.black38;
    black26 = Colors.black26;
    black45 = Colors.black45;
    black54 = Colors.black54;
    white = Colors.white;
    white54 = Colors.white54;
    white70 = Colors.white70;
    grey = Colors.grey;
    grey50 = Colors.grey[50];
    grey100 = Colors.grey[100];
    grey200 = Colors.grey[200];
    grey350 = Colors.grey[350];
    grey300 = Colors.grey[300];
    grey400 = Colors.grey[400];
    grey600 = Colors.grey[600];
    grey700 = Colors.grey[700];
    grey800 = Colors.grey[800];
    grey850 = Colors.grey[850];
    grey900 = Colors.grey[900];
    blue = Colors.blue;
    blue800 = Colors.blue[800];
    green = Colors.green;
    red = Colors.red;
    red900 = Colors.red[900];
    transparent = Colors.transparent;
    cyan = Colors.cyan;
  }

  static setDark() {
    primary = const Color(0xFF2374E1);
    secondary = const Color(0xFF1e1e1e);
    darkAppBackground = Colors.black;
    appBackground = const Color(0xFF1e1e1e);
    textBackground = const Color(0xFF1e1e1e);
    appThemeColor = primary;
    storyColorLeft = const Color(0xFF6e48aa);
    storyColorRight = const Color(0xFF9d50bb);
    divineTheme = const Color(0xFF34465d);
    appBarTitle = Colors.white;
    errorRedText = const Color(0xFFEF6061);
    timeGreyText = const Color(0xFFA1A6AB);
    buttonBackground = primary;
    shadowColor = const Color.fromRGBO(0, 0, 0, 0.04);
    facebookLogoColor = const Color.fromRGBO(59, 87, 157, 1);
    twitterLogoColor = const Color.fromRGBO(85, 172, 238, 1);
    youtubeLogoColor = const Color.fromRGBO(230, 33, 23, 1);
    instagramLogoColor = const Color.fromRGBO(63, 114, 155, 1);
    linkedinLogoColor = const Color.fromRGBO(26, 132, 188, 1);
    adobeLogoColor = const Color(0xFFF40F02);
    progressBlue = const Color(0xFF2d8cf0);
    seenGreen = const Color(0xFF5FCF7F);
    logoGreen = const Color(0xFF8DB600);
    closeText = Colors.white60;
    menuTitle = const Color(0x0091959b);
    feedActionButton = const Color(0xFF65676b);
    feedActionCircle = const Color(0xFF353C48);
    lovePink = primary;
    black = Colors.white;
    black87 = Colors.white70;
    black38 = Colors.white38;
    black26 = Colors.white24;
    black45 = Colors.white60;
    black54 = Colors.white54;
    white = Colors.black;
    white54 = Colors.black54;
    white70 = Colors.black87;
    grey = Colors.grey;
    grey50 = Colors.grey[50];
    grey100 = Colors.black;
    grey200 = Colors.grey[200];
    grey350 = Colors.grey[350];
    grey300 = Colors.grey[300];
    grey400 = Colors.grey[400];
    grey600 = Colors.grey[600];
    grey700 = Colors.grey[700];
    grey800 = Colors.grey[800];
    grey850 = Colors.grey[850];
    grey900 = Colors.grey[900];
    blue = Colors.blue;
    blue800 = Colors.blue[800];
    green = Colors.green;
    red = Colors.red;
    red900 = Colors.red[900];
    transparent = Colors.transparent;
    cyan = Colors.cyan;
  }

  /// const color
  static const Color buttonBackgroundConst = Color(0xFF2374E1) /* Color(0xFF01bb7f) */;
  static const Color whiteConst = Colors.white;
  static const Color appThemeColorConst = Color(0xFF2374E1);
  static const Color blackConst = Colors.black;
  static const Color black87Const = Colors.black87;
  static const Color black54Const = Colors.black54;
  static const Color white54Const = Colors.white54;
  static const Color greyconst = Colors.grey;
  static Color? grey900const = Colors.grey[900];
  static Color? grey850const = Colors.grey[850];
  static Color? grey800const = Colors.grey[800];
  static Color? grey600const = Colors.grey[600];
  static Color? grey350const = Colors.grey[350];
  static Color? grey200const = Colors.grey[200];
  static Color? grey100const = Colors.grey[100];

  /*
  primary theme color
  */
  static Color primary = const Color(0xFF2374E1) /* AppMode.CONNECTIVER ? Color(0xFF01bb7f) : Color(0xFF34465d) */;
  static Color secondary = Colors.white;

  /*
  app background color              
  */
  static Color appBackground = const Color(0xFFF7F7F9);
  static Color appThemeColor = primary;
  static Color storyColorLeft = const Color(0xFF6e48aa);
  static Color storyColorRight = const Color(0xFF9d50bb);
  static Color divineTheme = const Color(0xFF34465d);
  static Color textBackground = Colors.white;
  static Color darkAppBackground = KColor.black;

  /*
  app bar bg, title text color 
  */
  static Color appBarTitle = Colors.black;

  /*
  error red text color 
  */
  static Color errorRedText = const Color(0xFFEF6061);

  /*
  time grey text color 
  */
  static Color timeGreyText = const Color(0xFFA1A6AB);

  /*
  button banckground color e10600
  */
  static Color buttonBackground = primary /* Color(0xFF01bb7f) */;

  /*
  app shadows color 
  */
  static Color shadowColor = const Color.fromRGBO(0, 0, 0, 0.04);

  static Color facebookLogoColor = const Color.fromRGBO(59, 87, 157, 1);
  static Color twitterLogoColor = const Color.fromRGBO(85, 172, 238, 1);
  static Color youtubeLogoColor = const Color.fromRGBO(230, 33, 23, 1);
  static Color instagramLogoColor = const Color.fromRGBO(63, 114, 155, 1);
  static Color linkedinLogoColor = const Color.fromRGBO(26, 132, 188, 1);
  static Color adobeLogoColor = const Color(0xFFF40F02);

  static Color progressBlue = const Color(0xFF2d8cf0);
  static Color seenGreen = const Color(0xFF5FCF7F);
  static Color logoGreen = const Color(0xFF8DB600);
  static Color closeText = Colors.white60;
  static Color menuTitle = const Color(0x0091959b);

  static Color feedActionButton = const Color(0xFF65676b);
  static Color feedActionCircle = AppMode.darkMode ? const Color(0xFF353C48) : const Color(0xFFF0F2F5);
  static Color lovePink = primary;

  static Color reactionBlue = const Color(0xff3b5998);
  static Color reactionYellow = const Color(0xffDAA520);
  static Color reactionOrange = const Color(0XFFed5168);

  /*
  normal color
  */
  // static const Color black = Colors.white;
  // static Color black87 = Colors.white54;
  // static Color black38 = Colors.white54;
  // static Color black54 = Colors.white54;
  // static const Color white = Colors.black;
  // static Color white54 = Colors.black54;

  static Color black = Colors.black;
  static Color black87 = Colors.black87;
  static Color black38 = Colors.black38;
  static Color black26 = Colors.black26;
  static Color black45 = Colors.black45;
  static Color black54 = Colors.black54;
  static Color white = Colors.white;
  static Color white54 = Colors.white54;
  static Color white70 = Colors.white70;
  static Color grey = Colors.grey;
  static Color? grey50 = Colors.grey[50];
  static Color? grey100 = Colors.grey[100];
  static Color? grey200 = Colors.grey[200];
  static Color? grey350 = Colors.grey[350];
  static Color? grey300 = Colors.grey[300];
  static Color? grey400 = Colors.grey[400];
  static Color? grey600 = Colors.grey[600];
  static Color? grey700 = Colors.grey[700];
  static Color? grey800 = Colors.grey[800];
  static Color? grey850 = Colors.grey[850];
  static Color? grey900 = Colors.grey[900];
  static Color? blue = Colors.blue;
  static Color? blue800 = Colors.blue[800];
  static Color? blue900 = Colors.blue[900];
  static Color? green = Colors.green;
  static Color? red = Colors.red;
  static Color? red900 = Colors.red[900];
  static Color? transparent = Colors.transparent;
  static Color? cyan = Colors.cyan;

  static List gradientsColor = const [
    // use  index 0 for design , this one is fake data
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFFFFFFF),
      ],
    ),
    // use  index 1 for white color
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFFFFFFF),
      ],
    ),
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [
        Color(0xFFff00ea),
        Color(0xFFff7300),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(-135),
      colors: [
        Color.fromRGBO(72, 229, 169, 1),
        Color.fromRGBO(143, 199, 173, 1),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(116, 167, 126, 1),
        Color.fromRGBO(24, 175, 78, 1),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFff7f11),
        Color(0xFFff7f11),
      ],
    ),
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [
        Color(0xFF0000ff),
        Color(0xFFff0a0a),
      ],
    ),
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [
        Color(0xFF00ffe1),
        Color(0xFFe9ff42),
      ],
    )
  ];

  static LinearGradient gradient_1 = const LinearGradient(
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
    transform: GradientRotation(90),
    colors: [
      Color(0xFFff00ea),
      Color(0xFFff7300),
    ],
  );
  static LinearGradient gradient_2 = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(-135),
    colors: [
      Color.fromRGBO(72, 229, 169, 1),
      Color.fromRGBO(143, 199, 173, 1),
    ],
  );
  static LinearGradient gradient_3 = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(116, 167, 126, 1),
      Color.fromRGBO(24, 175, 78, 1),
    ],
  );
  static LinearGradient gradient_4 = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFff7f11),
      Color(0xFFff7f11),
    ],
  );
  static LinearGradient gradient_5 = const LinearGradient(
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
    transform: GradientRotation(90),
    colors: [
      Color(0xFF0000ff),
      Color(0xFFff0a0a),
    ],
  );
  static LinearGradient gradient_6 = const LinearGradient(
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
    transform: GradientRotation(90),
    colors: [
      Color(0xFFe9ff42),
      Color(0xFF00ffe1),
    ],
  );

  static List feedBackGroundGradientColors = [
    "background-image: linear-gradient(45deg, #ff7300 0%, #ff00ea 100%);",
    "background-image: linear-gradient(135deg, rgb(143, 199, 173), rgb(72, 229, 169));",
    "background-image: linear-gradient(135deg, rgb(116, 167, 126), rgb(24, 175, 78));",
    "background-image: linear-gradient(45deg, #ff7f11 0%, #ff7f11 100%);",
    "background-image: linear-gradient(45deg, #ff0a0a 0%, #0000ff 100%);",
    "background-image: linear-gradient(45deg, #e9ff42 0%, #00ffe1 100%);"
  ];

  static String feedBackGroundGradientColor1 = "background-image: linear-gradient(45deg, #ff7300 0%, #ff00ea 100%);";
  static String feedBackGroundGradientColor2 = "background-image: linear-gradient(135deg, rgb(143, 199, 173), rgb(72, 229, 169));";
  static String feedBackGroundGradientColor3 = "background-image: linear-gradient(135deg, rgb(116, 167, 126), rgb(24, 175, 78));";
  static String feedBackGroundGradientColor4 = "background-image: linear-gradient(45deg, #ff7f11 0%, #ff7f11 100%);";
  static String feedBackGroundGradientColor5 = "background-image: linear-gradient(45deg, #ff0a0a 0%, #0000ff 100%);";
  static String feedBackGroundGradientColor6 = "background-image: linear-gradient(45deg, #e9ff42 0%, #00ffe1 100%);";
}
