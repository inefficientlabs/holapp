import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/utils/filter.dart';
import 'package:holapp/utils/sort.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ListsState {
  final List<GroceriesList> lists;
  final Type selectedListType;

  final Sort sort;
  final GroceriesListSortableProperty prop;
  final Filter? filter;

  ListsState({
    required this.lists,
    required this.selectedListType,
    required this.sort,
    required this.prop,
    required this.filter,
  });

  // Builder/copy method
  ListsState copyWith({
    List<GroceriesList>? lists,
    var selectedListType,
    var sort,
    var prop,
    var filter,
  }) {
    return ListsState(
      lists: lists ?? this.lists,
      selectedListType: selectedListType ?? this.selectedListType,
      sort: sort ?? this.sort,
      prop: prop ?? this.prop,
      filter: filter,
    );
  }
}

final ListsState initialListsState = ListsState(
  lists: List.empty(),
  selectedListType: PersistentGroceriesList,
  sort: sortByLength(SortDirection.descending),
  prop: GroceriesListSortableProperty.name,
  filter: null,
);

Sort<GroceriesList, String> sortByName(SortDirection direction) =>
    Sort<GroceriesList, String>(selector: (l) => l.name, direction: direction);

Sort<GroceriesList, DateTime> sortByDate(SortDirection direction) =>
    Sort<GroceriesList, DateTime>(
      selector: (l) => l.date,
      direction: direction,
    );

Sort<GroceriesList, String> sortByLength(SortDirection direction) =>
    Sort<GroceriesList, String>(
      selector: (l) => l.groceries.length.toString(),
      direction: direction,
    );
