import 'package:holapp/model/common/filter.dart';
import 'package:holapp/model/common/sort.dart';
import 'package:holapp/model/groceries/list/groceries_list.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ListsState {
  final List<GroceriesList> lists;
  final Type selectedListType;

  final Sort sort;
  final Filter? filter;

  ListsState({
    required this.lists,
    required this.selectedListType,
    required this.sort,
    required this.filter,
  });

  // Builder/copy method
  ListsState copyWith({
    List<GroceriesList>? lists,
    List<GroceriesList>? filtered,
    var selectedListType,
    var sort,
    var filter,
  }) {
    return ListsState(
      lists: lists ?? this.lists,
      selectedListType: selectedListType ?? this.selectedListType,
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
    );
  }
}

final ListsState initialListsState = ListsState(
  lists: List.empty(),
  selectedListType: PersistentGroceriesList,
  sort: Sort(propertyName: "name", direction: SortDirection.none),
  filter: null,
);
