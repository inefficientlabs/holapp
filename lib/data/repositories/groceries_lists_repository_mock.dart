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

  Future<List<GroceriesList>> getAll() async {
    return List.unmodifiable(_lists);
  }

  Future<void> add(GroceriesList list) async {
    _lists.add(list);
  }

  Future<void> remove(GroceriesList list) async {
    _lists.remove(list);
  }

  Future<GroceriesList?> findByIdOrNull(Id id) async {
    return _lists.firstWhere((it) => it.id == id);
  }
}
