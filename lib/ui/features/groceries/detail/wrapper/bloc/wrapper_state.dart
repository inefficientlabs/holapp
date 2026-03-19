import 'package:holapp/domain/models/groceries/list/groceries_list.dart';

sealed class WrapperState {}

class Loading extends WrapperState {}

class Finished extends WrapperState {
  final GroceriesList? list;

  Finished({required this.list});
}
