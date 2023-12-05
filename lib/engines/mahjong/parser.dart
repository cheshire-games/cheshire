import 'dart:async' show Future;
import 'package:princess_peanutbutter/engines/mahjong/schema.dart';

import '../../utils/asset.dart';
import 'block.dart';
import 'constants.dart';
import 'game.dart';
import 'settings.dart';

int _calcTileIndex(int index) {
  return index ~/ 2 % totalMahjongTiles;
}

Future<Game> parseTemplateFile(String templateName) async {
  Map<String, dynamic> templateJson = await loadAssetAsJson(
      "$assetsPath/templates/$templateName.json"
  );
  return parseTemplate(templateJson);
}

List<Coordinate> _getCoordinatesFromTemplate(Map<String, dynamic> template) {
  List<Coordinate> coordinates = [];
  for (final layerObj in template['layers']) {
    final int layer = layerObj['index'];
    for (final rowObj in layerObj['rows']) {
      final int row = rowObj['index'];
      if (rowObj.containsKey("columnRange")) {
        final columnRangeObj = rowObj['columnRange'];
        for (
          var column = columnRangeObj['start'];
          column <= columnRangeObj['end'];
          column = column + columnRangeObj['increment']
        ) {
          coordinates.add(Coordinate(
              layer: layer,
              row: row,
              column: column
          ));
        }
      } else {
        for (final column in rowObj['columns']) {
          coordinates.add(Coordinate(
              layer: layer,
              row: row,
              column: column
          ));
        }
      }
    }
  }
  return coordinates;
}

Game _calcGameFromCoordinates(List<Coordinate> coordinates) {
  Settings settings = Settings();
  Set<Block> blocks = {};
  for (var (index, coordinate) in coordinates.indexed) {
    var currentBlock = Block(
        coordinate: coordinate,
        tileIndex: _calcTileIndex(index)
    );
    blocks.add(currentBlock);
    settings.updateLimitWithBlockInfo(currentBlock);
  }
  return Game(settings: settings, blocks: blocks);
}

Future<void> _validateTemplateSchema(Map<String, dynamic> template) async {
  final validationResults = (await jsonSchema).validate(template);
  if (!validationResults.isValid) {
    throw JsonSchemaException.fromErrors(validationResults.errors);
  }
}

Future<Game> parseTemplate(Map<String, dynamic> template) async {
  await _validateTemplateSchema(template);
  List<Coordinate> coordinates = _getCoordinatesFromTemplate(template);
  return _calcGameFromCoordinates(coordinates);
}
