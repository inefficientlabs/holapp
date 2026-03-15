import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holapp/model/common/filter.dart';
import 'package:holapp/model/groceries/list/groceries_list.dart';

import 'lists_event.dart';
import 'lists_state.dart';

// basically der reducer
class ListsBloc extends Bloc<ListsEvent, ListsState> {
  ListsBloc() : super(initialListsState) {
    on<ListsEvent>(
      (event, emit) => switch (event) {
        FetchListsEvent() => emit(
          state.copyWith(lists: lists, filtered: lists),
        ),
        FilterChangedEvent() => emit(
          state.copyWith(
            filter: event.filter.isEmpty ? null : Filter(str: event.filter),
          ),
        ),
        DeleteListEvent() => emit(deleteList(state, event.list)),
        CreateListEvent() => emit(
          event.name.isNotEmpty
              ? createAndAdd(state, state.selectedListType, event.name)
              : state,
        ),

        ListTypeSelectionChanged() => emit(
          state.copyWith(selectedListType: event.selectedListType),
        ),
      },
    );
  }
}

ListsState deleteList(ListsState state, GroceriesList list) {
  List<GroceriesList> newList = state.lists..remove(list);

  return state.copyWith(lists: newList, filtered: newList);
}

ListsState createAndAdd(ListsState state, Type type, String name) {
  List<GroceriesList> newList = List.from(state.lists)
    ..add(GroceriesList.create(type, name: name));

  return state.copyWith(lists: newList, filtered: newList);
}

List<GroceriesList> lists = [
  PersistentGroceriesList.init(name: "Rewe"),
  DisposableGroceriesList.init(name: "Birthdaypardaaayy"),
  PersistentGroceriesList.init(name: "Lidl"),
];
