import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/ui/features/groceries/overview/groceries_lists_overview.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(HolApp());
}

class HolApp extends StatelessWidget {
  const HolApp({super.key});

  @override
  Widget build(BuildContext context) {
    GroceriesList.provideFactoryRegistry();

    return ShadcnApp(title: 'hol', home: GroceriesListsOverview());
  }
}
