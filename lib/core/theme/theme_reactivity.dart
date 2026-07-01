import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

void dependOnThemeChanges(BuildContext context) {
  context.watch<ThemeProvider?>()?.primaryColor;
}
