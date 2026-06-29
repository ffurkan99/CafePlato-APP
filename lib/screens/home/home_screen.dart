import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_modal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/product_icon_helper.dart';
import '../../data/mock_data.dart';
import '../../models/campaign.dart';
import '../../models/product.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/home_discovery_card.dart';
import '../../widgets/pressable_scale.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = MockData.categories.first;
  late final AnimationController _introController;

  // Tekrar sipariş feedback
  Timer? _reorderFeedbackTimer;
  bool _reorderJustAdded = false;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (AppMotion.reduceMotion(context)) {
        _introController.value = 1;
      } else {
        _introController.forward();
      }
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _reorderFeedbackTimer?.cancel();
    super.dispose();
  }

  /// Açılış animasyonu: fade + 14px yukarı slide, 50ms stagger
  Widget _introItem(int index, Widget child) {
    final start = (index * 0.08).clamp(0.0, 0.6);
    final end = (start + 0.52).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _introController,
      child: child,
      builder: (context, child) {
        final progress = Interval(start, end, curve: AppMotion.entrance)
            .transform(_introController.value);
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - progress)),
            child: child,
          ),
        );
      },
    );
  }

  List<Product> get _filteredProducts {
    final popular = MockData.products.where((p) => p.isPopular).toList();
    final source = popular.isEmpty ? MockData.products : popular;
    if (_selectedCategory == 'Tümü') return source.take(6).toList();
    return source
        .where((p) => p.category == _selectedCategory)
        .take(6)
        .toList();
  }

  void _showNotificationSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Henüz yeni bildiriminiz bulunmuyor.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onReorder() {
    final product = MockData.lastOrder;
    context.read<CartProvider>().addItem(
      product: product,
      size: product.availableSizes?[1],
      milk: product.availableMilkOptions?[1],
      extras: [],
      quantity: 1,
      calculatedUnitPrice: product.price +
          (product.availableSizes?[1].priceDelta ?? 0) +
          (product.availableMilkOptions?[1].priceDelta ?? 0),
    );
    HapticFeedback.lightImpact();
    _reorderFeedbackTimer?.cancel();
    setState(() => _reorderJustAdded = true);
    _reorderFeedbackTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _reorderJustAdded = false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tekrar eklendi.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showBranchSheet() {
    AppModal.showBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Şube Seçimi', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            ...MockData.branches.map((branch) {
              return GestureDetector(
                onTap: () {
                  context.read<AppStateProvider>().setSelectedBranch(branch);
                  Navigator.pop(ctx);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(branch.name, style: AppTextStyles.bodyLarge),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedBranch = context.watch<AppStateProvider>().selectedBranch;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── 1. Editorial Karşılama Başlığı ─────────────────────────
          SliverToBoxAdapter(
            child: _introItem(0, _buildEditorialHeader()),
          ),

          // ─── 2. CafePlato Club Hero ──────────────────────────────────
          SliverToBoxAdapter(
            child: _introItem(
              1,
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: _buildClubHero(selectedBranch.name),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ─── 3. Editorial Kampanya Carousel ─────────────────────────
          SliverToBoxAdapter(
            child: _introItem(
              2,
              _buildCampaignCarousel(screenWidth),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ─── 4. Hızlı Tekrar Sipariş Dock ───────────────────────────
          SliverToBoxAdapter(
            child: _introItem(3, _buildReorderDock()),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ─── 5. Minimal Kategori Kontrolü ───────────────────────────
          SliverToBoxAdapter(
            child: _introItem(4, _buildCategoryLabel()),
          ),
          SliverToBoxAdapter(
            child: _introItem(4, _buildCategoryRow()),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ─── 6. Yatay Discovery Ürün Rail'i ─────────────────────────
          SliverToBoxAdapter(
            child: _introItem(
              5,
              _buildDiscoveryRail(screenWidth),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 1. EDITORIAL KARŞILAMA BAŞLIĞI
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildEditorialHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sol: Marka label + selamlama
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CAFEPLATO',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.champagne,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Günaydın, Furkan',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Bugünkü kahveni birlikte seçelim.',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Sağ: Bildirim + Avatar
          Row(
            children: [
              PressableScale(
                semanticLabel: 'Bildirimler',
                onTap: _showNotificationSnackBar,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.notifications_outlined,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.champagneLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.champagne, width: 0.8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'F',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 2. CAFEPlato CLUB HERO
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildClubHero(String branchName) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Üst satır: Club label + Gold badge
                Row(
                  children: [
                    Text(
                      'CAFEPLATO CLUB',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.champagneLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.champagne,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.champagne,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Gold Üye',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Orta: Puan + CafePuan
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '1.240',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -1.5,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'CafePuan',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Sadakat progress track
                _buildLoyaltyTrack(),

                const SizedBox(height: 6),

                Text(
                  'Ödül kahvene 2 kahve kaldı',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 14),

                // Alt: Şube seçimi
                PressableScale(
                  semanticLabel: 'Şube seç',
                  onTap: _showBranchSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            branchName,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyTrack() {
    const totalSteps = 5;
    const completedSteps = 3;

    return LayoutBuilder(
      builder: (context, constraints) {
        const iconSize = 26.0;
        final availableWidth = constraints.maxWidth;
        final lineWidth =
            (availableWidth - iconSize * totalSteps) / (totalSteps - 1);

        return SizedBox(
          height: iconSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Bağlantı çizgileri
              for (int i = 0; i < totalSteps - 1; i++)
                Positioned(
                  left: iconSize * (i + 1) + lineWidth * i,
                  child: Container(
                    width: lineWidth,
                    height: 1.5,
                    color: i < completedSteps - 1
                        ? AppColors.primary.withAlpha(160)
                        : AppColors.border,
                  ),
                ),
              // Adım ikonları
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (index) {
                  final isActive = index < completedSteps;
                  final isLast = index == totalSteps - 1;
                  return Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive ? AppColors.primary : AppColors.border,
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      isLast && !isActive
                          ? Icons.star_rounded
                          : Icons.local_cafe_rounded,
                      size: 13,
                      color: isActive
                          ? Colors.white
                          : (isLast ? AppColors.champagne : AppColors.border),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 3. EDITORIAL KAMPANYA CAROUSEL
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCampaignCarousel(double screenWidth) {
    final cardWidth = screenWidth * 0.84;
    return SizedBox(
      height: 168,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: MockData.campaigns.length,
        itemBuilder: (context, index) {
          return _buildCampaignCard(MockData.campaigns[index], cardWidth);
        },
      ),
    );
  }

  Widget _buildCampaignCard(Campaign campaign, double width) {
    // Yüzey varyasyonları
    const surfaces = [
      _CampaignSurface(
        bg: AppColors.primaryLight,
        accentColor: AppColors.primary,
        arcColor: AppColors.primary,
      ),
      _CampaignSurface(
        bg: AppColors.champagneLight,
        accentColor: Color(0xFF6B4E3D),
        arcColor: AppColors.champagne,
      ),
      _CampaignSurface(
        bg: Color(0xFFF4F2EF),
        accentColor: AppColors.textPrimary,
        arcColor: AppColors.border,
      ),
    ];
    final idx = campaign.surfaceVariant.clamp(0, surfaces.length - 1);
    final surface = surfaces[idx];

    return PressableScale(
      onTap: () => _showCampaignDetail(campaign),
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface.bg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Üst label
                if (campaign.label != null)
                  Text(
                    campaign.label!,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: surface.accentColor.withAlpha(180),
                      letterSpacing: 0.9,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (campaign.label != null) const SizedBox(height: 4),
                // Büyük tipografik vurgu
                if (campaign.accentValue != null)
                  Text(
                    campaign.accentValue!,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: surface.accentColor,
                      height: 1.0,
                      letterSpacing: -1.2,
                    ),
                  ),
                if (campaign.accentValue != null) const SizedBox(height: 5),
                // Ana mesaj
                Expanded(
                  child: Text(
                    campaign.title,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                // Aksiyon
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'İncele',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: surface.accentColor,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: surface.accentColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCampaignDetail(Campaign campaign) {
    AppModal.showBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (campaign.label != null)
              Text(
                campaign.label!,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 1.0,
                ),
              ),
            const SizedBox(height: 8),
            Text(campaign.title, style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text(campaign.description, style: AppTextStyles.bodyLarge),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Anladım'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 4. HIZLI TEKRAR SİPARİŞ DOCK
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildReorderDock() {
    final product = MockData.lastOrder;
    final price = product.price +
        (product.availableSizes?[1].priceDelta ?? 0) +
        (product.availableMilkOptions?[1].priceDelta ?? 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Son Siparişin',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.1,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Row(
              children: [
                // Ürün ikon alanı
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ProductIconHelper.backgroundForCategory(
                      product.category,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    ProductIconHelper.iconForCategory(product.category),
                    size: 20,
                    color: ProductIconHelper.iconColorForCategory(
                      product.category,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Ürün bilgisi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Orta Boy • Laktozsuz  •  ${price.toStringAsFixed(0)} ₺',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Ekle butonu
                PressableScale(
                  semanticLabel: 'Tekrar sepete ekle',
                  onTap: _onReorder,
                  child: AnimatedContainer(
                    duration: AppMotion.fast,
                    curve: AppMotion.standard,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _reorderJustAdded
                          ? AppColors.success
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: AnimatedSwitcher(
                      duration: AppMotion.fast,
                      child: _reorderJustAdded
                          ? const Icon(
                              Icons.check_rounded,
                              key: ValueKey('check'),
                              color: Colors.white,
                              size: 16,
                            )
                          : Text(
                              'Ekle',
                              key: const ValueKey('add'),
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 5. KATEGORİ KONTROLÜ
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCategoryLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Text(
        'Keşfet',
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildCategoryRow() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: MockData.categories.length,
        itemBuilder: (context, index) {
          final category = MockData.categories[index];
          return CategoryChip(
            label: category,
            isSelected: _selectedCategory == category,
            onTap: () {
              setState(() => _selectedCategory = category);
            },
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 6. YATAY DISCOVERY ÜRÜN RAİL'İ
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDiscoveryRail(double screenWidth) {
    final products = _filteredProducts;
    final cardWidth = (screenWidth * 0.62).clamp(160.0, 230.0);

    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Center(
          child: Text(
            'Bu kategoride ürün bulunamadı.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    return SizedBox(
      height: 196,
      child: AnimatedSwitcher(
        duration: AppMotion.duration(context, const Duration(milliseconds: 180)),
        switchInCurve: AppMotion.entrance,
        switchOutCurve: AppMotion.exit,
        child: ListView.builder(
          key: ValueKey(_selectedCategory),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 14),
              child: SizedBox(
                width: cardWidth,
                child: HomeDiscoveryCard(
                  key: ValueKey(products[index].id),
                  product: products[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Kampanya kartı yüzey renk grubu (immutable, const uyumlu)
class _CampaignSurface {
  final Color bg;
  final Color accentColor;
  final Color arcColor;

  const _CampaignSurface({
    required this.bg,
    required this.accentColor,
    required this.arcColor,
  });
}
