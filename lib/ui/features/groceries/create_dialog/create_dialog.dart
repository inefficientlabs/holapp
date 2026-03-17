import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class CreateListDialogData {
  String name = "";

  Type type = PersistentGroceriesList;

  CreateListDialogData({required this.name, required this.type});
}

class CreateListDialog extends StatefulWidget {
  const CreateListDialog({super.key});

  @override
  State<StatefulWidget> createState() => _CreateListDialog();
}

class _CreateListDialog extends State<CreateListDialog> {
  final double fontSize = 16;

  final TextEditingController _listNameController = TextEditingController();

  final SelectController<Type> _listTypeController = SelectController<Type>();

  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _listTypeController.value = PersistentGroceriesList;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter list name'),
      content: Column(
        children: [
          TextField(
            style: TextStyle(fontSize: fontSize),
            onChanged: (value) {
              _debouncer.debounce(
                duration: Duration(milliseconds: 234),
                onDebounce: () {
                  setState(() {
                    _listNameController.text = value;
                  });
                },
              );
            },
          ),
          Gap(4),
          Row(
            children: [
              Expanded(
                child: Select<Type>(
                  itemBuilder: (context, item) {
                    return Text(
                      item.toString(),
                      style: TextStyle(fontSize: fontSize),
                    );
                  },
                  popupConstraints: const BoxConstraints(
                    maxHeight: 300,
                    maxWidth: 200,
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _listTypeController.value = value;
                      });
                    }
                  },
                  value: _listTypeController.value,
                  placeholder: const Text('Select a type'),
                  popup: SelectPopup(
                    items: SelectItemList(
                      children: GroceriesList.types
                          .map(
                            (type) => SelectItemButton(
                              value: type,
                              child: Text(type.toString()),
                            ),
                          )
                          .toList(),
                    ),
                  ).call,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          enabled: _listNameController.text.isNotEmpty,
          onPressed: () {
            Navigator.pop(
              context,
              CreateListDialogData(
                name: _listNameController.text,
                type: _listTypeController.value ?? PersistentGroceriesList,
              ),
            );
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
