import 'package:intl/intl.dart';

String formatNumberWithThousandsSeparator(int number) {
  final numberFormat = NumberFormat(
      '#,###', 'id_ID'); // Format untuk pemisah ribuan menggunakan titik
  return numberFormat.format(number);
}
