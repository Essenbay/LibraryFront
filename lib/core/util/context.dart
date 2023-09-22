import 'dart:math';

import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;

  ThemeData get theme => Theme.of(this);

  ScreenSize get screenSizeType => getSize(this);
}

enum ScreenSize { small, normal, large, extraLarge }

ScreenSize getSize(BuildContext context) {
  final deviceSize = MediaQuery.of(context).size;
  final double diagonalInches =
      sqrt(pow(deviceSize.width, 2) + pow(deviceSize.height, 2)) / 160.0;
  if (diagonalInches > 8) return ScreenSize.extraLarge;
  if (diagonalInches >= 7) return ScreenSize.large;
  if (diagonalInches > 4.5) return ScreenSize.normal;
  return ScreenSize.small;
}
