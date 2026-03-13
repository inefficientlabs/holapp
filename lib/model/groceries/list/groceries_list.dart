import 'package:holapp/model/groceries/groceries_item.dart';

sealed class GroceriesList {
  late String name;
  late DateTime date;
  late List<GroceriesItem> groceries;
}

class OneWayGroceriesList implements GroceriesList {
  @override
  DateTime date = DateTime.now();

  @override
  List<GroceriesItem> groceries = [];

  @override
  String name;

  OneWayGroceriesList({
    required this.name,
    required this.date,
    required this.groceries,
  });

  OneWayGroceriesList.init({required this.name});
}

class PersistentGroceriesList implements GroceriesList {
  @override
  DateTime date = DateTime.now();

  @override
  List<GroceriesItem> groceries = [];

  @override
  String name;

  List<GroceriesItem> history = [];

  PersistentGroceriesList({
    required this.name,
    required this.date,
    required this.groceries,
  });

  PersistentGroceriesList.init({required this.name});
}
