import 'package:flutter/material.dart';

const double smallGap = 5.0;
const double mediumGap = 10.0;
const double largeGap = 20.0;
const double xlargeGap = 100.0;

// 휴대폰의 넓이 -> context가 없으면 휴대폰의 넓이를 구할 수 없다.
double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// 네비게이션 화면의 비율
double getDrawerWidth(BuildContext context) {
  return getScreenWidth(context) * 0.6;
}
