import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holapp/data/repositories/groceries_lists_repository_mock.dart';

import 'wrapper_event.dart';
import 'wrapper_state.dart';

class WrapperBloc extends Bloc<WrapperEvent, WrapperState> {
  WrapperBloc() : super(Loading()) {
    on<WrapperEvent>(
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
