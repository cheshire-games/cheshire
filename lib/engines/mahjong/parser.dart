import 'dart:async' show Future;
import 'package:princess_peanutbutter/engines/mahjong/schema.dart';

import 'assets.dart';
import 'logic/block.dart';
import 'logic/game.dart';
import 'logic/settings.dart';

class TemplateParser {
  static const totalMahjongTiles = 144;

  static Future<Game> parseFromFile(String templateName) async {
    Map<String, dynamic> templateJson = await getTemplateFile(templateName);
    return parse(templateJson);
  }

  static Future<Game> parse(Map<String, dynamic> template) async {
    Future<void> validateTemplateSchema(Map<String, dynamic> template) async {
      final validationResults = (await jsonSchema).validate(template);
      if (!validationResults.isValid) {
        throw JsonSchemaException.fromErrors(validationResults.errors);
      }
    }
    await validateTemplateSchema(template);

    List<Coordinates> getCoordinatesFromTemplate(Map<String, dynamic> template) {
      List<Coordinates> coordinates = [];
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
              coordinates.add(Coordinates(
                  layer: layer,
                  row: row,
                  column: column
              ));
            }
          } else {
            for (final column in rowObj['columns']) {
              coordinates.add(Coordinates(
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
    List<Coordinates> coordinates = getCoordinatesFromTemplate(template);

    Game calcGameFromCoordinates(List<Coordinates> coordinates) {
      Settings settings = Settings();
      Set<Block> blocks = {};

      int calcTileIndex(int index) {
        return index ~/ 2 % totalMahjongTiles;
      }

      for (var (index, coordinate) in coordinates.indexed) {
        var currentBlock = Block(
            coordinates: coordinate,
            tileIndex: calcTileIndex(index)
        );
        blocks.add(currentBlock);
        settings.updateLimitWithBlockInfo(currentBlock);
      }
      return Game(settings: settings, blocks: blocks);
    }
    return calcGameFromCoordinates(coordinates);
  }
}