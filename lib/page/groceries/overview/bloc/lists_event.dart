import 'package:holapp/model/groceries/list/groceries_list.dart';

sealed class ListsEvent {}

class FetchListsEvent extends ListsEvent {}

class FilterListsEvent extends ListsEvent {
  String query;

  FilterListsEvent({required this.query});
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
