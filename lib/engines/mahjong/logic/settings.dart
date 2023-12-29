import 'dart:math';
import 'block.dart';

const highValueFlag = 999;
const lowValueFlag = -999;

class Settings {
  late int
      maxLayer = lowValueFlag, minLayer = highValueFlag,
      maxRow = lowValueFlag, minRow = highValueFlag,
      maxColumn = lowValueFlag, minColumn = highValueFlag;

  updateLimitWithBlockInfo(Block block) {
    maxLayer = max(maxLayer, block.coordinates.layer);
    minLayer = min(minLayer, block.coordinates.layer);
    maxRow = max(maxRow, block.coordinates.row);
    minRow = min(minRow, block.coordinates.row);
    maxColumn = max(maxColumn, block.coordinates.column);
    minColumn = min(minColumn, block.coordinates.column);
  }
}