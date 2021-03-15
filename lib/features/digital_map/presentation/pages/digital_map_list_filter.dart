import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/digital_map/data/models/marker_info_model.dart';
import 'package:citizen_app/features/digital_map/presentation/widgets/digital_map_list_filter_card_widget.dart';
import 'package:flutter/material.dart';

class DigitalMapListFilter extends StatefulWidget {
  final List<MarkerInfoModel> listMarker;
  final String valueSearchBox;
  final Function(int show, [bool direct]) gotoMarkerCamera;
  final Function(double lat, double lng) addLine;
  DigitalMapListFilter(
      {Key key,
      @required this.listMarker,
      this.valueSearchBox,
      this.gotoMarkerCamera,
      this.addLine})
      : super(key: key);

  @override
  _DigitalMapListFilterState createState() => _DigitalMapListFilterState();
}

class _DigitalMapListFilterState extends State<DigitalMapListFilter> {
  int _show = -1;

  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
        title: trans(TITLE_DIGITAL_MAP_SCREEN),
        centerTitle: true,
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: MediaQuery.of(context).size.width - 32,
                    height: 44,
                    decoration: BoxDecoration(
                      color: FILTER_CONTAINER_COLOR,
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          ICONS_ASSETS + 'icon_filter_bds.png',
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: 13.5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          child: Text(widget.valueSearchBox,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: FONT_MIDDLE)),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black.withOpacity(0.3),
                  thickness: 0.3,
                  height: 0,
                  indent: 16,
                  endIndent: 16,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      for (int i = 0; i < widget.listMarker.length; i++)
                        InkWell(
                            onTap: () {
                              setState(() {
                                _show != i ? _show = i : _show = -1;
                              });
                            },
                            child: DigitalMapListFilterCard(
                                marker: widget.listMarker[i],
                                moreInfo: _show != i ? false : true,
                                addLine: widget.addLine,
                                gotoMarkerCamera: () =>
                                    widget.gotoMarkerCamera(i))),
                      SizedBox(height: 120)
                    ],
                  ),
                ),
              ],
            ),
            _show < 0
                ? SizedBox()
                : Positioned(
                    bottom: 50,
                    left: 16,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        widget.gotoMarkerCamera(_show, false);
                      },
                      child: Container(
                          padding: EdgeInsets.all(9.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36),
                            border:
                                Border.all(width: 1, color: Color(0xffEBEEF0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset:
                                    Offset(0, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Image.asset(ICONS_ASSETS + 'icon_map.png',
                                    height: 24),
                                SizedBox(width: 14),
                                Text(trans(VIEW_MAP),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: SECONDARY_TEXT_COLOR,
                                        fontSize: FONT_MIDDLE,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          )),
                    ),
                  )
          ],
        ));
  }
}
