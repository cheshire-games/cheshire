import 'dart:math';

import 'block.dart';
import 'constants.dart';

class Settings {
  late int
      maxLayer = lowValueFlag, minLayer = highValueFlag,
      maxRow = lowValueFlag, minRow = highValueFlag,
      maxColumn = lowValueFlag, minColumn = highValueFlag;

  updateLimitWithBlockInfo(Block block) {
    maxLayer = max(maxLayer, block.coordinate.layer);
    minLayer = min(minLayer, block.coordinate.layer);
    maxRow = max(maxRow, block.coordinate.row);
    minRow = min(minRow, block.coordinate.row);
    maxColumn = max(maxColumn, block.coordinate.column);
    minColumn = min(minColumn, block.coordinate.column);
  }
}