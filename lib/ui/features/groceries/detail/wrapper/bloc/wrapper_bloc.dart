import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holapp/data/repositories/groceries_lists_repository_mock.dart';

import 'wrapper_event.dart';
import 'wrapper_state.dart';

class GroceriesListWrapperBloc
    extends Bloc<GroceriesListWrapperEvent, GroceriesListWrapperState> {
  GroceriesListWrapperBloc() : super(Loading()) {
    on<GroceriesListWrapperEvent>(
      (event, emit) async => switch (event) {
        GetGroceriesListByIdEvent() => emit(
          Finished(
            list: await GroceriesListRepositoryMock.instance.findByIdOrNull(
              event.id,
            ),
          ),
        ),
      },
    );
  }
}
