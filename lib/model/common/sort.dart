import 'package:shadcn_flutter/shadcn_flutter.dart';

class Sort {
  String propertyName;
  SortDirection direction;

  Sort({required this.propertyName, required this.direction})
    : assert(propertyName.isNotEmpty);
}
