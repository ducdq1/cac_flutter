import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/digital_map/data/models/marker_info_model.dart';
import 'package:citizen_app/features/digital_map/presentation/pages/digital_map_detail.dart';
import 'package:flutter/material.dart';

class MarkerCard extends StatelessWidget {
  final MarkerInfoModel marker;
  final List<MarkerInfoModel> listMarker;
  final Function addLine;
  final Function(int show, [bool direct]) gotoMarkerCamera;
  final CarouselController pressMarkerCarouselController;
  const MarkerCard(
      {Key key,
      @required this.marker,
      this.listMarker,
      this.addLine,
      this.gotoMarkerCamera,
      this.pressMarkerCarouselController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        int show = 0;
        for (int i = 0; i < listMarker.length; i++) {
          if (listMarker[i].id == marker.id) {
            show = i;
            break;
          }
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DigitalMapDetail(
                marker: marker,
                listMarker: listMarker,
                addLine: addLine,
                gotoMarkerCamera: gotoMarkerCamera,
                show: show,
                pressMarkerCarouselController: pressMarkerCarouselController),
          ),
        );
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          width: MediaQuery.of(context).size.width * 0.72,
          height: 118,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  marker.text,
                  style: TextStyle(
                      fontSize: FONT_MIDDLE, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${marker.type} - 1.1 km",
                  style: TextStyle(
                      fontSize: FONT_SMALL,
                      fontWeight: FontWeight.w400,
                      color: SECONDARY_TEXT_COLOR),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 65,
                        child: AutoSizeText(
                          'Đang mở cửa',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: PRIMARY_TEXT_COLOR,
                              fontSize: FONT_SMALL,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          int show = 0;
                          for (int i = 0; i < listMarker.length; i++) {
                            if (listMarker[i].id == marker.id) {
                              show = i;
                              break;
                            }
                          }
                          Navigator.popUntil(
                              context, ModalRoute.withName(ROUTER_DIGITAL_MAP));
                          await gotoMarkerCamera(show);
                          addLine(marker.geometry.coordinates[1],
                              marker.geometry.coordinates[0]);
                        },
                        child: Container(
                            // width: MediaQuery.of(context).size.width / 2 - 65,
                            padding: EdgeInsets.all(9.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                border: Border.all(
                                    width: 1, color: Color(0xffEBEEF0))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    ICONS_ASSETS + 'icon_marker_line.png',
                                    height: 16),
                                SizedBox(width: 5.75),
                                SizedBox(
                                  // width: MediaQuery.of(context).size.width / 2 -
                                  //     105,
                                  child: AutoSizeText(trans(TITLE_DIRECT),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: PRIMARY_COLOR,
                                          fontSize: FONT_SMALL,
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            )),
                      )
                    ])
              ],
            ),
          )),
    );
  }
}
