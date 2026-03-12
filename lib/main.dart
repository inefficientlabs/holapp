import 'package:holapp/page/overview/groceries_list_overview.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(HolApp());
}

class HolApp extends StatelessWidget {
  const HolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(title: 'hol', home: GroceriesListOverview());
  }
}
