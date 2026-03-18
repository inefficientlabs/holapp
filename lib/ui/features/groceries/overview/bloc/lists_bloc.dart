import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holapp/domain/models/groceries/item/groceries_item.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/utils/filter.dart';

import 'lists_event.dart';
import 'lists_state.dart';

// basically der reducer
class ListsBloc extends Bloc<ListsEvent, ListsState> {
  ListsBloc() : super(initialListsState) {
    on<ListsEvent>(
      (event, emit) async => switch (event) {
        FetchListsEvent() => await Future.delayed(
          Duration(milliseconds: 500),
          () => emit(state.copyWith(lists: lists, isLoading: false)),
        ),
        FilterChangedEvent() => emit(
          state.copyWith(
            filter: event.filter.isEmpty ? null : Filter(str: event.filter),
          ),
        ),
        DeleteListEvent() => emit(deleteList(state, event.list)),
        CreateListEvent() => await Future.delayed(
          Duration(milliseconds: 500),
          () => emit(
            event.name.isNotEmpty
                ? state.copyWith(
                    lists: List.from(state.lists)
                      ..add(GroceriesList.create(event.type, name: event.name)),
                    isLoading: false,
                  )
                : state.copyWith(isLoading: false),
          ),
        ),
        SortablePropertyChangedEvent() => emit(
          state.copyWith(
            prop: event.prop,
            sort: switch (event.prop) {
              GroceriesListSortableProperty.name => sortByName(
                state.sort.direction,
              ),

              GroceriesListSortableProperty.count => sortByLength(
                state.sort.direction,
              ),
              GroceriesListSortableProperty.date => sortByDate(
                state.sort.direction,
              ),
            },
          ),
        ),
        SortDirectionChangedEvent() => emit(
          state.copyWith(sort: state.sort.copyWith(direction: event.direction)),
        ),
        SetLoadingEvent() => emit(state.copyWith(isLoading: event.isLoading)),
      },
    );
  }
}

ListsState deleteList(ListsState state, GroceriesList list) {
  List<GroceriesList> newList = state.lists..remove(list);

  return state.copyWith(lists: newList);
}

List<GroceriesList> lists = [
  PersistentGroceriesList.init(name: "Rewe"),
  DisposableGroceriesList.init(name: "Birthdaypardaaayy"),
  PersistentGroceriesList.init(name: "Lidl"),
  PersistentGroceriesList(
    name: "Aldi",
    date: DateTime.now(),
    groceries: [GroceriesItem.onePiece("item")],
  ),
];
