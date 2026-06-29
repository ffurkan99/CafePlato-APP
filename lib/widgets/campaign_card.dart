import 'package:flutter/material.dart';
import '../../core/navigation/app_modal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/campaign.dart';
import 'cafe_plato_arc.dart';
import 'pressable_scale.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final double width;

  const CampaignCard({super.key, required this.campaign, required this.width});

  /// Kart yüzey rengi ve aksan rengi — surfaceVariant'a göre
  static const List<_CardSurface> _surfaces = [
    _CardSurface(
      bg: AppColors.primaryLight, // Açık bordo
      accent: AppColors.primary,
      accentText: Colors.white,
      arcColor: AppColors.primary,
    ),
    _CardSurface(
      bg: AppColors.champagneLight, // Sıcak bej
      accent: Color(0xFF6B4E3D),
      accentText: Colors.white,
      arcColor: AppColors.champagne,
    ),
    _CardSurface(
      bg: Color(0xFFF5F3F0), // Kırık beyaz
      accent: AppColors.textPrimary,
      accentText: Colors.white,
      arcColor: AppColors.border,
    ),
  ];

  _CardSurface get _surface {
    final idx = campaign.surfaceVariant.clamp(0, _surfaces.length - 1);
    return _surfaces[idx];
  }

  void _showCampaignDetails(BuildContext context) {
    AppModal.showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (campaign.label != null)
                Text(
                  campaign.label!,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
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
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Anladım'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final surface = _surface;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: PressableScale(
        borderRadius: BorderRadius.circular(18),
        pressedScale: 0.99,
        onTap: () => _showCampaignDetails(context),
        child: Container(
          width: width,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surface.bg,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            children: [
              // CafePlato Arc dekoratif motif
              Positioned.fill(
                child: CafePlatoArc(
                  color: surface.arcColor,
                  opacity: 0.1,
                  alignment: Alignment.bottomRight,
                  innerRadiusFactor: 0.6,
                  outerRadiusFactor: 0.82,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Üst küçük label
                  if (campaign.label != null)
                    Text(
                      campaign.label!,
                      style: AppTextStyles.label.copyWith(
                        color: surface.accent.withAlpha(180),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (campaign.label != null) const SizedBox(height: 6),
                  // Büyük tipografik vurgu
                  if (campaign.accentValue != null)
                    Text(
                      campaign.accentValue!,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: surface.accent,
                        height: 1.0,
                        letterSpacing: -1.0,
                      ),
                    ),
                  if (campaign.accentValue != null) const SizedBox(height: 6),
                  // Ana mesaj
                  Expanded(
                    child: Text(
                      campaign.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.35,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // İncele aksiyonu
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'İncele',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: surface.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: surface.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Yüzey rengi ve aksan renk grubu.
class _CardSurface {
  final Color bg;
  final Color accent;
  final Color accentText;
  final Color arcColor;

  const _CardSurface({
    required this.bg,
    required this.accent,
    required this.accentText,
    required this.arcColor,
  });
}
