import 'package:ed_mahjong/engine/layouts/layout.dart';
import 'package:ed_mahjong/engine/layouts/top_down_generator.dart';

Future<void> main() async {
  Layout layout = layoutDefault();
  final layoutPrecalc = layout.getPrecalc();

  List<int> retriesCollector = [];

  const tries = 5000;

  final lowest = retriesCollector.fold<int>(
      9999999,
      (previousValue, element) =>
          element < previousValue ? element : previousValue);

  final highest = retriesCollector.fold<int>(
      0,
      (previousValue, element) =>
          element > previousValue ? element : previousValue);

  final sum = retriesCollector.fold<int>(
      0, (previousValue, element) => element + previousValue);

  print(
      "min retries: $lowest, max retries: $highest, avg retries: ${sum / tries}");
}

List<List<List<bool>>> parseLayout(List<List<String>> str) {
  return str
      .map((layer) => layer
          .map((row) =>
              row.split('').map((t) => t == 'x').toList(growable: false))
          .toList(growable: false))
      .toList(growable: false);
}

Layout layoutDefault() {
  return Layout(parseLayout([
    [
      "   x x x x x x x x x x x x      ",
      "                                ",
      "       x x x x x x x x          ",
      "                                ",
      "     x x x x x x x x x x        ",
      "                                ",
      "   x x x x x x x x x x x x      ",
      " x                         x x  ",
      "   x x x x x x x x x x x x      ",
      "                                ",
      "     x x x x x x x x x x        ",
      "                                ",
      "       x x x x x x x x          ",
      "                                ",
      "   x x x x x x x x x x x x      ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "         x x x x x x            ",
      "                                ",
      "         x x x x x x            ",
      "                                ",
      "         x x x x x x            ",
      "                                ",
      "         x x x x x x            ",
      "                                ",
      "         x x x x x x            ",
      "                                ",
      "         x x x x x x            ",
      "                                ",
      "                                ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "           x x x x              ",
      "                                ",
      "           x x x x              ",
      "                                ",
      "           x x x x              ",
      "                                ",
      "           x x x x              ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "             x x                ",
      "                                ",
      "             x x                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "              x                 ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
    ]
  ]));
}

Layout layoutDifficult() {
  return Layout(parseLayout([
    [
      "x                              x",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "x                              x",
    ],
    [
      "                                ",
      " x                            x ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      " x                            x ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "  x                          x  ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "  x                          x  ",
      "                                ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "                                ",
      "   x                        x   ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "   x                        x   ",
      "                                ",
      "                                ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "    x                      x    ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "    x                      x    ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "     x                    x     ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "     x                    x     ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "      x                  x      ",
      "                                ",
      "                                ",
      "      x                  x      ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "       x                x       ",
      "       x                x       ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
    ],
    [
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "        xxxxxxxxxxxxxxxx        ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
      "                                ",
    ]
  ]));
}

Layout layoutUnsolvable() {
  return Layout(parseLayout([
    [
      "x",
    ],
    [
      "x",
    ],
    [
      "x",
    ],
    [
      "x",
    ],
    [
      "x",
    ]
  ]));
}
