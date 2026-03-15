import 'package:holapp/model/groceries/list/groceries_list.dart';

sealed class ListsEvent {}

class FetchListsEvent extends ListsEvent {}

class FilterChangedEvent extends ListsEvent {
  String filter;

  FilterChangedEvent({required this.filter});
}

class DeleteListEvent extends ListsEvent {
  GroceriesList list;

  DeleteListEvent({required this.list});
}

class CreateListEvent extends ListsEvent {
  String name;

  CreateListEvent({required this.name});
}

class ListTypeSelectionChanged extends ListsEvent {
  Type selectedListType;

  ListTypeSelectionChanged({required this.selectedListType});
}
