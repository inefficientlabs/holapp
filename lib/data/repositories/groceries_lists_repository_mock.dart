import 'package:holapp/domain/models/common/id.dart';
import 'package:holapp/domain/models/groceries/item/groceries_item.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';

class GroceriesListRepositoryMock {
  static final instance = GroceriesListRepositoryMock();

  final List<GroceriesList> _lists = [
    PersistentGroceriesList.init(name: "Rewe"),
    DisposableGroceriesList.init(name: "Birthdaypardaaayy"),
    PersistentGroceriesList.init(name: "Lidl"),
    PersistentGroceriesList(
      id: Id.init(),
      name: "Aldi",
      date: DateTime.now(),
      groceries: [GroceriesItem.onePiece("item")],
    ),
  ];

  List<GroceriesList> get lists => List.unmodifiable(_lists);

  void add(GroceriesList list) {
    _lists.add(list);
  }

  void remove(GroceriesList list) {
    _lists.remove(list);
  }

  GroceriesList? findByIdOrNull(Id id) {
    return _lists.firstWhere((it) => it.id == id);
  }
}
