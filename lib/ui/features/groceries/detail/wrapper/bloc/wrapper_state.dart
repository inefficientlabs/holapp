import 'package:holapp/domain/models/groceries/list/groceries_list.dart';

class WrapperState {
  final bool isLoading;
  final GroceriesList? list;

  const WrapperState({this.isLoading = false, this.list});

  WrapperState copyWith({bool? isLoading, GroceriesList? list}) {
    return WrapperState(isLoading: isLoading ?? this.isLoading, list: list);
  }
}
