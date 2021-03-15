import 'dart:math';
import 'dart:ui';

double handleAutoFontSize(double fontSize) {
  double result = fontSize *
      sqrt(window.physicalSize.width * window.physicalSize.width +
          window.physicalSize.height * window.physicalSize.height) *
      0.001;

  return result;
}
