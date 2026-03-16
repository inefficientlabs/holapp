import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/ui/features/groceries/overview/bloc/lists_bloc.dart';
import 'package:holapp/ui/features/groceries/overview/bloc/lists_event.dart';
import 'package:holapp/ui/features/groceries/overview/bloc/lists_state.dart';
import 'package:holapp/utils/filter.dart';
import 'package:holapp/utils/sort.dart';
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
    final bloc = context.read<ListsBloc>();

    bloc.add(FetchListsEvent());

    return Scaffold(
      child: BlocBuilder<ListsBloc, ListsState>(
        builder: (context, state) {
          var filtered = switch (state.filter) {
            null => state.lists,
            Filter filter => state.lists.where(
              (it) => it.name.toLowerCase().contains(filter.str.toLowerCase()),
            ),
          }.toList()..sort((a, b) => state.sort.compare(a, b));

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 0),
                Expanded(
                  child: ListView.separated(
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
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Select<GroceriesListSortableProperty>(
                            itemBuilder: (context, item) =>
                                Text(item.displayName()),
                            onChanged: (value) {
                              if (value != null) {
                                bloc.add(
                                  SortablePropertyChangedEvent(prop: value),
                                );
                              }
                            },
                            value: state.prop,
                            placeholder: const Text('Select a property'),
                            popup: SelectPopup(
                              items: SelectItemList(
                                children: GroceriesListSortableProperty.values
                                    .map(
                                      (type) => SelectItemButton(
                                        value: type,
                                        child: Text(type.displayName()),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ).call,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Select<SortDirection>(
                            itemBuilder: (context, item) =>
                                Text(item.displayName()),
                            onChanged: (direction) {
                              if (direction != null) {
                                bloc.add(
                                  SortDirectionChangedEvent(
                                    direction: direction,
                                  ),
                                );
                              }
                            },
                            value: state.sort.direction,
                            placeholder: const Text('Select a direction'),
                            popup: SelectPopup(
                              items: SelectItemList(
                                children:
                                    [
                                          SortDirection.ascending,
                                          SortDirection.descending,
                                        ]
                                        .map(
                                          (type) => SelectItemButton(
                                            value: type,
                                            child: Text(type.displayName()),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ).call,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            placeholder: const Text('Search'),
                            style: const TextStyle(fontSize: 18),
                            features: [
                              if (state.filter?.str.isNotEmpty ?? false)
                                InputFeature.clear(
                                  skipFocusTraversal: false,
                                  icon: GestureDetector(
                                    child: Icon(Icons.clear),
                                    onTapUp: (details) {
                                      _debouncer.debounce(
                                        duration: Duration(milliseconds: 100),
                                        onDebounce: () {
                                          searchController.clear();
                                          bloc.add(
                                            FilterChangedEvent(filter: ""),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                            onChanged: (value) {
                              _debouncer.debounce(
                                duration: Duration(milliseconds: 234),
                                onDebounce: () {
                                  bloc.add(FilterChangedEvent(filter: value));
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 4),
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
                                              bloc: bloc,
                                              builder: (context, listsState) {
                                                return SizedBox(
                                                  width: 240,
                                                  child: Select<Type>(
                                                    // How to render each selected item as text in the field.
                                                    itemBuilder:
                                                        (context, item) {
                                                          return Text(
                                                            item.toString(),
                                                          );
                                                        },
                                                    // Limit the popup size so it doesn't grow too large in the docs view.
                                                    popupConstraints:
                                                        const BoxConstraints(
                                                          maxHeight: 300,
                                                          maxWidth: 200,
                                                        ),
                                                    onChanged: (value) {
                                                      if (value != null) {
                                                        bloc.add(
                                                          ListTypeSelectionChanged(
                                                            selectedListType:
                                                                value,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    // The current selection bound to this field.
                                                    value: bloc
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
                                              bloc.add(
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
                  ],
                ),
              ],
            ),
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

            const SizedBox(width: 4),

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
