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
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              color: Color(0xffE6EFF3).withOpacity(0.6),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children : [
                  SizedBox(height:10),
                  Image.asset(
                        'assets${widget.icon}',
                        width: 60,
                        height: 60,
                      ),
              SizedBox(height:15),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 120) / 3,
                    child: Text(
                      widget.label.replaceAll("\n", "\n").replaceAll("/n", "\n"),
                      style: TextStyle(
                        fontSize: 13 ,
                        color: PRIMARY_TEXT_COLOR,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
