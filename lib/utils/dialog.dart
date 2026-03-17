import 'package:shadcn_flutter/shadcn_flutter.dart';

Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showDialog<T>(context: context, builder: (_) => child);
}
