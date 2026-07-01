import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/navigation/app_modal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_reactivity.dart';
import '../../data/mock_data.dart';
import '../../models/branch.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/pressable_scale.dart';

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});

  LatLng get _initialCenter {
    final branches = MockData.branches;
    final latitude =
        branches
            .map((branch) => branch.latitude)
            .reduce((first, second) => first + second) /
        branches.length;
    final longitude =
        branches
            .map((branch) => branch.longitude)
            .reduce((first, second) => first + second) /
        branches.length;
    return LatLng(latitude, longitude);
  }

  void _showBranchDetails(BuildContext context, Branch branch) {
    AppModal.showBottomSheet<void>(
      context: context,
      builder: (sheetContext) => _BranchDetailsSheet(branch: branch),
    );
  }

  @override
  Widget build(BuildContext context) {
    dependOnThemeChanges(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mağazalar', style: AppTextStyles.heading1),
                const SizedBox(height: 5),
                Text(
                  'Sana en uygun CafePlato şubesini keşfet.',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _initialCenter,
                    initialZoom: 11.5,
                    minZoom: 6,
                    maxZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.cafeplato.cafe_plato',
                    ),
                    MarkerLayer(
                      markers: [
                        for (final branch in MockData.branches)
                          Marker(
                            point: LatLng(branch.latitude, branch.longitude),
                            width: 52,
                            height: 52,
                            child: Semantics(
                              button: true,
                              label: '${branch.name} detaylarını aç',
                              child: PressableScale(
                                semanticLabel: '${branch.name} detaylarını aç',
                                pressedScale: 0.92,
                                borderRadius: BorderRadius.circular(18),
                                onTap: () =>
                                    _showBranchDetails(context, branch),
                                child: const _BranchMarker(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // TODO: production'da OSM attribution zorunlu, tekrar eklenmeli.
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchMarker extends StatelessWidget {
  const _BranchMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGlow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.local_cafe_rounded, color: AppColors.primary, size: 22),
    );
  }
}

class _BranchDetailsSheet extends StatelessWidget {
  const _BranchDetailsSheet({required this.branch});

  final Branch branch;

  Future<void> _openDirections(BuildContext context) async {
    final destination = '${branch.latitude},${branch.longitude}';
    final uri = defaultTargetPlatform == TargetPlatform.iOS
        ? Uri.parse('https://maps.apple.com/?daddr=$destination&dirflg=d')
        : Uri.https('www.google.com', '/maps/dir/', {
            'api': '1',
            'destination': destination,
            'travelmode': 'driving',
          });

    var didLaunch = false;
    try {
      didLaunch = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      didLaunch = false;
    }
    if (!didLaunch && context.mounted) {
      AppFeedback.show(
        context,
        'Harita uygulaması açılamadı. Lütfen tekrar dene.',
        type: AppFeedbackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(branch.name, style: AppTextStyles.heading2),
          const SizedBox(height: 18),
          _DetailRow(icon: Icons.location_on_outlined, text: branch.address),
          const SizedBox(height: 14),
          _DetailRow(icon: Icons.schedule_rounded, text: branch.openingHours),
          if (branch.phone != null) ...[
            const SizedBox(height: 14),
            _DetailRow(icon: Icons.phone_outlined, text: branch.phone!),
          ],
          const SizedBox(height: 24),
          PressableScale(
            semanticLabel: '${branch.name} için yol tarifi al',
            onTap: () => _openDirections(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Text('Yol Tarifi', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 21),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.bodyLarge)),
      ],
    );
  }
}
