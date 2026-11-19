import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter() : _format = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  final NumberFormat _format;

  String format(num amount) => _format.format(amount);
}
