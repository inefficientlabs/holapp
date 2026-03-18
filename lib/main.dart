import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/routing/hol_go_router.dart';
import 'package:holapp/ui/features/settings/settings_controller.dart';
import 'package:holapp/ui/features/settings/settings_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() async {
  final settingsController = SettingsController();
  await settingsController.loadSettings();

  runApp(
    SettingsProvider(controller: settingsController, child: const HolApp()),
  );
}

class HolApp extends StatelessWidget {
  const HolApp({super.key});

  @override
  Widget build(BuildContext context) {
    GroceriesList.provideFactoryRegistry();

    final settingsController = SettingsProvider.of(context);

    return ShadcnApp.router(
      title: 'hol',
      routerConfig: router,
      darkTheme: ThemeData.dark(),
      themeMode: settingsController.themeMode,
    );
  }
}
