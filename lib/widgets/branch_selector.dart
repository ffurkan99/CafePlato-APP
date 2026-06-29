import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_modal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../providers/app_state_provider.dart';

class BranchSelector extends StatelessWidget {
  const BranchSelector({super.key});

  void _showBranchBottomSheet(BuildContext context) {
    AppModal.showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
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
                    Navigator.pop(context);
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedBranch = context.watch<AppStateProvider>().selectedBranch;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => _showBranchBottomSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.champagneLight,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.champagne),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teslimat Noktası',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                    ),
                    Text(
                      selectedBranch.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
