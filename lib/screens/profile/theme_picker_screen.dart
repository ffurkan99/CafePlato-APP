import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/pressable_scale.dart';

class ThemePickerScreen extends StatefulWidget {
  const ThemePickerScreen({super.key});

  @override
  State<ThemePickerScreen> createState() => _ThemePickerScreenState();
}

class _ThemePickerScreenState extends State<ThemePickerScreen> {
  static const _presets = [
    _ThemePreset('Bordo (Varsayılan)', AppColors.defaultPrimary),
    _ThemePreset('Kiremit', Color(0xFFC1502B)),
    _ThemePreset('Hardal', Color(0xFFC08A1E)),
    _ThemePreset('Zeytin', Color(0xFF6B7A3A)),
    _ThemePreset('Çam Yeşili', Color(0xFF2E6E4A)),
    _ThemePreset('Deniz Mavisi', Color(0xFF1F7A72)),
    _ThemePreset('Lacivert', Color(0xFF1F3A5F)),
    _ThemePreset('Denim', Color(0xFF2E5C8A)),
    _ThemePreset('İndigo', Color(0xFF3C3D8C)),
    _ThemePreset('Mor (Plum)', Color(0xFF6B3564)),
    _ThemePreset('Vişne', Color(0xFF9C1F3A)),
    _ThemePreset('Toz Pembe', Color(0xFFB0555F)),
    _ThemePreset('Bakır', Color(0xFFA85C32)),
    _ThemePreset('Tarçın', Color(0xFF8A4B32)),
    _ThemePreset('Espresso Kahve', Color(0xFF4A342A)),
    _ThemePreset('Antrasit', Color(0xFF33393D)),
    _ThemePreset('Petrol Mavisi', Color(0xFF14555E)),
    _ThemePreset('Zümrüt', Color(0xFF16745A)),
    _ThemePreset('Mercan', Color(0xFFD9694F)),
    _ThemePreset('Safran', Color(0xFFD19A3D)),
    _ThemePreset('Gece Mavisi (Slate)', Color(0xFF47536B)),
    _ThemePreset('Toprak (Clay)', Color(0xFF9C5B3C)),
    _ThemePreset('Gece Moru', Color(0xFF4B2E63)),
    _ThemePreset('Okyanus', Color(0xFF205A7A)),
    _ThemePreset('Zeytin Kahve', Color(0xFF6E5636)),
  ];

  late Color _customColor;
  late final TextEditingController _hexController;

  @override
  void initState() {
    super.initState();
    _customColor = context.read<ThemeProvider>().primaryColor;
    _hexController = TextEditingController(text: _toHex(_customColor));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  void _updateCustomColor(Color color, {bool updateHex = true}) {
    setState(() => _customColor = color.withValues(alpha: 1));
    if (updateHex) {
      _hexController.value = TextEditingValue(
        text: _toHex(color),
        selection: TextSelection.collapsed(offset: _toHex(color).length),
      );
    }
  }

  void _handleHexChanged(String value) {
    final normalized = value.replaceFirst('#', '');
    if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(normalized)) return;
    _updateCustomColor(
      Color(int.parse('FF$normalized', radix: 16)),
      updateHex: false,
    );
  }

  Future<void> _applyCustomColor() async {
    await context.read<ThemeProvider>().setPrimaryColor(_customColor);
    if (!mounted) return;
    AppFeedback.show(
      context,
      'Özel marka rengi uygulandı.',
      type: AppFeedbackType.success,
    );
  }

  Future<void> _resetTheme() async {
    await context.read<ThemeProvider>().reset();
    if (!mounted) return;
    _updateCustomColor(AppColors.defaultPrimary);
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = context.watch<ThemeProvider>().primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tema Değiştir'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Text('Hazır Renkler', style: AppTextStyles.heading3),
          const SizedBox(height: 6),
          Text(
            'Bir renk seçtiğinde uygulama teması anında güncellenir.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final columnCount = constraints.maxWidth < 330 ? 4 : 5;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _presets.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final preset = _presets[index];
                  final effectiveColor = ThemeProvider.ensureWhiteContrast(
                    preset.color,
                  );
                  final isSelected = selectedColor == effectiveColor;
                  return _PresetSwatch(
                    preset: preset,
                    color: effectiveColor,
                    isSelected: isSelected,
                    onTap: () => context.read<ThemeProvider>().setPrimaryColor(
                      preset.color,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 32),
          Text('Özel Renk', style: AppTextStyles.heading3),
          const SizedBox(height: 6),
          Text(
            'RGB kanallarını ayarla veya marka renginin hex kodunu gir.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _customColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border, width: 2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _hexController,
                        onChanged: _handleHexChanged,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[#0-9A-Fa-f]'),
                          ),
                          LengthLimitingTextInputFormatter(7),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Hex kodu',
                          hintText: '#B3262E',
                          prefixIcon: const Icon(Icons.tag_rounded),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _RgbSlider(
                  label: 'R',
                  value: _red(_customColor),
                  trackType: TrackType.red,
                  color: _customColor,
                  onChanged: (color) => _updateCustomColor(color.toColor()),
                ),
                _RgbSlider(
                  label: 'G',
                  value: _green(_customColor),
                  trackType: TrackType.green,
                  color: _customColor,
                  onChanged: (color) => _updateCustomColor(color.toColor()),
                ),
                _RgbSlider(
                  label: 'B',
                  value: _blue(_customColor),
                  trackType: TrackType.blue,
                  color: _customColor,
                  onChanged: (color) => _updateCustomColor(color.toColor()),
                ),
                const SizedBox(height: 12),
                PressableScale(
                  semanticLabel: 'Bu rengi uygula',
                  onTap: _applyCustomColor,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Bu Rengi Uygula',
                      style: AppTextStyles.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: _resetTheme,
            child: const Text('Varsayılana Sıfırla'),
          ),
        ],
      ),
    );
  }

  static int _red(Color color) => (color.toARGB32() >> 16) & 0xFF;
  static int _green(Color color) => (color.toARGB32() >> 8) & 0xFF;
  static int _blue(Color color) => color.toARGB32() & 0xFF;

  static String _toHex(Color color) {
    final rgb = color.toARGB32() & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}

class _ThemePreset {
  const _ThemePreset(this.name, this.color);

  final String name;
  final Color color;
}

class _PresetSwatch extends StatelessWidget {
  const _PresetSwatch({
    required this.preset,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final _ThemePreset preset;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      semanticLabel: '${preset.name} temasını uygula',
      selected: isSelected,
      onTap: onTap,
      pressedScale: 0.94,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.textPrimary : AppColors.border,
                width: isSelected ? 2.5 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            preset.name,
            style: AppTextStyles.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _RgbSlider extends StatelessWidget {
  const _RgbSlider({
    required this.label,
    required this.value,
    required this.trackType,
    required this.color,
    required this.onChanged,
  });

  final String label;
  final int value;
  final TrackType trackType;
  final Color color;
  final ValueChanged<HSVColor> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(label, style: AppTextStyles.controlLabel),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 36,
              child: ColorPickerSlider(
                trackType,
                HSVColor.fromColor(color),
                onChanged,
                displayThumbColor: true,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.end,
              style: AppTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
