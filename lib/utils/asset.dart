import 'dart:convert';

import 'package:flutter/services.dart';

Future<String> loadAssetFromFile(String assetPath) async {
  return await rootBundle.loadString(assetPath);
}

Future<Map<String, dynamic>> loadAssetAsJson(String assetPath) async {
  String assetContent = await loadAssetFromFile(assetPath);
  return await json.decode(assetContent);
}