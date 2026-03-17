enum Unit {
  milliliter,
  tablespoon,
  kilogram,
  teaspoon,
  packet,
  liter,
  piece,
  slice,
  pinch,
  gram,
  cup,
}

extension UnitExtension on Unit {
  String toAbbreviation() {
    return switch (this) {
      Unit.milliliter => "ml", // corrected spelling
      Unit.tablespoon => "tbsp",
      Unit.kilogram => "kg",
      Unit.teaspoon => "tsp",
      Unit.packet => "pkt", // can vary by region
      Unit.liter => "l",
      Unit.piece => "pc", // "p" is ambiguous
      Unit.slice => "slc", // "sl" may be confusing
      Unit.pinch => "pinch", // usually written in full
      Unit.gram => "g",
      Unit.cup => "cup", // "c" could be confused with Celsius
    };
  }
}
