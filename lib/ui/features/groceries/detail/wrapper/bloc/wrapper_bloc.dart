import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holapp/data/repositories/groceries_lists_repository_mock.dart';

import 'wrapper_event.dart';
import 'wrapper_state.dart';

class WrapperBloc extends Bloc<WrapperEvent, WrapperState> {
  final Duration simDuration = Duration(milliseconds: 250);

  WrapperBloc() : super(const WrapperState(isLoading: true)) {
    on<WrapperEvent>(
      (event, emit) async => switch (event) {
        GetGroceriesListByIdEvent() => await Future.delayed(
          simDuration,
          () => emit(
            state.copyWith(
              list: GroceriesListRepositoryMock.instance.findByIdOrNull(
                event.id,
              ),
              isLoading: false,
            ),
          ),
        ),
      },
    );
  }
}
