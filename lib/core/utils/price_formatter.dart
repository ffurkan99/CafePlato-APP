import '../constants/app_constants.dart';

class PriceFormatter {
  PriceFormatter._();

  static String format(double price) {
    String formatted = price.truncateToDouble() == price
        ? price.toInt().toString()
        : price.toStringAsFixed(2);
        
    List<String> parts = formatted.split('.');
    String intPart = parts[0];
    String res = '';
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        res += '.';
      }
      res += intPart[i];
    }
    
    if (parts.length > 1) {
      res += ',${parts[1]}';
    }
    
    return '$res ${AppConstants.currency}';
  }
}
