import 'package:shadcn_flutter/shadcn_flutter.dart';

extension ThemeModeExt on ThemeMode {
  String displayName() => switch (this) {
    ThemeMode.system => "system",
    ThemeMode.light => "light",
    ThemeMode.dark => "dark",
  };
}
