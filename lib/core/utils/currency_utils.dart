import 'package:intl/intl.dart';

String fmt(double value, {
  String? symbol,
  int decimals = 2
}) => NumberFormat.currency(
  decimalDigits: decimals,
  symbol: symbol
).format(value);

String fmtDecimal(double value) {
  int dotIndex = value.toString().indexOf('.');

  if (dotIndex == -1) {
    return "00";
  }

  String decimalPart = value.toString().substring(dotIndex + 1);
  return decimalPart.padRight(2, '0').substring(0, 2);
}
