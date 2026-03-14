import 'package:holapp/model/groceries/groceries_item.dart';

typedef GroceriesListFactory = GroceriesList Function({required String name});

sealed class GroceriesList {
  late String name;
  late DateTime date;
  late List<GroceriesItem> groceries;

  static final Map<Type, GroceriesListFactory> _registry = {};

  static void register(Type type, GroceriesListFactory factory) {
    _registry[type] = factory;
  }

  static List<Type> get types => _registry.keys.toList();

  static GroceriesList create(Type type, {required String name}) {
    final factory =
        _registry[type] ??
        (throw Exception("GroceriesList type not registered: $type"));

    return factory(name: name);
  }

  static void provideFactoryRegistry() {
    OneWayGroceriesList.register();
    PersistentGroceriesList.register();
  }
}

class OneWayGroceriesList extends GroceriesList {
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

  OneWayGroceriesList.init({required this.name}) {
    date = DateTime.now();
    groceries = [];
  }

  static void register() {
    GroceriesList.register(
      OneWayGroceriesList,
      ({required String name}) => OneWayGroceriesList.init(name: name),
    );
  }
}

class PersistentGroceriesList extends GroceriesList {
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

  PersistentGroceriesList.init({required this.name}) {
    date = DateTime.now();
    groceries = [];
  }

  static void register() {
    GroceriesList.register(
      PersistentGroceriesList,
      ({required String name}) => PersistentGroceriesList.init(name: name),
    );
  }
}
