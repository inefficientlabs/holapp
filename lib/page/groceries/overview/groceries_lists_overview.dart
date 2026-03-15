import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:holapp/model/common/filter.dart';
import 'package:holapp/model/groceries/list/groceries_list.dart';
import 'package:holapp/page/groceries/overview/bloc/lists_bloc.dart';
import 'package:holapp/page/groceries/overview/bloc/lists_event.dart';
import 'package:holapp/page/groceries/overview/bloc/lists_state.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class GroceriesListsOverview extends StatelessWidget {
  GroceriesListsOverview({super.key});

  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListsBloc(),
      child: Builder(builder: (blocContext) => listsScaffold(blocContext)),
    );
  }

  void openList(GroceriesList list) {
    print("open ${list.name}");
  }

  Scaffold listsScaffold(BuildContext context) {
    final listsBloc = context.read<ListsBloc>();

    listsBloc.add(FetchListsEvent());

    return Scaffold(
      child: BlocBuilder<ListsBloc, ListsState>(
        builder: (context, state) {
          var filtered = switch (state.filter) {
            null => state.lists,
            Filter filter => state.lists.where(
              (it) => it.name.toLowerCase().contains(filter.str.toLowerCase()),
            ),
          }.toList();

          return Column(
            children: [
              const Divider(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      _debouncer.debounce(
                        duration: Duration(milliseconds: 234),
                        onDebounce: () {
                          openList(filtered[index]);
                        },
                      );
                    },
                    child: toCard(filtered[index]),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        placeholder: const Text('Search'),
                        style: const TextStyle(fontSize: 18),
                        onChanged: (value) {
                          _debouncer.debounce(
                            duration: Duration(milliseconds: 234),
                            onDebounce: () {
                              listsBloc.add(FilterChangedEvent(filter: value));
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    PrimaryButton(
                      onPressed:
                          (filtered.isEmpty &&
                              (searchController.text.isNotEmpty))
                          ? () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: Text(
                                      'Create ${searchController.text}',
                                    ),
                                    content: Builder(
                                      builder: (innerContext) {
                                        return BlocBuilder<
                                          ListsBloc,
                                          ListsState
                                        >(
                                          bloc: listsBloc,
                                          builder: (context, listsState) {
                                            return SizedBox(
                                              width: 240,
                                              child: Select<Type>(
                                                // How to render each selected item as text in the field.
                                                itemBuilder: (context, item) {
                                                  return Text(item.toString());
                                                },
                                                // Limit the popup size so it doesn't grow too large in the docs view.
                                                popupConstraints:
                                                    const BoxConstraints(
                                                      maxHeight: 300,
                                                      maxWidth: 200,
                                                    ),
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    listsBloc.add(
                                                      ListTypeSelectionChanged(
                                                        selectedListType: value,
                                                      ),
                                                    );
                                                  }
                                                },
                                                // The current selection bound to this field.
                                                value: listsBloc
                                                    .state
                                                    .selectedListType,
                                                placeholder: const Text(
                                                  'Select a type',
                                                ),
                                                popup: SelectPopup(
                                                  items: SelectItemList(
                                                    children: GroceriesList
                                                        .types
                                                        .map(
                                                          (
                                                            type,
                                                          ) => SelectItemButton(
                                                            value: type,
                                                            child: Text(
                                                              type.toString(),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                ).call,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    actions: [
                                      PrimaryButton(
                                        onPressed: () {
                                          listsBloc.add(
                                            CreateListEvent(
                                              name: searchController.text,
                                            ),
                                          );
                                          Navigator.pop(dialogContext);
                                        },
                                        child: Text("CREATE"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          : null,
                      child: const Icon(Icons.add, size: 24),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Card toCard(GroceriesList list) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.name,
                    style: const TextStyle(fontSize: 18),
                  ).semiBold(),

                  const SizedBox(height: 4),

                  Text(list.runtimeType.toString()).muted(),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Builder(
              builder: (context) {
                return GhostButton(
                  onPressed: () {
                    final bloc = context.read<ListsBloc>();

                    showDropdown(
                      context: context,
                      builder: (context) {
                        return DropdownMenu(
                          children: [
                            MenuButton(child: Text('Edit')),
                            MenuButton(
                              child: Text('Delete'),
                              onPressed: (_) => showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Delete ${list.name}'),
                                    content: Row(
                                      children: [
                                        Text('User discretion advised'),
                                      ],
                                    ),
                                    actions: [
                                      OutlineButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      DestructiveButton(
                                        child: Icon(LucideIcons.trash),
                                        onPressed: () {
                                          bloc.add(DeleteListEvent(list: list));
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(LucideIcons.settings),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
