import 'package:holapp/config/config.dart';
import 'package:holapp/ui/core/ui/hol_appbar.dart';
import 'package:holapp/ui/features/settings/settings_provider.dart';
import 'package:holapp/utils/theme_mode.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SettingsView extends StatelessWidget {
  final String fromRoute;

  const SettingsView({super.key, required this.fromRoute});

  @override
  Widget build(BuildContext context) {
    final settingsController = SettingsProvider.of(context);

    return Scaffold(
      child: Padding(
        padding: Config.insetLeftRightBottom,
        child: Column(
          children: [
            HolAppbar(
              backRoute: fromRoute,
              displaySettingsButton: false,
              label: "Settings",
              settingsArgs: null,
            ),
            Row(
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
          ],
        ),
      ),
    );
  }
}
