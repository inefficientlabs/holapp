import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:holapp/domain/models/common/id.dart';
import 'package:holapp/ui/features/groceries/detail/wrapper/view/wrapper_page.dart';
import 'package:holapp/ui/features/groceries/overview/groceries_lists_overview.dart';
import 'package:holapp/ui/features/settings/settings_view.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.overview,
      builder: (context, state) => GroceriesListsOverview(),
    ),
    GoRoute(
      path: Routes.detailId,
      builder: (context, state) {
        print(state.pathParameters);
        final pathId =
            state.pathParameters['id'] ?? (throw PathNotFoundException);

        return WrapperPage(id: Id(id: pathId));
      },
    ),
    GoRoute(path: Routes.settings, builder: (context, state) => SettingsView()),
  ],
);

class Routes {
  Routes._(); // private constructor to prevent instantiation

  static const String overview = '/';
  static const String detail = '/detail';
  static const String detailId = '/detail/:id';
  static const String settings = '/settings';
}
