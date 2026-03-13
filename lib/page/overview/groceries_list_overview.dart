import 'package:holapp/model/groceries/list/groceries_list.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class GroceriesListOverview extends StatefulWidget {
  const GroceriesListOverview({super.key});

  @override
  State<GroceriesListOverview> createState() => _GroceriesListOverview();
}

class _GroceriesListOverview extends State<GroceriesListOverview> {
  List<GroceriesList> groceriesLists = [];
  List<GroceriesList> filteredGroceries = [];
  CheckboxState _checkboxState = CheckboxState.unchecked;

  String? listType;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    groceriesLists = [
      PersistentGroceriesList.init(name: "Rewe"),
      OneWayGroceriesList.init(name: "Edeka"),
      PersistentGroceriesList.init(name: "Lidl"),
      OneWayGroceriesList.init(name: "Aldi"),
    ];
    groceriesLists.sort((a, b) => a.date.compareTo(b.date));

    filteredGroceries = List.from(groceriesLists);
  }

  void filterGroceries(String query) {
    final filtered = groceriesLists
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredGroceries = filtered;
    });
  }

  void createNewList() {
    String name = searchController.text;

    if (name.isNotEmpty) {
      GroceriesList newList = switch (_checkboxState) {
        CheckboxState.checked => OneWayGroceriesList.init(name: name),

        _ => PersistentGroceriesList.init(name: name),
      };

      setState(() {
        groceriesLists.add(newList);
        filteredGroceries = groceriesLists;
        searchController.clear();
      });
    }
  }

  void addNewList() {
    showDialog(
      context: context,
      builder: (context) {
        String? listType;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(searchController.text),
              content: Center(
                child: Checkbox(
                  state: _checkboxState,
                  onChanged: (value) {
                    setState(() {
                      _checkboxState = value;
                    });
                  },
                  // Optional label placed on the trailing side.
                  trailing: const Text('one-way'),
                ),
              ),
              actions: [
                OutlineButton(
                  child: const Text('CANCEL'),
                  onPressed: () => Navigator.pop(context),
                ),
                DestructiveButton(
                  child: const Text('CREATE'),
                  onPressed: () => {
                    createNewList(),
                    Navigator.pop(context, listType),
                  },
                ),
              ],
            );
          },
        );
      },
    );
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
              itemBuilder: (context, index) => toCard(filteredGroceries[index]),
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
                    onSubmitted: (value) => createNewList(),
                  ),
                ),
                SizedBox(width: 8),
                PrimaryButton(
                  onPressed:
                      (searchController.text.isNotEmpty &&
                          groceriesLists.every(
                            (list) => list.name != searchController.text,
                          )
                      ? addNewList
                      : null),
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card toCard(GroceriesList list) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: Text(
              list.name,
              style: const TextStyle(fontSize: 18),
            ).semiBold(),
          ),
          switch (list) {
            OneWayGroceriesList() => Icon(BootstrapIcons.databaseDown),
            PersistentGroceriesList() => Icon(BootstrapIcons.databaseCheck),
          },
          GhostButton(
            onPressed: () => removeFromList(list),
            child: const Icon(RadixIcons.minusCircled),
          ),
        ],
      ),
    );
  }
}
