import 'package:uuid/uuid.dart';

class Id {
  late String id;

  // Create a UUID generator
  static final _uuid = Uuid();

  Id({required this.id});

  // Initialize with a random UUID
  Id.init() {
    id = _uuid.v4();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Id && other.id == id;
  }
}
