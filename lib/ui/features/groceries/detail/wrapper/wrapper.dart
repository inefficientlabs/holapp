import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/ui/features/groceries/detail/disposable.dart';
import 'package:holapp/ui/features/groceries/detail/persistent.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class GroceriesListDetailWrapper extends StatelessWidget {
  final GroceriesList list;

  const GroceriesListDetailWrapper({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return switch (list) {
      DisposableGroceriesList() => DisposableGroceriesListDetail(
        list: list as DisposableGroceriesList,
      ),
      PersistentGroceriesList() => PersistentGroceriesListDetail(
        list: list as PersistentGroceriesList,
      ),
    };
  }
}
