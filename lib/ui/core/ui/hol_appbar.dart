import 'package:holapp/routing/hol_go_router.dart';
import 'package:holapp/ui/core/ui/show_overlay.dart';
import 'package:holapp/ui/features/settings/settings_view.dart';
import 'package:shadcn_flutter/shadcn_flutter_experimental.dart';

class HolAppbar extends StatelessWidget {
  final SettingsArgs? settingsArgs;
  final String label;
  final bool displaySettingsButton;
  final VoidCallback? onBack;

  const HolAppbar({
    super.key,
    required this.displaySettingsButton,
    required this.label,
    required this.settingsArgs,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: switch (onBack) {
              void Function() onBack => GhostButton(
                onPressed: onBack,
                child: Icon(LucideIcons.x),
              ),

              null => null,
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 52,
            child: displaySettingsButton
                ? GhostButton(
                    onPressed: () {
                      if (settingsArgs != null) {
                        showOverlay(context, SettingsView());
                      }
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
