import 'package:holapp/model/groceries/list/groceries_list.dart';

class ListsState {
  final List<GroceriesList> lists;
  final List<GroceriesList> filtered;
  final Type selectedListType;

  ListsState({
    required this.lists,
    required this.filtered,
    required this.selectedListType,
  });

  // Builder/copy method
  ListsState copyWith({
    List<GroceriesList>? lists,
    List<GroceriesList>? filtered,
    var selectedListType,
  }) {
    return ListsState(
      lists: lists ?? this.lists,
      filtered: filtered ?? this.filtered,
      selectedListType: selectedListType ?? this.selectedListType,
    );
  }
}

final ListsState initialListsState = ListsState(
  filtered: List.empty(),
  lists: List.empty(),
  selectedListType: PersistentGroceriesList,
);
