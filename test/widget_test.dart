import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cafe_plato/main.dart';
import 'package:cafe_plato/core/theme/app_theme.dart';
import 'package:cafe_plato/data/mock_data.dart';
import 'package:cafe_plato/providers/app_state_provider.dart';
import 'package:cafe_plato/providers/cart_provider.dart';
import 'package:cafe_plato/providers/favorites_provider.dart';
import 'package:cafe_plato/screens/product_detail/product_detail_screen.dart';
import 'package:cafe_plato/screens/profile/notification_settings_screen.dart';
import 'package:cafe_plato/screens/main_navigation.dart';

void main() {
  testWidgets('tab changes preserve menu state', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ana Sayfa'), findsOneWidget);
    expect(find.text('Menü'), findsWidgets);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-1')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.restaurant_menu_rounded), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Latte');
    await tester.tap(find.byKey(const ValueKey('bottom-nav-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('bottom-nav-1')));
    await tester.pumpAndSettle();

    expect(find.text('Latte'), findsOneWidget);
  });

  testWidgets('product choices and feedback preserve cart logic', (
    tester,
  ) async {
    final cart = CartProvider();
    final favorites = FavoritesProvider();
    final product = MockData.products.first;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateProvider()),
          ChangeNotifierProvider.value(value: cart),
          ChangeNotifierProvider.value(value: favorites),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: ProductDetailScreen(product: product),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Favorilere ekle'));
    await tester.pumpAndSettle();
    expect(favorites.isFavorite(product), isTrue);

    await tester.tap(find.text('Büyük'));
    await tester.ensureVisible(find.text('Laktozsuz Süt'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laktozsuz Süt'));
    await tester.ensureVisible(find.text('Ekstra shot'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ekstra shot'));
    await tester.pumpAndSettle();

    expect(find.text('Sepete Ekle • 205 TL'), findsOneWidget);

    await tester.tap(find.text('Sepete Ekle • 205 TL'));
    await tester.pump();
    expect(cart.totalItems, 1);
  });

  testWidgets('notification switches and font render on iOS', (tester) async {
    final appState = AppStateProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          theme: AppTheme.lightTheme.copyWith(platform: TargetPlatform.iOS),
          home: const NotificationSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Switch), findsNWidgets(4));
    expect(
      Theme.of(
        tester.element(find.text('Bildirim Ayarları')),
      ).textTheme.bodyMedium?.fontFamily,
      'Manrope',
    );

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(appState.campaignNotifications, isFalse);
  });

  testWidgets('main tabs fit a mobile viewport with larger text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.3)),
              child: child!,
            );
          },
          home: const MainNavigation(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (final index in [1, 2, 3, 0]) {
      await tester.tap(find.byKey(ValueKey('bottom-nav-$index')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
