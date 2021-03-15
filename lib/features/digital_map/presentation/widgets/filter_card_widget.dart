import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';

class FilterCardWidget extends StatelessWidget {
  final String icon;
  final String text;
  final bool network;
  const FilterCardWidget(
      {Key key, @required this.icon, @required this.text, this.network})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 8, bottom: 6),
        padding: EdgeInsets.all(12),
        height: 43,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            network == true
                ? BoxShadow()
                : BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            network == true
                ? Image.network(
                    //'https://picsum.photos/250?image=9',
                    icon,
                    width: 22,
                    height: 20,
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                          decoration: BoxDecoration(
                              color: Color(0xffeffaf3),
                              borderRadius: BorderRadius.circular(16)),
                          width: 20,
                          height: 20,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  PRIMARY_COLOR),
                              strokeWidth: 1.0,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          ));
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return;
                    },
                  )
                : Image.asset(ICONS_ASSETS + icon, height: 22, width: 20),
            SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SMALL),
            ),
          ],
        ));
  }
}
