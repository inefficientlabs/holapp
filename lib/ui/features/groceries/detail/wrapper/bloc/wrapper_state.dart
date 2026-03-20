import 'package:holapp/domain/models/groceries/list/groceries_list.dart';

sealed class GroceriesListWrapperState {}

class Loading extends GroceriesListWrapperState {}

class Finished extends GroceriesListWrapperState {
  final GroceriesList? list;

  Finished({required this.list});
}
