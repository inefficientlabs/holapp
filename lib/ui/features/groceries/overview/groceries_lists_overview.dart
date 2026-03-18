import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:go_router/go_router.dart';
import 'package:holapp/config/config.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/routing/hol_go_router.dart';
import 'package:holapp/ui/features/groceries/create_dialog/create_dialog.dart';
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
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListsBloc(),
      child: Builder(builder: (blocContext) => listsScaffold(blocContext)),
    );
  }

  Scaffold listsScaffold(BuildContext context) {
    final bloc = context.read<ListsBloc>();

    bloc.add(SetLoadingEvent(isLoading: true));
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
            padding: Config.insetLeftRightBottom,
            child: state.isLoading
                ? Center(child: const CircularProgressIndicator(size: 40))
                : Column(
                    children: [
                      AppBar(
                        child: Row(
                          children: [
                            SizedBox(width: 48),
                            Expanded(child: Center(child: Text("Overview"))),
                            GhostButton(
                              child: Icon(LucideIcons.settings),
                              onPressed: () {
                                context.go(Routes.settings);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: filtered.length + 1,
                          itemBuilder: (context, index) {
                            if (index < filtered.length) {
                              final list = filtered[index];
                              return GestureDetector(
                                onTap: () {
                                  context.go("/detail/${list.id.id}");
                                },
                                child: toCard(list),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: PrimaryButton(
                                  onPressed: () async {
                                    var result =
                                        await showDialog<CreateListDialogData>(
                                          context: context,
                                          builder: (_) => CreateListDialog(),
                                        );
                                    if (result != null) {
                                      bloc.add(
                                        SetLoadingEvent(isLoading: true),
                                      );
                                      bloc.add(
                                        CreateListEvent(
                                          name: result.name,
                                          type: result.type,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.add, size: 24),
                                ),
                              );
                            }
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 4),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Select<GroceriesListSortableProperty>(
                                  itemBuilder: (context, item) =>
                                      Text(item.displayName()),
                                  onChanged: (value) {
                                    if (value != null) {
                                      bloc.add(
                                        SortablePropertyChangedEvent(
                                          prop: value,
                                        ),
                                      );
                                    }
                                  },
                                  value: state.prop,
                                  placeholder: const Text('Select a property'),
                                  popup: SelectPopup(
                                    items: SelectItemList(
                                      children: GroceriesListSortableProperty
                                          .values
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
                                  itemBuilder: (context, item) => item.icon(),
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
                                  placeholder: state.sort.direction.icon(),
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
                                                  child: type.icon(),
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
                                              duration: Duration(
                                                milliseconds: 100,
                                              ),
                                              onDebounce: () {
                                                searchController.clear();
                                                bloc.add(
                                                  FilterChangedEvent(
                                                    filter: "",
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                  onChanged: (value) {
                                    _debouncer.debounce(
                                      duration: Config.debounceDuration,
                                      onDebounce: () {
                                        bloc.add(
                                          FilterChangedEvent(filter: value),
                                        );
                                      },
                                    );
                                  },
                                ),
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
                  child: const Icon(LucideIcons.menu),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
