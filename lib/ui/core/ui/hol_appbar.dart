import 'package:go_router/go_router.dart';
import 'package:holapp/routing/hol_go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter_experimental.dart';

class HolAppbar extends StatelessWidget {
  final SettingsArgs? settingsArgs;
  final String? backRoute;
  final String label;
  final bool displaySettingsButton;

  const HolAppbar({
    super.key,
    required this.backRoute,
    required this.displaySettingsButton,
    required this.label,
    required this.settingsArgs,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: switch (backRoute) {
              String route => GhostButton(
                onPressed: () {
                  context.go(route);
                },
                child: Icon(LucideIcons.arrowLeft),
              ),
              null => null,
            },
          ),
          Expanded(child: Center(child: Text(label))),
          SizedBox(
            width: 48,
            child: displaySettingsButton
                ? GhostButton(
                    onPressed: () {
                      context.go(Routes.settings, extra: settingsArgs);
                    },
                    child: Icon(LucideIcons.settings),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
