import 'package:holapp/domain/models/common/id.dart';

sealed class GroceriesListWrapperEvent {}

class GetGroceriesListByIdEvent extends GroceriesListWrapperEvent {
  Id id;

  GetGroceriesListByIdEvent({required this.id});
}
