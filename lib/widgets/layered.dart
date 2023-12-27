import 'package:flutter/cupertino.dart';
import 'package:princess_peanutbutter/widgets/responsive.dart';

import 'grid.dart';

Widget buildLayeredTiles() {
  return Responsive(
    mobile: Container(),
    tablet: Container(),
    desktop: Stack(
      children: <Widget>[
        buildMahjongGrid(),
        Positioned(
          top: 5,
          left: 5,
          child: buildMahjongGrid(),
        ),
      ],
    )
  );
}