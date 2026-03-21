import 'package:holapp/config/config.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/routing/hol_go_router.dart';
import 'package:holapp/ui/core/ui/hol_appbar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DisposableGroceriesListDetail extends StatelessWidget {
  final DisposableGroceriesList list;

  const DisposableGroceriesListDetail({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: Config.insetLeftRightBottom,
        child: Column(
          children: [
            HolAppbar(
              onBack: () => Navigator.pop(context),
              displaySettingsButton: true,
              label: list.name,
              settingsArgs: SettingsArgs(from: Routes.detailId(list.id)),
            ),
            Text(list.date.toString()),
          ],
        ),
      ),
    );
  }
}
