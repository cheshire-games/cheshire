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
  final Random _random = Random();
  final Settings _settings;
  final Set<Block> _blocks;
  late int _layers, _rows, _columns;

  late final List<Block> _board;
  get board { return _board; }

  Game({required Settings settings, required Set<Block> blocks}):
        _blocks = blocks, _settings = settings {
    prepareGame() {
      initGameCoordinates() {
        _layers = _settings.maxLayer - _settings.minLayer + 1;
        _rows = _settings.maxRow - _settings.minRow + 1;
        _columns = _settings.maxColumn - _settings.minColumn + 1;
      }
      initGameCoordinates();

      List<Block?> generateEmptyBoard() {
        return List.generate(_layers * _rows * _columns, (index) => null);
      }
      List<Block?> dummyBoard = generateEmptyBoard();

      placeBlocksOnBoard() {
        Block adjustBlockCoordinates(Block block) {
          return Block(
              tileIndex: block.tileIndex,
              coordinates: Coordinates(
                  layer: block.coordinates.layer - _settings.minLayer,
                  row: block.coordinates.row - _settings.minRow,
                  column: block.coordinates.column - _settings.minColumn
              )
          );
        }

        int calcTileIndex(Coordinates coordinates) {
          return _columns * (coordinates.layer * _rows + coordinates.row) +
              coordinates.column;
        }

        for (var currentBlock in _blocks) {
          currentBlock = adjustBlockCoordinates(currentBlock);
          int currentIndex = calcTileIndex(currentBlock.coordinates);
          dummyBoard[currentIndex] = currentBlock;
        }
      }
      placeBlocksOnBoard();

      validateGame() {
        assert(_blocks.length % 2 == 0, "bad game: odd number of blocks");
        assert(_blocks.length > 2, "bad game: too few blocks");

        for (final blk in _blocks) {
          for (int x = -1; x <= 1; ++x) {
            for (int y = -1; y <= 1; ++y) {
              if (x == 0 && y == 0) continue;
              var foo = _getBlock(dummyBoard, blk.coordinates.layer,
                  blk.coordinates.row + x, blk.coordinates.column + y);
              assert(foo == null, "bad game: overlapping blocks");
            }
          }
        }
      }
      validateGame();

      attachPossibleBlocks() {
        for (var blk in _blocks) {
          for (int i = -1; i <= 1; ++i) {
            var foo = _getBlock(dummyBoard, blk.coordinates.layer, blk.coordinates.row + i,
                blk.coordinates.column + 2);
            if (foo != null) {
              blk.rights.add(foo);
              foo.lefts.add(blk);
            }
          }

          if (blk.coordinates.layer < _layers - 1) {
            for (int x = -1; x <= 1; ++x) {
              for (int y = -1; y <= 1; ++y) {
                var foo = _getBlock(dummyBoard, blk.coordinates.layer + 1,
                    blk.coordinates.row + x, blk.coordinates.column + y);
                if (foo != null) {
                  blk.tops.add(foo);
                  foo.downs.add(blk);
                }
              }
            }
          }
        }
      }
      attachPossibleBlocks();
    }
    prepareGame();
    shuffle();
  }

  // interface
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
      _detachBlock(blk);
      _detachBlock(last);
      return MahjongStatus.match;
    }

    return MahjongStatus.select;
  }

  bool isFailed() {
    int frees = 0;
    for (var foo in _blocks) {
      if (foo.isFree()) {
        frees++;
      }
    }
    return frees < 2;
  }

  shuffle() {
    bool solvable = false;
    List<Block> sequence = [];
    (solvable, sequence) = _calcBoardSequence(sequence);
    assert(solvable, "bad game: no solution");

    for (var foo in sequence) {
      _attachBlock(foo);
    }

    List<int> backup = [];
    List<int> temp = _blocks.map((foo) => foo.tileIndex).toList();
    temp.sort();
    for (int i = 0; i < temp.length; i += 2) {
      backup.add(temp[i]);
    }
    backup.shuffle(_random);

    for (int i = 0; i < sequence.length ~/ 2; i++) {
      sequence[i * 2].tileIndex = backup[i];
      sequence[i * 2 + 1].tileIndex = backup[i];
    }
    _board = sequence;
  }

  // internal
  (bool, List<Block>) _calcBoardSequence(List<Block> sequence) {
    if (_blocks.isEmpty) {
      return (true, sequence);
    }

    final frees = _blocks.where((foo) => foo.isFree()).toList();
    frees.shuffle(_random);

    for (int i = 0; i < frees.length; i++) {
      _detachBlock(frees[i]);
      sequence.add(frees[i]);

      for (int j = i + 1; j < frees.length; j++) {
        _detachBlock(frees[j]);
        sequence.add(frees[j]);

        bool solvable = false;
        (solvable, sequence) = _calcBoardSequence(sequence);
        if (solvable) {
          return (true, sequence);
        }

        _attachBlock(frees[j]);
        sequence.removeLast();
      }

      _attachBlock(frees[i]);
      sequence.removeLast();
    }

    return (false, sequence);
  }

  void _detachBlock(Block blk) {
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
    _blocks.remove(blk);
  }

  void _attachBlock(Block blk) {
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
    _blocks.add(blk);
  }

  Block? _getBlock(List<Block?> board, int layer, int row, int column) {
    if (layer < 0 ||
        layer >= _layers ||
        row < 0 ||
        row >= _rows ||
        column < 0 ||
        column >= _columns) {
      return null;
    }
    return board[(_rows * layer + row) * _columns + column];
  }
}
