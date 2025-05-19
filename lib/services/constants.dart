import 'package:intl/intl.dart';

class Constants {
  static const String baseUrl =
      "http://192.168.1.25:8080/api"; // Replace with your API URL

  static const String imgUrl =
      "http://192.168.1.25:8080"; // Replace with your API URL

  String formatRupiah(String price) {
    try {
      final doublePrice = double.parse(price);
      final formatter = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return formatter.format(doublePrice);
    } catch (e) {
      return 'Rp 0';
    }
  }
}
