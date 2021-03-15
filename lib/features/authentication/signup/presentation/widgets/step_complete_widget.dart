import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const COMPLETE_SIZE = 20.0;
const UNCOMPLETE_SIZE = 16.0;

class StepCompleteWidget extends StatefulWidget {
  final int total;
  final int completeIndex;
  final double width;

  StepCompleteWidget({this.total, this.completeIndex = -1, this.width = 150});

  @override
  _StepCompleteWidgetState createState() => _StepCompleteWidgetState();
}

class _StepCompleteWidgetState extends State<StepCompleteWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.total, (index) {
          if (index <= widget.completeIndex) {
            return Row(
              children: [
                SvgPicture.asset(
                  SVG_ASSETS_PATH + 'icon_complete.svg',
                  height: 20,
                  width: 20,
                ),
                Container(
                  width: widget.width / 3,
                  color: PRIMARY_COLOR,
                  height: 1,
                )
              ],
            );
          } else {
            if (index <= widget.completeIndex + 1) {
              if (index == widget.total - 1) {
                return SvgPicture.asset(
                  SVG_ASSETS_PATH + 'icon_uncomplete.svg',
                  height: 12,
                  width: 12,
                );
              } else {
                return Row(
                  children: [
                    SvgPicture.asset(
                      SVG_ASSETS_PATH + 'icon_uncomplete.svg',
                      height: 12,
                      width: 12,
                    ),
                    Container(
                      width: widget.width / 3,
                      height: 1,
                      color: Color.fromRGBO(15, 142, 112, 0.3),
                    )
                  ],
                );
              }
            } else if (index == widget.total - 1) {
              return SvgPicture.asset(
                SVG_ASSETS_PATH + 'icon_disable_complete.svg',
                height: 12,
                width: 12,
              );
            } else {
              return Row(
                children: [
                  SvgPicture.asset(
                    SVG_ASSETS_PATH + 'icon_disable_complete.svg',
                    height: 12,
                    width: 12,
                  ),
                  Container(
                    width: widget.width / 3,
                    height: 1,
                    color: Color.fromRGBO(15, 142, 112, 0.3),
                  )
                ],
              );
            }
          }
        }).toList(),
      ),
    );
  }
}
