import 'dart:math';
import 'package:intl/intl.dart';
import 'package:mobile/utils/wallet_color.dart';

String formatDoubleToString(double num) {
  return NumberFormat("#,###.##", "it_IT").format(num);
}

double formatDoubleFromString(String num) {
  double n = NumberFormat("#,###.##", "it_IT")
      .parse(num.replaceAll(".", ","))
      .toDouble();
  return n;
}

formatDouble(double num) {
  return formatDoubleFromString(NumberFormat("###.##").format(num));
}

int getRandomColorValue() {
  return walletColors[Random().nextInt(walletColors.length - 1)].value;
}
