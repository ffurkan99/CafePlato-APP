import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'menu/menu_screen.dart';
import 'qr/qr_screen.dart';
import 'branches/branches_screen.dart';
import 'store/store_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_summary_bar.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_motion.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/theme_reactivity.dart';
import '../core/widgets/animated_indexed_stack.dart';
import '../widgets/pressable_scale.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onOpenMenu: () => _selectTab(1)),
      const MenuScreen(),
      const QrScreen(),
      const BranchesScreen(),
      const StoreScreen(),
    ];
  }

  void _selectTab(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    dependOnThemeChanges(context);

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
                  Expanded(
                    child: _buildNavItem(
                      0,
                      Icons.home_outlined,
                      Icons.home_rounded,
                      'Ana Sayfa',
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      1,
                      Icons.restaurant_menu_outlined,
                      Icons.restaurant_menu_rounded,
                      'Menü',
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      2,
                      Icons.qr_code_scanner_outlined,
                      Icons.qr_code_scanner_rounded,
                      'QR',
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      3,
                      Icons.location_on_outlined,
                      Icons.location_on_rounded,
                      'Mağazalar',
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      4,
                      Icons.storefront_outlined,
                      Icons.storefront_rounded,
                      'Online Mağaza',
                    ),
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

    return Center(
      child: PressableScale(
        semanticLabel: label,
        selected: isSelected,
        pressedScale: 0.98,
        borderRadius: BorderRadius.circular(14),
        onTap: isSelected ? null : () => _selectTab(index),
        child: KeyedSubtree(
          key: ValueKey('bottom-nav-$index'),
          child: SizedBox(
            width: 60,
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
                            duration: AppMotion.duration(
                              context,
                              AppMotion.fast,
                            ),
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
                  SizedBox(
                    height: 13,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: AnimatedDefaultTextStyle(
                        duration: duration,
                        curve: AppMotion.standard,
                        style: AppTextStyles.bottomNavigation.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.5,
                        ),
                        child: Text(label, maxLines: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
