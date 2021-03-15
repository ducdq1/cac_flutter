import 'package:carousel_slider/carousel_slider.dart';
import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/layouts/appbar_base_widget.dart';
import 'package:citizen_app/features/digital_map/data/models/marker_info_model.dart';
import 'package:citizen_app/features/digital_map/presentation/widgets/app_bar_detail.dart';
import 'package:citizen_app/features/digital_map/presentation/widgets/marker_card.dart';
import 'package:citizen_app/features/digital_map/presentation/widgets/title_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';

class DigitalMapDetail extends StatefulWidget {
  final MarkerInfoModel marker;
  final List<MarkerInfoModel> listMarker;
  final Function(double lat, double lng) addLine;
  final Function(int show, [bool direct]) gotoMarkerCamera;
  final int show;
  final CarouselController pressMarkerCarouselController;
  DigitalMapDetail(
      {Key key,
      @required this.marker,
      this.listMarker,
      this.addLine,
      this.gotoMarkerCamera,
      this.show,
      this.pressMarkerCarouselController})
      : super(key: key);

  @override
  _DigitalMapDetailState createState() => _DigitalMapDetailState();
}

class _DigitalMapDetailState extends State<DigitalMapDetail> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No appbar provided to the Scaffold, only a body with a
      // CustomScrollView.
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              // Add the app bar to the CustomScrollView.
              AppBarDetailMarkerWidget(
                  title: widget.marker.text,
                  banner: widget.marker.imagepath,
                  scrollController: _scrollController),
              // Next, create a SliverList
              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  padding:
                      EdgeInsets.only(top: 0, bottom: 21, left: 16, right: 16),
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleWidget(
                            title: widget.marker.text,
                            scrollController: _scrollController),
                        SizedBox(height: 8),
                        Text(
                          "${widget.marker.type} - 1.1 km",
                          style: TextStyle(
                              color: SECONDARY_TEXT_COLOR,
                              fontSize: FONT_SMALL,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 8),
                        ReadMoreText(
                          widget.marker.imagepath +
                              " " +
                              widget.marker.imagepath +
                              " " +
                              widget.marker.imagepath,
                          trimLines: 3,
                          colorClickableText: PRIMARY_COLOR,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: trans(TITLE_SHOW_MORE),
                          trimExpandedText: '',
                          style: TextStyle(
                              color: PRIMARY_TEXT_COLOR,
                              fontSize: FONT_MIDDLE,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 10),
                        Stack(alignment: Alignment.centerRight, children: [
                          Divider(
                            color: Colors.black.withOpacity(0.3),
                            thickness: 0.3,
                            height: 0,
                            indent: 0,
                            endIndent: 0,
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.popUntil(context,
                                  ModalRoute.withName(ROUTER_DIGITAL_MAP));
                              await widget.gotoMarkerCamera(widget.show);
                              widget.addLine(
                                  widget.marker.geometry.coordinates[1],
                                  widget.marker.geometry.coordinates[0]);
                              // widget.gotoMarkerCamera(widget.show);
                            },
                            child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(48),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    SVG_ASSETS_PATH + 'line_marker.svg',
                                    height: 24,
                                  ),
                                )),
                          )
                        ]),
                        SizedBox(height: 6),
                        Row(
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
                        SizedBox(height: 14),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 16,
                                  child: Image.asset(
                                    ICONS_ASSETS +
                                        'icon_marker_detail_time.png',
                                  )),
                              SizedBox(width: 11),
                              Expanded(
                                child: Text(
                                  'Đang mở cửa',
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: PRIMARY_TEXT_COLOR,
                                      fontSize: FONT_MIDDLE,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ]),
                        SizedBox(height: 14),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 16,
                                  child: Image.asset(
                                    ICONS_ASSETS +
                                        'icon_marker_detail_phone.png',
                                  )),
                              SizedBox(width: 11),
                              Expanded(
                                child: Text(
                                  trans(LABEL_UPDATING),
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: PRIMARY_TEXT_COLOR,
                                      fontSize: FONT_MIDDLE,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ]),
                        SizedBox(height: 14),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 16,
                                  child: Image.asset(
                                    ICONS_ASSETS + 'icon_marker_detail_web.png',
                                  )),
                              SizedBox(width: 11),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebViewPage(
                                              title: widget.marker.text,
                                              link: 'https://google.com')),
                                    );
                                  },
                                  child: Text(
                                    'https://petrolimex.vn/petrolimex-33.html',
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: PRIMARY_COLOR,
                                        fontSize: FONT_MIDDLE,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ]),
                      ]),
                ),
              )
            ],
          ),
          Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 21.0, bottom: 48),
                width: MediaQuery.of(context).size.width,
                color: Color(0x80EBEEF0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(trans(SIMILAR_LOCATIONS),
                            style: TextStyle(
                                fontSize: FONT_MIDDLE,
                                fontWeight: FontWeight.w700))),
                    SizedBox(height: 19),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 118,
                          //aspectRatio: 16 / 9,
                          viewportFraction: 0.77,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          //reverse: false,
                          autoPlay: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          pauseAutoPlayOnTouch: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                          // onPageChanged: (index, reason) {
                          //   setState(() {
                          //     _currentImage = index;
                          //   });
                          // },
                        ),
                        items: widget.listMarker
                            .where((element) => element.id != widget.marker.id)
                            .toList()
                            .map((marker) {
                          return MarkerCard(
                            marker: marker,
                            listMarker: widget.listMarker,
                            addLine: widget.addLine,
                            gotoMarkerCamera: widget.gotoMarkerCamera,
                            pressMarkerCarouselController:
                                widget.pressMarkerCarouselController,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
