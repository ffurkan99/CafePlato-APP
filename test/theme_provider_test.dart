import 'package:cafe_plato/core/theme/app_colors.dart';
import 'package:cafe_plato/core/theme/app_theme.dart';
import 'package:cafe_plato/providers/theme_provider.dart';
import 'package:cafe_plato/screens/profile/theme_picker_screen.dart';
import 'package:cafe_plato/widgets/pressable_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('theme color is readable, derived and persisted', () async {
    SharedPreferences.setMockInitialValues({});
    final provider = ThemeProvider();
    const lightBrandColor = Color(0xFFD19A3D);

    await provider.setPrimaryColor(lightBrandColor);

    expect(
      1.05 / (provider.primaryColor.computeLuminance() + 0.05),
      greaterThanOrEqualTo(4),
    );
    expect(AppColors.primary, provider.primaryColor);
    expect(AppColors.primaryLight, isNot(const Color(0xFFF7E9E9)));

    final restoredProvider = ThemeProvider();
    await restoredProvider.restore();
    expect(restoredProvider.primaryColor, provider.primaryColor);
  });

  testWidgets('preset selection updates the live brand color', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SharedPreferences.setMockInitialValues({});
    final provider = ThemeProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ThemePickerScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tema Değiştir'), findsOneWidget);
    expect(find.text('Bordo (Varsayılan)'), findsOneWidget);
    expect(find.text('Zeytin Kahve'), findsOneWidget);

    final kiremitSwatch = find.ancestor(
      of: find.text('Kiremit'),
      matching: find.byType(PressableScale),
    );
    tester.widget<PressableScale>(kiremitSwatch).onTap?.call();
    await tester.pumpAndSettle();

    expect(
      provider.primaryColor,
      ThemeProvider.ensureWhiteContrast(const Color(0xFFC1502B)),
    );
    expect(AppColors.primary, provider.primaryColor);
  });
}
