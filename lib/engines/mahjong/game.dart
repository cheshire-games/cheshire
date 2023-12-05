import 'dart:math';

import 'settings.dart';
import 'block.dart';

enum MahjongStatus {
  none,
  fail,
  select,
  match,
}

class Game {
  final Random random = Random();
  late final Settings settings;
  late Set<Block> blocks = {};
  late int layers, rows, columns;

  late List<Block> _board;
  get board { return _board; }

  Game({required this.settings, required this.blocks}) {
    layers = settings.maxLayer - settings.minLayer + 1;
    rows = settings.maxRow - settings.minRow + 1;
    columns = settings.maxColumn - settings.minColumn + 1;

    List<Block?> board = _generateEmptyBoard();
    board = _attachAdjacentTiles(board);
    _validateGame(board);
    board = _attachPossibleBlocks(board);
    shuffle();
  }

  void detachBlock(Block blk) {
    for (var foo in blk.lefts) {
      foo.rights.remove(blk);
    }
    for (var foo in blk.rights) {
      foo.lefts.remove(blk);
    }
    for (var foo in blk.downs) {
      foo.tops.remove(blk);
    }
    for (var foo in blk.tops) {
      foo.downs.remove(blk);
    }
    blocks.remove(blk);
  }

  void attachBlock(Block blk) {
    for (var foo in blk.lefts) {
      foo.rights.add(blk);
    }
    for (var foo in blk.rights) {
      foo.lefts.add(blk);
    }
    for (var foo in blk.downs) {
      foo.tops.add(blk);
    }
    for (var foo in blk.tops) {
      foo.downs.add(blk);
    }
    blocks.add(blk);
  }

  (bool, List<Block>) _calcBoardSequence(List<Block> sequence) {
    if (blocks.isEmpty) {
      return (true, sequence);
    }

    var frees = blocks.where((foo) => foo.isFree()).toList();
    frees.shuffle(random);

    for (int i = 0; i < frees.length; i++) {
      detachBlock(frees[i]);
      sequence.add(frees[i]);

      for (int j = i + 1; j < frees.length; j++) {
        detachBlock(frees[j]);
        sequence.add(frees[j]);

        bool solvable = false;
        (solvable, sequence) = _calcBoardSequence(sequence);
        if (solvable) {
          return (true, sequence);
        }

        attachBlock(frees[j]);
        sequence.removeLast();
      }

      attachBlock(frees[i]);
      sequence.removeLast();
    }

    return (false, sequence);
  }

  MahjongStatus onClick(Block? blk, Block? last) {
    if (blk == null) {
      return MahjongStatus.none;
    }

    if (!blk.isFree()) {
      return MahjongStatus.fail;
    }

    if (last == null) {
      return MahjongStatus.select;
    }

    if (blk == last) {
      return MahjongStatus.none;
    }

    if (blk.tileIndex == last.tileIndex) {
      detachBlock(blk);
      detachBlock(last);
      return MahjongStatus.match;
    }

    return MahjongStatus.select;
  }

  bool isFail() {
    int frees = 0;
    for (var foo in blocks) {
      if (foo.isFree()) {
        frees++;
      }
    }
    return frees < 2;
  }

  void shuffle() {
    bool solvable = false;
    List<Block> sequence = [];
    (solvable, sequence) = _calcBoardSequence(sequence);
    assert(solvable, "bad game: no solution");

    for (var foo in sequence) {
      attachBlock(foo);
    }

    List<int> backup = [];
    List<int> temp = blocks.map((foo) => foo.tileIndex).toList();
    temp.sort();
    for (int i = 0; i < temp.length; i += 2) {
      backup.add(temp[i]);
    }
    backup.shuffle(random);

    for (int i = 0; i < sequence.length ~/ 2; i++) {
      sequence[i * 2].tileIndex = backup[i];
      sequence[i * 2 + 1].tileIndex = backup[i];
    }
    _board = sequence;
  }

  Block? _getBlock(List<Block?> board, int layer, int row, int column) {
    if (layer < 0 ||
        layer >= layers ||
        row < 0 ||
        row >= rows ||
        column < 0 ||
        column >= columns) {
      return null;
    }
    return board[(rows * layer + row) * columns + column];
  }

  List<Block?> _generateEmptyBoard() {
    return List.generate(layers * rows * columns, (index) => null);
  }

  List<Block?> _attachAdjacentTiles(List<Block?> board) {
    for (var currentBlock in blocks) {
      currentBlock.coordinate.layer -= settings.minLayer;
      currentBlock.coordinate.row -= settings.minRow;
      currentBlock.coordinate.column -= settings.minColumn;

      int currentIndex = columns *
          (currentBlock.coordinate.layer * rows + currentBlock.coordinate.row) +
          currentBlock.coordinate.column;
      board[currentIndex] = currentBlock;
    }
    return board;
  }

  List<Block?> _attachPossibleBlocks(List<Block?> board) {
    for (var blk in blocks) {
      for (int i = -1; i <= 1; ++i) {
        var foo = _getBlock(board, blk.coordinate.layer, blk.coordinate.row + i,
            blk.coordinate.column + 2);
        if (foo != null) {
          blk.rights.add(foo);
          foo.lefts.add(blk);
        }
      }

      if (blk.coordinate.layer < layers - 1) {
        for (int x = -1; x <= 1; ++x) {
          for (int y = -1; y <= 1; ++y) {
            var foo = _getBlock(board, blk.coordinate.layer + 1,
                blk.coordinate.row + x, blk.coordinate.column + y);
            if (foo != null) {
              blk.tops.add(foo);
              foo.downs.add(blk);
            }
          }
        }
      }
    }
    return board;
  }

  void _validateGame(List<Block?> board) {
    assert(blocks.length % 2 == 0, "bad game: odd number of blocks");
    assert(blocks.length > 2, "bad game: too few blocks");

    for (final blk in blocks) {
      for (int x = -1; x <= 1; ++x) {
        for (int y = -1; y <= 1; ++y) {
          if (x == 0 && y == 0) continue;
          var foo = _getBlock(board, blk.coordinate.layer,
              blk.coordinate.row + x, blk.coordinate.column + y);
          assert(foo == null, "bad game: overlapping blocks");
        }
      }
    }
  }
}
