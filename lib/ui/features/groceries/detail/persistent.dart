import 'package:holapp/config/config.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/routing/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PersistentGroceriesListDetail extends StatelessWidget {
  final PersistentGroceriesList list;

  const PersistentGroceriesListDetail({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Padding(
        padding: Config.insetLeftRightBottom,
        child: Column(
          children: [
            AppBar(
              child: Row(
                children: [
                  GhostButton(
                    child: Icon(LucideIcons.arrowLeft),
                    onPressed: () {
                      router.go(Routes.overview);
                    },
                  ),
                  Expanded(child: Center(child: Text(list.name))),
                  GhostButton(
                    onPressed: () {
                      router.go(Routes.settings);
                    },
                    child: Icon(LucideIcons.settings),
                  ),
                ],
              ),
            ),
            Text(list.date.toString()),
          ],
        ),
      ),
    );
  }
}
