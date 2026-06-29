import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'menu/menu_screen.dart';
import 'wallet/wallet_screen.dart';
import 'profile/profile_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_summary_bar.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_motion.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/animated_indexed_stack.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MenuScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedIndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) return const SizedBox.shrink();
                return const CartSummaryBar();
              },
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.cardBackground,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    0,
                    Icons.home_outlined,
                    Icons.home_rounded,
                    'Ana Sayfa',
                  ),
                  _buildNavItem(
                    1,
                    Icons.restaurant_menu_outlined,
                    Icons.restaurant_menu_rounded,
                    'Menü',
                  ),
                  _buildNavItem(
                    2,
                    Icons.account_balance_wallet_outlined,
                    Icons.account_balance_wallet_rounded,
                    'Cüzdan',
                  ),
                  _buildNavItem(
                    3,
                    Icons.person_outline_rounded,
                    Icons.person_rounded,
                    'Profil',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;

    final duration = AppMotion.duration(context, AppMotion.normal);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        key: ValueKey('bottom-nav-$index'),
        behavior: HitTestBehavior.opaque,
        onTap: isSelected
            ? null
            : () {
                setState(() {
                  _currentIndex = index;
                });
              },
        child: SizedBox(
          width: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 44,
                  height: 30,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        width: isSelected ? 40 : 28,
                        height: 28,
                        duration: duration,
                        curve: AppMotion.standard,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryLight
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      AnimatedScale(
                        scale: isSelected ? 1 : 0.96,
                        duration: duration,
                        curve: AppMotion.standard,
                        child: AnimatedSwitcher(
                          duration: AppMotion.duration(context, AppMotion.fast),
                          child: Icon(
                            isSelected ? activeIcon : icon,
                            key: ValueKey(isSelected),
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: AppMotion.standard,
                  style: AppTextStyles.bottomNavigation.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 11,
                  ),
                  child: Text(label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
