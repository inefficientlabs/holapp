import 'package:holapp/model/common/unit.dart';

class GroceriesItem<T> {
  String name;
  Unit unit;
  T amount;

  GroceriesItem(this.name, this.unit, this.amount);
}
