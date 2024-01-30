import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:typed_data';

const debugMode = true;
const tiles = [
  "TILE_1", "TILE_1_SEL",
  "CHARACTER_1", "CHARACTER_2", "CHARACTER_3", "CHARACTER_4", "CHARACTER_5", "CHARACTER_6", "CHARACTER_7", "CHARACTER_8", "CHARACTER_9",
  "BAMBOO_1", "BAMBOO_2", "BAMBOO_3", "BAMBOO_4", "BAMBOO_5", "BAMBOO_6", "BAMBOO_7", "BAMBOO_8", "BAMBOO_9",
  "ROD_1", "ROD_2", "ROD_3", "ROD_4", "ROD_5", "ROD_6", "ROD_7", "ROD_8", "ROD_9",
  "SEASON_1", "SEASON_2", "SEASON_3", "SEASON_4",
  "FLOWER_1", "FLOWER_2", "FLOWER_3", "FLOWER_4",
  "WIND_1", "WIND_2", "WIND_3", "WIND_4",
  "DRAGON_1", "DRAGON_2", "DRAGON_3"
];

const tilesetPath = "./assets/tilesets/";

void debug(String message) {
  if (debugMode) {
    print(message);
  }
}

void main(List<String> tilesets) async {
  if (tilesets.length == 0) {
    tilesets = [];
    await for (var file in _listFilesInDirectory(tilesetPath)) {
      final base = p.basename(file.path);
      if (!base.endsWith(".desktop")) continue;
      tilesets.add(p.basenameWithoutExtension(file.path));
    }
  }
  debug("tilesets: ${tilesets.join(', ')}");
  for (var i = 0; i < tilesets.length; i++) {
    await _pngfyTileset(tilesets[i]);
  }
}

Stream<FileSystemEntity> _listFilesInDirectory(String directoryPath) {
  debug("Listing files in directory `$directoryPath`..");
  return Directory.fromRawPath(Uint8List.fromList(
      p.canonicalize(directoryPath).codeUnits)
  ).list();
}

Future<void> _runCommand(String executable, List<String> arguments) async {
  debug("$executable ${arguments.join(' ')}");
  final result = await Process.run(executable, arguments);
  debug("OUTPUT: ${result.stdout}\n ERROR: ${result.stderr}");
}

Future<void> _pngfyTileset(String tileset) async {
  print("PNGfy tileset $tileset..");
  final desktopFile = '$tileset.desktop';
  File file = new File(tilesetPath + desktopFile);
  String futureContent = await file.readAsString();
  final lines = futureContent.split(RegExp(r"[\n\r]+"));
  final target = "$tilesetPath$tileset/";
  await Directory.fromRawPath(Uint8List.fromList(target.codeUnits))
      .create(recursive: true);

  final svgFilename = lines
      .firstWhere((line) => line.startsWith("FileName="))
      .substring("FileName=".length);
  Future.wait(tiles.map((tile) async {
    await _runCommand("inkscape", [
      "--export-type=png",
      "--export-id=$tile",
      "--export-filename=${target + tile}.png",
      p.absolute(p.canonicalize("$tilesetPath$svgFilename"))
    ]);
  }));
}