import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class MenuSkeletonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 90, bottom: 150),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 22.0,
        runSpacing: 16.0,
        children: List.generate(
          9,
          (index) => Container(
            child: Column(
              children: [
                SkeletonAnimation(
                  shimmerColor: Colors.white24,
                  gradientColor: Color.fromARGB(0, 244, 244, 244),
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SkeletonAnimation(
                  child: Container(
                    height: 15,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(height: 4),
                SkeletonAnimation(
                  child: Container(
                    height: 15,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
