import 'dart:math';

import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CitizensMenuItemWidget extends StatefulWidget {
  final String label;
  final String icon;
  final String needRedirect;
  final Function onPress;

  CitizensMenuItemWidget(
      {this.label, this.icon, this.onPress, this.needRedirect});
  @override
  _CitizensMenuItemWidgetState createState() => _CitizensMenuItemWidgetState();
}

class _CitizensMenuItemWidgetState extends State<CitizensMenuItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPress();
      },
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Color(0xffE6EFF3).withOpacity(0.6),
              borderRadius: BorderRadius.circular(80),
            ),
            child: Center(
              child: widget.needRedirect == "1"
                  ? Image.network(
                      // IMAGE_ASSETS_PATH + 'icon_menu_paht.png',
                      widget.icon,
                      fit: BoxFit.contain,
                      width: 38,
                      height: 38,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return SizedBox();
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                            decoration: BoxDecoration(
                                color: Color(0xffE6EFF3),
                                borderRadius: BorderRadius.circular(64)),
                            width: 64,
                            height: 64,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    PRIMARY_COLOR),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            ));
                      },
                    )
                  : Image.asset(
                      'assets${widget.icon}',
                      width: 38,
                      height: 38,
                    ),
            ),
          ),
          SizedBox(height: 13),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 120) / 3,
            child: Text(
              widget.label.replaceAll("\n", "\n").replaceAll("/n", "\n"),
              style: TextStyle(
                fontSize: FONT_MIDDLE *
                    sqrt(MediaQuery.of(context).size.height *
                            MediaQuery.of(context).size.height +
                        MediaQuery.of(context).size.width *
                            MediaQuery.of(context).size.width) *
                    0.001,
                color: PRIMARY_TEXT_COLOR,
                fontWeight: FontWeight.normal,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
