import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:holapp/config/config.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/routing/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DisposableGroceriesListDetail extends StatelessWidget {
  final DisposableGroceriesList list;

  DisposableGroceriesListDetail({super.key, required this.list});

  final Debouncer _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Column(
        children: [
          AppBar(
            child: Row(
              children: [
                GhostButton(
                  child: Icon(LucideIcons.arrowLeft),
                  onPressed: () {
                    _debouncer.debounce(
                      duration: Config.debounceDuration,
                      onDebounce: () {
                        router.go(Routes.overview);
                      },
                    );
                  },
                ),
                Expanded(child: Center(child: Text(list.name))),
                GhostButton(child: Icon(LucideIcons.settings)),
              ],
            ),
          ),
          Text(list.date.toString()),
        ],
      ),
    );
  }
}
