import 'package:holapp/model/groceries/groceries_list.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class GroceriesListOverview extends StatefulWidget {
  const GroceriesListOverview({super.key});

  @override
  State<GroceriesListOverview> createState() => _GroceriesListOverview();
}

class _GroceriesListOverview extends State<GroceriesListOverview> {
  List<GroceriesList> groceriesLists = [];
  List<GroceriesList> filteredGroceries = [];
  String newName = "";

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    groceriesLists = [
      GroceriesList.init(name: "Rewe"),
      GroceriesList.init(name: "Edeka"),
      GroceriesList.init(name: "Lidl"),
      GroceriesList.init(name: "Aldi"),
    ];
    filteredGroceries = List.from(groceriesLists);
  }

  void filterGroceries(String query) {
    final filtered = groceriesLists
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredGroceries = filtered;
      newName = query;
    });
  }

  void create(String name) {
    if (name.isNotEmpty) {
      setState(() {
        groceriesLists.add(GroceriesList.init(name: name));
        filteredGroceries = groceriesLists;
        searchController.clear();
        newName = "";
      });
    }
  }

  void createNewList() {
    create(newName);
  }

  void removeFromList(GroceriesList list) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete list'),
          content: const Text('ARRRR YOU SURE'),
          actions: [
            OutlineButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            DestructiveButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  groceriesLists.remove(list);
                  filteredGroceries = groceriesLists;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [AppBar(title: const Text('hol'))],
      child: Column(
        children: [
          const Divider(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: filteredGroceries.length,
              itemBuilder: (context, index) => toList(filteredGroceries[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 18),
                    placeholder: const Text(
                      style: TextStyle(fontSize: 18),
                      'Search',
                    ),
                    controller: searchController,
                    onChanged: filterGroceries,
                    onSubmitted: (value) => create(value),
                  ),
                ),
                SizedBox(width: 8),
                PrimaryButton(
                  onPressed: (newName.isNotEmpty ? createNewList : null),
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget toList(GroceriesList list) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Row(
          children: [
            Expanded(
              child: Text(
                list.name,
                style: const TextStyle(fontSize: 18),
              ).semiBold(),
            ),
            GhostButton(
              onPressed: () => removeFromList(list),
              child: const Icon(Icons.remove_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
