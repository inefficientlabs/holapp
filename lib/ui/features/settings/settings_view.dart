import 'package:holapp/routing/go_router.dart';
import 'package:holapp/ui/features/settings/settings_provider.dart';
import 'package:holapp/utils/theme_mode.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = SettingsProvider.of(context);

    return Scaffold(
      child: Column(
        children: [
          AppBar(
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  child: GhostButton(
                    onPressed: () {
                      router.go(Routes.overview);
                    },
                    child: Icon(LucideIcons.arrowLeft),
                  ),
                ),
                Expanded(child: Center(child: Text("Settings"))),
                SizedBox(width: 48),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Row(
              children: [
                Expanded(child: Text("Theme")),
                Expanded(
                  child: Select<ThemeMode>(
                    itemBuilder: (context, item) => Text(item.displayName()),
                    onChanged: (value) {
                      if (value != null) {
                        settingsController.updateThemeMode(value);
                      }
                    },
                    value: settingsController.themeMode,
                    placeholder: const Text('Select a property'),
                    popup: SelectPopup(
                      items: SelectItemList(
                        children: ThemeMode.values
                            .map(
                              (type) => SelectItemButton(
                                value: type,
                                child: Text(type.displayName()),
                              ),
                            )
                            .toList(),
                      ),
                    ).call,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
