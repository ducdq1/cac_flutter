import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SkeletonPahtWidget extends StatelessWidget {
  final int itemCount;

  const SkeletonPahtWidget({Key key, this.itemCount=7}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xffB9B9B9), width: 0.3))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonWidget(width: 96, height: 96.0),
                      SizedBox(height: 20),
                      SkeletonWidget(width: 96, height: 15.0),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonWidget(width: 165, height: 18),
                        SizedBox(height: 8),
                        SkeletonWidget(
                            width: MediaQuery.of(context).size.width,
                            height: 50),
                        SizedBox(height: 7),
                        SkeletonWidget(width: 100, height: 15),
                        SizedBox(
                          height: 14,
                        ),
                        SkeletonWidget(width: 100, height: 15),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: itemCount,
        ));
  }
}
