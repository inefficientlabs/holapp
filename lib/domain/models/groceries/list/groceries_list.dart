import 'package:holapp/domain/models/common/id.dart';
import 'package:holapp/domain/models/groceries/item/groceries_item.dart';

typedef GroceriesListFactory = GroceriesList Function({required String name});

sealed class GroceriesList {
  late Id id;
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
    DisposableGroceriesList.register();
    PersistentGroceriesList.register();
  }
}

enum GroceriesListSortableProperty { name, count, date }

extension GroceriesListSortablePropertyExt on GroceriesListSortableProperty {
  String displayName() => switch (this) {
    GroceriesListSortableProperty.name => "name",
    GroceriesListSortableProperty.count => "count",
    GroceriesListSortableProperty.date => "date",
  };
}

class DisposableGroceriesList extends GroceriesList {
  @override
  late Id id;

  @override
  DateTime date = DateTime.now();

  @override
  List<GroceriesItem> groceries = [];

  @override
  String name;

  DisposableGroceriesList({
    required this.id,
    required this.name,
    required this.date,
    required this.groceries,
  });

  DisposableGroceriesList.init({required this.name}) {
    id = Id.init();
    date = DateTime.now();
    groceries = [];
  }

  static void register() {
    GroceriesList.register(
      DisposableGroceriesList,
      ({required String name}) => DisposableGroceriesList.init(name: name),
    );
  }
}

class PersistentGroceriesList extends GroceriesList {
  @override
  late Id id;

  @override
  DateTime date = DateTime.now();

  @override
  List<GroceriesItem> groceries = [];

  @override
  String name;

  List<GroceriesItem> history = [];

  PersistentGroceriesList({
    required this.id,
    required this.name,
    required this.date,
    required this.groceries,
  });

  PersistentGroceriesList.init({required this.name}) {
    id = Id.init();
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
