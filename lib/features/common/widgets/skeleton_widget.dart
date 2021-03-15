import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonWidget extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final List<double> radiusCustom;

  const SkeletonWidget(
      {Key key, this.width, this.height, this.radius, this.radiusCustom})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radiusCustom != null
          ? BorderRadius.only(
              topLeft: Radius.circular(radiusCustom[0] ?? 0),
              topRight: Radius.circular(radiusCustom[1] ?? 0),
              bottomRight: Radius.circular(radiusCustom[2] ?? 0),
              bottomLeft: Radius.circular(radiusCustom[3] ?? 0),
            )
          : BorderRadius.circular(radius ?? 5),
      child: SkeletonAnimation(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: radiusCustom != null
                ? BorderRadius.only(
                    topLeft: Radius.circular(radiusCustom[0] ?? 0),
                    topRight: Radius.circular(radiusCustom[1] ?? 0),
                    bottomRight: Radius.circular(radiusCustom[2] ?? 0),
                    bottomLeft: Radius.circular(radiusCustom[3] ?? 0),
                  )
                : BorderRadius.circular(radius ?? 5),
          ),
        ),
      ),
    );
  }
}
