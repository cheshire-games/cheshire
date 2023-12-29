import 'package:json_schema/json_schema.dart';
import 'assets.dart';

class JsonSchemaException implements Exception {
  String cause;
  JsonSchemaException(this.cause);

  static fromErrors(List<ValidationError> errors) {
    return JsonSchemaException(errors.join("\n"));
  }
}

Future<JsonSchema> _parseSchemaFile() async {
  Map<String, dynamic> schemaJson = await getSchemaFile();
  return JsonSchema.create(schemaJson);
}

Future<JsonSchema>? _jsonSchema;
Future<JsonSchema> get jsonSchema async {
  return _jsonSchema ??= _parseSchemaFile();
}
