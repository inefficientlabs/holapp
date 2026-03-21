import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:holapp/config/config.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/routing/hol_go_router.dart';
import 'package:holapp/ui/core/ui/hol_appbar.dart';
import 'package:holapp/ui/core/ui/show_overlay.dart';
import 'package:holapp/ui/features/groceries/create_dialog/create_dialog.dart';
import 'package:holapp/ui/features/groceries/detail/wrapper/view/wrapper_page.dart';
import 'package:holapp/ui/features/groceries/overview/bloc/lists_bloc.dart';
import 'package:holapp/ui/features/groceries/overview/bloc/lists_event.dart';
import 'package:holapp/ui/features/groceries/overview/bloc/lists_state.dart';
import 'package:holapp/utils/filter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class GroceriesListsOverview extends StatefulWidget {
  const GroceriesListsOverview({super.key});

  @override
  State<StatefulWidget> createState() => _GroceriesListsOverview();
}

class _GroceriesListsOverview extends State<GroceriesListsOverview> {
  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListsBloc()..add(FetchListsEvent()),
      child: Scaffold(
        child: BlocBuilder<ListsBloc, ListsState>(
          builder: (context, state) {
            final bloc = context.read<ListsBloc>();

            var filtered = switch (state.filter) {
              null => state.lists,
              Filter filter => state.lists.where(
                (it) =>
                    it.name.toLowerCase().contains(filter.str.toLowerCase()),
              ),
            }.toList()..sort((a, b) => state.sort.compare(a, b));

            return Padding(
              padding: Config.insetLeftRightBottom,
              child: state.isLoading
                  ? Center(child: const CircularProgressIndicator(size: 40))
                  : Column(
                      children: [
                        HolAppbar(
                          label: "Overview",
                          displaySettingsButton: true,
                          settingsArgs: SettingsArgs(from: Routes.overview),
                          onBack: null,
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final list = filtered[index];
                              return GestureDetector(
                                onTap: () {
                                  showOverlay(
                                    context,
                                    GroceriesListWrapperPage(id: list.id),
                                  );
                                },
                                child: toCard(list),
                              );
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
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: PrimaryButton(
                                      onPressed: () async {
                                        var result =
                                            await showDialog<
                                              CreateListDialogData
                                            >(
                                              context: context,
                                              builder: (_) =>
                                                  CreateListDialog(),
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Card toCard(GroceriesList list) {
    return Card(
      child: Row(
        children: [
          Icon(list.icon),
          SizedBox(width: 16),
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
                                    children: [Text('User discretion advised')],
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
                child: const Icon(LucideIcons.pen, size: 16),
              );
            },
          ),
        ],
      ),
    );
  }
}
