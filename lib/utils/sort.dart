import 'package:shadcn_flutter/shadcn_flutter.dart';

class Sort<T, V extends Comparable<V>> {
  final V Function(T item) selector;
  final SortDirection direction;

  const Sort({required this.selector, required this.direction});

  int compare(T a, T b) {
    final result = selector(a).compareTo(selector(b));
    return direction == SortDirection.descending ? -result : result;
  }

  Sort<T, V> copyWith({
    V Function(T item)? selector,
    SortDirection? direction,
  }) {
    return Sort<T, V>(
      selector: selector ?? this.selector,
      direction: direction ?? this.direction,
    );
  }
}

extension SortDirectionExt on SortDirection {
  String displayName() => switch (this) {
    SortDirection.none => "-",
    SortDirection.ascending => "ascending",
    SortDirection.descending => "descending",
  };

  Icon icon() => Icon(switch (this) {
    SortDirection.none => Icons.line_axis,
    SortDirection.ascending => Icons.arrow_upward,
    SortDirection.descending => Icons.arrow_downward,
  });

  Text displayText() => Text(displayName());
}
