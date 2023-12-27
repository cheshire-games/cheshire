import 'package:flutter/cupertino.dart';
import 'package:princess_peanutbutter/widgets/tile.dart';

Widget buildMahjongGrid() {
  return FractionallySizedBox(
    alignment: Alignment.bottomLeft,
    widthFactor: 0.7,
    heightFactor: 0.7,
    child: GridView.count(
      crossAxisCount: 8, // Number of tiles in each row
      crossAxisSpacing: 1.5,
      mainAxisSpacing: 0.5,
      children: List.generate(8, (index) {
        return buildTile();
      })
    )
  );
}