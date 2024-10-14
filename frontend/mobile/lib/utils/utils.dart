import 'dart:math';

import 'package:mobile/utils/wallet_color.dart';

String formatDoubleToString(double num) {
  if (num % 1 == 0) {
    return num.toStringAsFixed(0);
  } else {
    return num.toStringAsFixed(2).replaceAll(".", ",");
  }
}

double formatDoubleFromString(String num) {
  double n = double.parse(num.replaceAll(",", "."));
  return double.parse(formatDoubleToString(n).replaceAll(",", "."));
}

formatDouble(double num) {
  return formatDoubleFromString(formatDoubleToString(num));
}

int getRandomColorValue() {
  return walletColors[Random().nextInt(walletColors.length - 1)].value;
}
