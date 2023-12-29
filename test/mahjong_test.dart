import 'package:flutter_test/flutter_test.dart';
import 'package:princess_peanutbutter/engines/mahjong/assets.dart';
import 'package:princess_peanutbutter/engines/mahjong/parser.dart';
import 'package:princess_peanutbutter/engines/mahjong/schema.dart';

void _testValidTemplates() {
  List<Map<String, dynamic>> validTemplates = [
    {
      "layers": [
        {
          "index": 0,
          "rows": [
            {
              "index": 0,
              "columnRange": {"start": 0, "end": 4, "increment": 2}
            },
            {
              "index": 2,
              "columnRange": {"start": 0, "end": 4, "increment": 2}
            }
          ]
        }
      ]
    },
    {
      "layers": [
        {
          "index": 0,
          "rows": [
            {
              "index": 0,
              "columns": [0, 3, 6, 9]
            }
          ]
        }
      ]
    }
  ];
  for (final (index, template) in validTemplates.indexed) {
    test("template $index is valid", () {
      expect(() => TemplateParser.parse(template), returnsNormally);
    });
  }
}

void _testInvalidSchemaTemplates() {
  List<Map<String, dynamic>> invalidTemplates = [
    {
      "layers": [
        {
          "index": 0,
          "rows": [
            {
              "columns": [2, 5, 8, 11]
            }
          ]
        }
      ]
    },
    {
      "layers": [
        {
          "rows": [
            {
              "index": 0,
              "columns": [2, 5, 8, 11]
            }
          ]
        }
      ]
    },
    {
      "layers": [
        {
          "index": 0,
          "rows": [
            {
              "index": 0,
              "columnRange": {"start": 0, "end": 4, "increment": "2"}
            }
          ]
        }
      ]
    },
    {
      "layers": [
        {
          "index": 0,
          "rows": [
            {
              "index": 0,
              "columns": ["2"]
            }
          ]
        }
      ]
    }
  ];
  for (final (index, template) in invalidTemplates.indexed) {
    test("template $index has invalid schema", () {
      expect(
          () => TemplateParser.parse(template), throwsA(isA<JsonSchemaException>()));
    });
  }
}

void _testInvalidGameTemplates() {
  List<Map<String, dynamic>> invalidTemplates = [
    {
      "layers": [
        {
          "index": 0,
          "rows": [
            {
              "index": 0,
              "columns": [2, 5]
            }
          ]
        }
      ]
    },
    {
      "layers": [
        {
          "index": 0,
          "rows": [
            {
              "index": 0,
              "columns": [2, 5, 8]
            }
          ]
        }
      ]
    },
    {
      "layers": [
        {
          "index": 0,
          "rows": [
            {
              "index": 0,
              "columns": [0]
            }
          ]
        },
        {
          "index": 1,
          "rows": [
            {
              "index": 0,
              "columns": [0]
            }
          ]
        },
        {
          "index": 2,
          "rows": [
            {
              "index": 0,
              "columns": [0]
            }
          ]
        },
        {
          "index": 3,
          "rows": [
            {
              "index": 0,
              "columns": [0]
            }
          ]
        }
      ]
    }
  ];
  for (final (index, template) in invalidTemplates.indexed) {
    test("template $index has invalid game data", () {
      expect(() => TemplateParser.parse(template), throwsA(isA<AssertionError>()));
    });
  }
}

void _testTemplateFilesValid() {
  for (var templateName in gameTemplates) {
    test("Template file `$templateName` is valid", () async {
      expect(() => TemplateParser.parseFromFile(templateName), returnsNormally);
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  _testValidTemplates();
  _testInvalidSchemaTemplates();
  _testInvalidGameTemplates();
  _testTemplateFilesValid();
}
