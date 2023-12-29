import '../../utils/asset.dart';

const assetsPath = "assets/mahjong";
const gameTemplates = ["standard"];

Future<Map<String, dynamic>> getTemplateFile(String templateName) async {
  return await loadAssetAsJson("$assetsPath/templates/$templateName.json");
}

Future<Map<String, dynamic>> getSchemaFile() async {
  return await loadAssetAsJson("$assetsPath/schema.json");
}