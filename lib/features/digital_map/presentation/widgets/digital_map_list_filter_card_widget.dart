import 'package:auto_size_text/auto_size_text.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/digital_map/data/models/marker_info_model.dart';
import 'package:flutter/material.dart';

class DigitalMapListFilterCard extends StatefulWidget {
  final MarkerInfoModel marker;
  final bool moreInfo;
  final Function(double lat, double lng) addLine;
  final Function gotoMarkerCamera;
  DigitalMapListFilterCard(
      {Key key,
      @required this.marker,
      @required this.moreInfo,
      this.addLine,
      this.gotoMarkerCamera})
      : super(key: key);

  @override
  _DigitalMapListFilterCardState createState() =>
      _DigitalMapListFilterCardState();
}

class _DigitalMapListFilterCardState extends State<DigitalMapListFilterCard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 + 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.marker.text,
                      style: TextStyle(
                          fontSize: FONT_MIDDLE, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${widget.marker.type} - 1.1 km",
                      style: TextStyle(
                          fontSize: FONT_SMALL,
                          fontWeight: FontWeight.w400,
                          color: SECONDARY_TEXT_COLOR),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Đang mở cửa',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: PRIMARY_TEXT_COLOR,
                          fontSize: FONT_SMALL,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Center(
                  child: InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  await widget.gotoMarkerCamera();
                  widget.addLine(widget.marker.geometry.coordinates[1],
                      widget.marker.geometry.coordinates[0]);
                },
                child: Container(
                    padding: EdgeInsets.all(9.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(width: 1, color: Color(0xffEBEEF0))),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(ICONS_ASSETS + 'icon_marker_line.png',
                              height: 16),
                          SizedBox(width: 5.75),
                          AutoSizeText(trans(TITLE_DIRECT),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: PRIMARY_COLOR,
                                  fontSize: FONT_SMALL,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    )),
              ))
            ],
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn,
            vsync: this,
            child: widget.moreInfo
                ? SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 11.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 16,
                                child: Image.asset(
                                  ICONS_ASSETS +
                                      'icon_marker_detail_address.png',
                                )),
                            SizedBox(width: 11),
                            Expanded(
                              child: Text(
                                widget.marker.placeName,
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: PRIMARY_TEXT_COLOR,
                                    fontSize: FONT_MIDDLE,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ]),
                    ),
                  )
                : SizedBox(),
          ),
          SizedBox(height: 18),
          Divider(
            color: Colors.black.withOpacity(0.3),
            thickness: 0.3,
            height: 0,
            indent: 0,
            endIndent: 0,
          ),
        ],
      ),
    );
  }
}
