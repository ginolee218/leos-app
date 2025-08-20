import 'package:flutter/material.dart';

/// A class to hold all the shared styles and dimensions for the app.
class AppStyles {
  // This class is not meant to be instantiated.
  AppStyles._();

  // ===== Colors =====
  static const Color colorPrimaryText = Colors.white;
  static const Color colorEmergency = Colors.red;
  static const Color colorSuccess = Colors.greenAccent;
  static const Color colorFailure = Colors.redAccent;
  static const Color logItemBgEven = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color logItemBgOdd = Color.fromRGBO(0, 0, 0, 0.3);
  static const Color logListBg = Color.fromRGBO(0, 0, 0, 0.2);


  // ===== Sizing =====
  static const double appBarHeight = 64.0;
  static const double appBarPaddingLeft = 64.0;
  static const double appBarPaddingRight = 32.0;
  static const double appBarIconSize = 24.0;
  static const double featureButtonIconHeight = 97.0;
  static const double featureButtonIconWidth = 147.0;
  static const double logStatusIconSize = 20.0;


  // ===== Padding & Spacing =====
  static const double spacingS = 2.0;
  static const double spacingM = 8.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;


  // ===== Font Sizes =====
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;


  // ===== Text Styles =====
  static const TextStyle appBarActionText = TextStyle(
    color: colorPrimaryText,
    fontSize: fontSizeM,
  );

  static const TextStyle versionText = TextStyle(
    color: colorPrimaryText,
    fontSize: fontSizeL,
  );

  static const TextStyle featureButtonText = TextStyle(
    color: colorPrimaryText,
    fontSize: fontSizeXL,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle featureButtonEmergencyText = TextStyle(
    color: colorEmergency,
    fontSize: fontSizeXL,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle dataSectionTitle = TextStyle(
    color: colorPrimaryText,
    fontSize: fontSizeXL,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle logListTitle = TextStyle(
    color: colorPrimaryText,
    fontSize: fontSizeL,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle logItemText = TextStyle(
    color: colorPrimaryText,
    fontSize: fontSizeL,
  );
}
