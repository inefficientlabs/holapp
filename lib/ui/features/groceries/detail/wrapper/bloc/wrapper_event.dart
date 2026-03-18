import 'package:holapp/domain/models/common/id.dart';

sealed class WrapperEvent {
  const WrapperEvent();
}

class GetGroceriesListByIdEvent extends WrapperEvent {
  Id id;

  GetGroceriesListByIdEvent({required this.id});
}
