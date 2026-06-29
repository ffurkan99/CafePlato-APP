import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_plato/core/theme/app_theme.dart';
import 'package:cafe_plato/data/mock_data.dart';
import 'package:cafe_plato/data/store_products.dart';
import 'package:cafe_plato/models/user_model.dart';
import 'package:cafe_plato/providers/app_state_provider.dart';
import 'package:cafe_plato/providers/auth_provider.dart';
import 'package:cafe_plato/providers/cart_provider.dart';
import 'package:cafe_plato/providers/favorites_provider.dart';
import 'package:cafe_plato/providers/store_cart_provider.dart';
import 'package:cafe_plato/screens/product_detail/product_detail_screen.dart';
import 'package:cafe_plato/screens/auth/login_screen.dart';
import 'package:cafe_plato/screens/profile/notification_settings_screen.dart';
import 'package:cafe_plato/screens/profile/profile_screen.dart';
import 'package:cafe_plato/screens/main_navigation.dart';
import 'package:cafe_plato/core/theme/app_colors.dart';
import 'package:cafe_plato/widgets/category_chip.dart';
import 'package:cafe_plato/widgets/pressable_scale.dart';

void main() {
  Finder navButton(int index) {
    final pressable = find.ancestor(
      of: find.byKey(ValueKey('bottom-nav-$index')),
      matching: find.byType(PressableScale),
    );
    return find.descendant(of: pressable, matching: find.byType(InkWell));
  }

  test('auth persists registration, session, logout and mock login', () async {
    SharedPreferences.setMockInitialValues({});
    final auth = AuthProvider();
    await auth.restoreSession();
    expect(auth.isLoggedIn, isFalse);

    const user = UserModel(
      firstName: 'Ada',
      lastName: 'Lovelace',
      phone: '5551112233',
      email: '',
      password: 'demo',
    );
    await auth.register(user);
    expect(auth.isLoggedIn, isFalse);
    expect(await auth.verifyOtp('1'), isTrue);

    final restored = AuthProvider();
    await restored.restoreSession();
    expect(restored.isLoggedIn, isTrue);
    expect(restored.currentUser?.fullName, 'Ada Lovelace');

    await restored.logout();
    expect(restored.isLoggedIn, isFalse);
    final result = await restored.login(
      phone: user.phone,
      password: 'herhangi bir dolu şifre',
    );
    expect(result.isSuccess, isTrue);
  });

  test('store cart remains an independent quantity and total model', () {
    final cart = StoreCartProvider();
    final product = StoreProducts.items.first;
    cart.addProduct(product);
    cart.addProduct(product);
    expect(cart.totalItems, 2);
    expect(cart.total, product.price * 2);
    cart.decrement(product.id);
    expect(cart.totalItems, 1);
    cart.remove(product.id);
    expect(cart.items, isEmpty);
  });

  testWidgets('tab changes preserve menu state', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
          ChangeNotifierProvider(create: (_) => StoreCartProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MainNavigation(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ana Sayfa'), findsOneWidget);
    expect(find.text('Menü'), findsWidgets);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);

    await tester.tap(navButton(1));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.restaurant_menu_rounded), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Latte');
    await tester.tap(navButton(0));
    await tester.pumpAndSettle();
    await tester.tap(navButton(1));
    await tester.pumpAndSettle();

    expect(find.text('Latte'), findsOneWidget);
  });

  testWidgets('product choices and feedback preserve cart logic', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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

    await tester.ensureVisible(find.text('Büyük'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Büyük'), warnIfMissed: false);
    await tester.ensureVisible(find.text('Laktozsuz Süt'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laktozsuz Süt'), warnIfMissed: false);
    await tester.ensureVisible(find.text('Ekstra shot'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ekstra shot'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Sepete Ekle • 205 TL'), findsOneWidget);

    await tester.tap(find.text('Sepete Ekle • 205 TL'), warnIfMissed: false);
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
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
          ChangeNotifierProvider(create: (_) => StoreCartProvider()),
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

    for (final index in [1, 2, 3, 4, 0]) {
      await tester.tap(navButton(index));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('profile uses the opaque CafePlato background', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, AppColors.background);
    expect(tester.takeException(), isNull);
  });

  testWidgets('login stays centered and constrained across viewports', (
    tester,
  ) async {
    for (final size in const [
      Size(320, 700),
      Size(390, 844),
      Size(430, 900),
      Size(1024, 800),
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final phoneRect = tester.getRect(find.byType(TextFormField).first);
      expect(phoneRect.width, lessThanOrEqualTo(480));
      expect(phoneRect.center.dx, closeTo(size.width / 2, 1));
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(390, 844),
              viewInsets: EdgeInsets.only(bottom: 320),
            ),
            child: const LoginScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Giriş Yap'), findsOneWidget);
    expect(tester.takeException(), isNull);

    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('category chip keeps its bounds while hovered', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              height: 44,
              child: CategoryChip(
                label: 'Kahve',
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final before = tester.getRect(find.byType(CategoryChip));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(before.center);
    await tester.pump(const Duration(milliseconds: 200));
    final after = tester.getRect(find.byType(CategoryChip));

    expect(after, before);
    expect(tester.takeException(), isNull);
    await mouse.removePointer();
  });
}
