import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackgroundContainerWidget extends StatelessWidget {
  BackgroundContainerWidget(
      {@required this.contentWidget, this.paddingContent, this.paddingHeader});
  final Widget contentWidget;
  final EdgeInsets paddingContent;
  final EdgeInsets paddingHeader;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: paddingHeader == null
            ? EdgeInsets.fromLTRB(0, AppBar().preferredSize.height + 35, 0, 0)
            : paddingContent,
        decoration: BoxDecoration(
          color: COLOR_BACKGROUND,
        ),
        child: Container(
            padding: paddingContent ?? paddingContent,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: contentWidget));
  }
}
