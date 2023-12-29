class Coordinates {
  // For convenience, a block occupies 2 rows and 2 columns
  late int layer, row, column;

  Coordinates({required this.layer, required this.row, required this.column});
}

class Block {
  late final Coordinates coordinates;
  late int tileIndex;

  /* In a usual game, a block can be selected when no block is atop of it and
   * no block is blocking at least one side */
  Set<Block> lefts = {};
  Set<Block> rights = {};
  Set<Block> tops = {};
  Set<Block> downs = {};

  bool isFree() {
    return tops.isEmpty && (rights.isEmpty || lefts.isEmpty);
  }

  Block({required this.coordinates, required this.tileIndex});
}
