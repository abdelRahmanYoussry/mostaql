import 'package:flutter/material.dart';
import 'package:mostaql/core/theme/theme.dart';
import 'package:size_config/size_config.dart';

import 'colors.dart';

TextStyle _getTextStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color,
) {
  return TextStyle(
    fontSize: fontSize.sp + 1,
    fontWeight: fontWeight,
    fontFamily: kPing,
    color: color,
  );
}

//New
TextStyle getBoldBlack18Style() {
  return _getTextStyle(
    18,
    FontWeight.bold,
    Colors.black,
  );
}

TextStyle getBoldBlue16Style() {
  return _getTextStyle(
    16,
    FontWeight.bold,
    Colors.blue,
  );
}

TextStyle getRegularRed16Style() {
  return _getTextStyle(
    16,
    FontWeight.w400,
    Colors.red,
  );
}

TextStyle getMeduimRed18Style() {
  return _getTextStyle(
    18,
    FontWeight.w500,
    Colors.red,
  );
}

TextStyle getBoldBlack16Style() {
  return _getTextStyle(
    16,
    FontWeight.bold,
    Colors.black,
  );
}

TextStyle getBoldWhite16Style() {
  return _getTextStyle(
    16,
    FontWeight.bold,
    Colors.white,
  );
}

TextStyle getRegularWhite14Style() {
  return _getTextStyle(
    14,
    FontWeight.w400,
    Colors.white,
  );
}

TextStyle getW700White16Style() {
  return _getTextStyle(
    16,
    FontWeight.bold,
    Colors.white,
  );
}

TextStyle getHeavyBlack18Style() {
  return _getTextStyle(
    18,
    FontWeight.w900,
    Colors.black,
  );
}

TextStyle getBoldBlack22Style() {
  return _getTextStyle(
    22,
    FontWeight.w700,
    Colors.black,
  );
}

TextStyle getLightGray18Style() {
  return _getTextStyle(
    18,
    FontWeight.w300,
    grey71,
  );
}

TextStyle getBoldBlack20Style() {
  return _getTextStyle(
    20,
    FontWeight.w700,
    Colors.black,
  );
}

TextStyle getBoldGray18Style() {
  return _getTextStyle(
    18,
    FontWeight.bold,
    greyMedium,
  );
}

TextStyle getRegularBlack16Style() {
  return _getTextStyle(
    16,
    FontWeight.w400,
    Colors.black,
  );
}

TextStyle getRegularBlack20Style() {
  return _getTextStyle(
    20,
    FontWeight.w400,
    Colors.black,
  );
}

TextStyle getRegularGray16Style() {
  return _getTextStyle(
    16,
    FontWeight.w400,
    greyMedium,
  );
}

TextStyle getRegularBlack14Style() {
  return _getTextStyle(
    14,
    FontWeight.w400,
    Colors.black,
  );
}

TextStyle getRegularBlue14Style() {
  return _getTextStyle(
    14,
    FontWeight.w400,
    primary,
  );
}

TextStyle getRegularGrey13Style() {
  return _getTextStyle(
    13,
    FontWeight.w400,
    greyMedium,
  );
}

TextStyle getRegularGrey18Style() {
  return _getTextStyle(
    18,
    FontWeight.w500,
    greyMedium,
  );
}

TextStyle getMediumGrey18Style() {
  return _getTextStyle(
    18,
    FontWeight.w500,
    greyMedium,
  );
}

TextStyle getMediumGrey14Style() {
  return _getTextStyle(
    14,
    FontWeight.w500,
    greyMedium,
  );
}

TextStyle getMediumBlack16Style() {
  return _getTextStyle(
    16,
    FontWeight.w500,
    Colors.black,
  );
}

TextStyle getMediumBlack14Style() {
  return _getTextStyle(
    14,
    FontWeight.w500,
    Colors.black,
  );
}

TextStyle getMediumBlue14Style() {
  return _getTextStyle(
    14,
    FontWeight.w500,
    primary,
  );
}

TextStyle getMediumBlack23Style() {
  return _getTextStyle(
    23,
    FontWeight.w500,
    Colors.black,
  );
}

TextStyle getMediumBlack18Style() {
  return _getTextStyle(
    18,
    FontWeight.w500,
    Colors.black,
  );
}

TextStyle getMediumBlack20Style() {
  return _getTextStyle(
    20,
    FontWeight.w500,
    Colors.black,
  );
}

TextStyle getMediumWhite20Style() {
  return _getTextStyle(
    20,
    FontWeight.w500,
    Colors.white,
  );
}

TextStyle getThinGrey16Style() {
  return _getTextStyle(
    16,
    FontWeight.w300,
    greyMedium,
  );
}

TextStyle getThinGrey14Style() {
  return _getTextStyle(
    14,
    FontWeight.w200,
    greyMedium,
  );
}

TextStyle getLightGrey14Style() {
  return _getTextStyle(
    14,
    FontWeight.w300,
    greyMedium,
  );
}

TextStyle getLightGrey16Style() {
  return _getTextStyle(
    16,
    FontWeight.w300,
    greyMedium,
  );
}

TextStyle getLightBlack16Style() {
  return _getTextStyle(
    16,
    FontWeight.w300,
    Colors.black,
  );
}

TextStyle getRegularGrey14Style() {
  return _getTextStyle(
    14,
    FontWeight.w400,
    greyMedium,
  );
}

TextStyle getRegularGreen14Style() {
  return _getTextStyle(
    14,
    FontWeight.w400,
    Colors.green,
  );
}
