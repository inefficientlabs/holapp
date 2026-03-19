import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holapp/data/repositories/groceries_lists_repository_mock.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/utils/filter.dart';

import 'lists_event.dart';
import 'lists_state.dart';

// basically der reducer
class ListsBloc extends Bloc<ListsEvent, ListsState> {
  final Duration simDuration = Duration(milliseconds: 250);

  ListsBloc() : super(initialListsState) {
    on<ListsEvent>(
      (event, emit) async => switch (event) {
        FetchListsEvent() => emit(
          state.copyWith(
            lists: await GroceriesListRepositoryMock.instance.getAll(),
            isLoading: false,
          ),
        ),
        FilterChangedEvent() => emit(
          state.copyWith(
            filter: event.filter.isEmpty ? null : Filter(str: event.filter),
          ),
        ),
        DeleteListEvent() => {
          GroceriesListRepositoryMock.instance.remove(event.list),

          emit(
            state.copyWith(
              lists: await GroceriesListRepositoryMock.instance.getAll(),
            ),
          ),
        },
        CreateListEvent() => () async {
          if (event.name.isNotEmpty) {
            await GroceriesListRepositoryMock.instance.add(
              GroceriesList.create(event.type, name: event.name),
            );

            final lists = await GroceriesListRepositoryMock.instance.getAll();

            emit(state.copyWith(lists: lists, isLoading: false));
          } else {
            emit(state.copyWith(isLoading: false));
          }
        }(),
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
