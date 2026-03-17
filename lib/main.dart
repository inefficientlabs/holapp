import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/routing/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(HolApp());
}

class HolApp extends StatelessWidget {
  const HolApp({super.key});

  @override
  Widget build(BuildContext context) {
    GroceriesList.provideFactoryRegistry();

    return ShadcnApp.router(title: 'hol', routerConfig: router);
  }
}
