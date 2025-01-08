import 'dart:math';
import 'package:intl/intl.dart';
import 'package:mobile/common/utils/wallet_color.dart';

enum Type { entrata, uscita }

String formatDoubleToString(double num) {
  return NumberFormat("#,###.##", "it_IT").format(num);
}

double formatDoubleFromString(String num) {
  double n = NumberFormat("#,###.##", "it_IT")
      .parse(num.replaceAll(".", ","))
      .toDouble();
  return n;
}

double formatDouble(double num) {
  return formatDoubleFromString(NumberFormat("###.##").format(num));
}

int getRandomColorValue() {
  return walletColors[Random().nextInt(walletColors.length - 1)].value;
}
