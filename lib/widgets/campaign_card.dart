import 'package:flutter/material.dart';
import '../../core/navigation/app_modal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/campaign.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final double width;

  const CampaignCard({super.key, required this.campaign, required this.width});

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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.local_offer, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
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
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.champagneLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            campaign.title,
            style: AppTextStyles.heading3.copyWith(
              fontSize: 16,
              color: AppColors.primary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showCampaignDetails(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'İncele',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
