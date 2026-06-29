import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../providers/app_state_provider.dart';

class BranchSelector extends StatelessWidget {
  const BranchSelector({super.key});

  void _showBranchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                  title: Text(branch.name, style: AppTextStyles.bodyLarge),
                  onTap: () {
                    context.read<AppStateProvider>().setSelectedBranch(branch);
                    Navigator.pop(context);
                  },
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seçili Şube', style: AppTextStyles.bodySmall),
                  Text(selectedBranch.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _showBranchBottomSheet(context),
              child: const Text('Değiştir'),
            )
          ],
        ),
      ),
    );
  }
}
