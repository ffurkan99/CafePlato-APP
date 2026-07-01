import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  static const _storageKey = 'demo_primary_color';

  Color _primaryColor = AppColors.defaultPrimary;

  ThemeProvider() {
    AppColors.updatePrimary(_primaryColor);
  }

  Color get primaryColor => _primaryColor;

  Future<void> restore() async {
    final preferences = await SharedPreferences.getInstance();
    final storedValue = preferences.getInt(_storageKey);
    if (storedValue == null) return;

    _applyColor(Color(storedValue));
  }

  Future<void> setPrimaryColor(Color color) async {
    final adjustedColor = ensureWhiteContrast(color);
    if (!_applyColor(adjustedColor)) return;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_storageKey, adjustedColor.toARGB32());
  }

  Future<void> reset() => setPrimaryColor(AppColors.defaultPrimary);

  static Color ensureWhiteContrast(Color color) {
    var adjusted = HSLColor.fromColor(color);
    while (_whiteContrast(adjusted.toColor()) < 4.0 &&
        adjusted.lightness > 0.2) {
      adjusted = adjusted.withLightness(adjusted.lightness - 0.025);
    }
    return adjusted.toColor().withValues(alpha: 1);
  }

  static double _whiteContrast(Color color) {
    return 1.05 / (color.computeLuminance() + 0.05);
  }

  bool _applyColor(Color color) {
    final opaqueColor = color.withValues(alpha: 1);
    if (_primaryColor == opaqueColor) return false;

    _primaryColor = opaqueColor;
    AppColors.updatePrimary(opaqueColor);
    notifyListeners();
    return true;
  }
}
