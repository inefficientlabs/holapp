import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:shadcn_flutter/shadcn_flutter_experimental.dart';

sealed class ListsEvent {}

class FetchListsEvent extends ListsEvent {}

class FilterChangedEvent extends ListsEvent {
  String filter;

  FilterChangedEvent({required this.filter});
}

class SortablePropertyChangedEvent extends ListsEvent {
  GroceriesListSortableProperty prop;

  SortablePropertyChangedEvent({required this.prop});
}

class SortDirectionChangedEvent extends ListsEvent {
  SortDirection direction;

  SortDirectionChangedEvent({required this.direction});
}

class DeleteListEvent extends ListsEvent {
  GroceriesList list;

  DeleteListEvent({required this.list});
}

class CreateListEvent extends ListsEvent {
  String name;
  Type type;

  CreateListEvent({required this.name, required this.type});
}
