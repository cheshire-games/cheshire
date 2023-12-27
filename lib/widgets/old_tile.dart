import 'package:flutter/material.dart';

class OldTile extends StatelessWidget {
  final String imageURL;
  final double borderRadius;
  final List<Color> gradientColors;
  final Offset shadowOffset;
  final double shadowBlurRadius;

  const OldTile({
    super.key,
    required this.imageURL,
    this.borderRadius = 10.0,
    this.gradientColors = const [Colors.white, Color(0xFFCCCCCC)],
    this.shadowOffset = const Offset(0, 3),
    this.shadowBlurRadius = 7.0
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.topCenter,
      widthFactor: 0.06,
      heightFactor: 0.16,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green,
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(1), BlendMode.dstATop),
            image: NetworkImage(imageURL, scale: 1.0),
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 7,
              blurRadius: shadowBlurRadius,
              offset: shadowOffset,
            ),
          ],
        ),
      ),
    );
  }
}
