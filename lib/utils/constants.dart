import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  // Colors
  static const kPrimaryColor = Color(0xFF693699);
  static const kPrimaryLightColor = Color(0xFFFF7643);
  static const kPrimaryGradientColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7643), Color(0xFFFF7643)]
  );
  static const kSecondaryColor = Color(0xFF7C40A9);
  static const kTertiaryColor = Color(0xFF9570DD);
  static const kQuartaryColor = Color(0xFF9F05C5);
  static const kTextColor = Color(0xFFFFFFFF);

  static const kPrimaryDarkBackgroundColor = Color(0xFF000000);
  static const kSecondaryDarkBackgroundColor = Color(0xFF1C1C1E);
  static const kTertiaryDarkBackgroundColor = Color(0xFF2C2C2E);

  // Text
  static const title = "Anthem";
  static const textIntro = "The music you love";
  static const textContinue = "Continue";
  static const textSignInTwitter = "Sign In With Twitter";

  static const textNavBarHome = "Home";
  static const textNavBarLibrary = "My Library";
  static const textNavBarCharts = "Top Charts";
  static const textNavBarMap = "Music Map";

  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.kPrimaryColor,
      statusBarIconBrightness: Brightness.dark);

  static const kAnimationDuration = Duration(milliseconds: 200);
}