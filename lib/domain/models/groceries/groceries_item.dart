import 'package:holapp/domain/models/common/unit.dart';

class GroceriesItem<T> {
  String name;
  Unit unit;
  T amount;

  GroceriesItem(this.name, this.unit, this.amount);

  factory GroceriesItem.onePiece(String name) {
    return GroceriesItem(name, Unit.piece, 1 as T);
  }
}
