import 'package:go_router/go_router.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/ui/features/groceries/detail/disposable.dart';
import 'package:holapp/ui/features/groceries/detail/persistent.dart';
import 'package:holapp/ui/features/groceries/overview/groceries_lists_overview.dart';
import 'package:holapp/ui/features/settings/settings_view.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.overview,
      builder: (context, state) => GroceriesListsOverview(),
    ),
    GoRoute(
      path: Routes.detail,
      builder: (context, state) {
        final list = state.extra as GroceriesList;

        return switch (list) {
          DisposableGroceriesList() => DisposableGroceriesListDetail(
            list: list,
          ),
          PersistentGroceriesList() => PersistentGroceriesListDetail(
            list: list,
          ),
        };
      },
    ),
    GoRoute(path: Routes.settings, builder: (context, state) => SettingsView()),
  ],
);

class Routes {
  Routes._(); // private constructor to prevent instantiation

  static const String overview = '/';
  static const String detail = '/detail';
  static const String settings = '/settings';
}
