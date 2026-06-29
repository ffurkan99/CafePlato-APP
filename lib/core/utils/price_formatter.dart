import '../constants/app_constants.dart';

class PriceFormatter {
  PriceFormatter._();

  static String format(double price) {
    // Fiyatın küsüratını kontrol et
    if (price == price.truncateToDouble()) {
      return '${price.toInt()} ${AppConstants.currency}';
    }
    return '${price.toStringAsFixed(2)} ${AppConstants.currency}';
  }
}
