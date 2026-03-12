import 'package:holapp/model/groceries/groceries_item.dart';

class GroceriesList {
  String name;
  DateTime date = DateTime.now();
  List<GroceriesItem> groceries = [];

  GroceriesList({
    required this.name,
    required this.date,
    required this.groceries,
  });

  GroceriesList.init({required this.name});
}

class PersistentGroceriesList extends GroceriesList {
  List<GroceriesItem> history = [];

  PersistentGroceriesList({
    required super.name,
    required super.date,
    required super.groceries,
    required this.history,
  });
}
