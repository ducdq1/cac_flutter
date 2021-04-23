import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/skeleton_widget.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerWidget extends StatefulWidget {
  // final double scale;
  final ScrollController scrollController;
  final StopScrollController stopScrollController;

  BannerWidget({
    this.scrollController,
    this.stopScrollController,
  });

  @override
  _BannerWidgetState createState() => _BannerWidgetState(stopScrollController);
}

class _BannerWidgetState extends State<BannerWidget> {
  _BannerWidgetState(StopScrollController _stopScrollController) {
    _stopScrollController.stopScroll = stopScroll;
  }

  double widthCustom = 500;
  int _currentImage = 0;
  double opacity = 1;
  void stopScroll() {
    if (opacity > 0.7 && opacity < 1) {
      opacity = 1.0;
      // scale = 1.0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      });
    }
    if (opacity > 0 && opacity <= 0.7) {
      opacity = 0.0;
      // scale = 0.0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.scrollController.animateTo(
          ((widthCustom + 16) / 3) + 20,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      });
    }
  }

  @override
  void initState() {
    // setState(() {
    //   reload += 1;
    // });
    widget.scrollController.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double percent = 1 - (widget.scrollController.offset / (1200));
    setState(() {
      opacity = percent;
    });
    // scale = percent;
    if (opacity > 1.0)
      setState(() {
        opacity = 1.0;
      });
    if (opacity < 0.0)
      setState(() {
        opacity = 0.0;
      });
    // if (percent > 1.0) scale = 1.0;
    // setState(() {
    //   closeTopContainer = _scrollController.offset > 50;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final pref = singleton<SharedPreferences>();
    String fullName = pref.get('fullName');
    widthCustom = MediaQuery.of(context).size.width - 32;
    DateTime dateTime = DateTime.now();
    String hello = '';
    if (dateTime.hour < 12) {
      hello = 'Chào buổi sáng,';
    } else if (dateTime.hour < 18) {
      hello = 'Chào buổi chiều,';
    } else {
      hello = 'Chào buổi tối,';
    }

    return Opacity(
      opacity: opacity,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(opacity, opacity),
        child:
            BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
          if (state is HomePageFailure) {
            return Center(
              child: Container(
                width: widthCustom,
                height: 120,
                decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      width: 0.3, color: Colors.black.withOpacity(0.3)),
                ),
                child: Center(
                  child: Image.asset(
                    IMAGE_ASSETS_PATH + "icon_none.png",
                    height: ((widthCustom + 16) / 3),
                    width: 160,
                  ),
                ),
              ),
            );
          }
          if (state is HomePageSuccess) {
            return Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      height: 120,
                      //aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      //reverse: false,
                      autoPlay: false,
                      pauseAutoPlayInFiniteScroll: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      pauseAutoPlayOnTouch: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: false,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentImage = index;
                        });
                      }),
                  items: state.appModules.headers
                      .where((element) => element.isActive == '1')
                      .toList()
                      .map((value) {
                    return InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => WebViewPage(
                        //           title: value.name, link: value.link)),
                        // );
                      },
                      child: Container(
                        width: widthCustom,
                        height: 120,
                        decoration: BoxDecoration(
                          color: PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Container(
                                width: widthCustom,
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    IMAGE_ASSETS_PATH + 'banner.png',
                                    fit: BoxFit.cover,
                                    width: widthCustom,
                                    height: 120,
                                  ),
                                )),
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 23.0, right: 23),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      // width: widthCustom * 1.8 / 3,
                                      //height: 120,
                                      child: Row(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                hello,
                                                style: TextStyle(
                                                  fontSize: FONT_MIDDLE  ,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                fullName != null
                                                    ? fullName.toUpperCase()
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: FONT_LARGE,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ]),
                                      ]),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // Positioned.fill(
                //     child: Align(
                //         alignment: Alignment.bottomCenter,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: state.appModules.headers
                //               .asMap()
                //               .entries
                //               .map((url) {
                //            // int index = url.key;
                //             return SizedBox();
                //             //   Container(
                //             //   width: 8.0,
                //             //   height: 8.0,
                //             //   margin: EdgeInsets.symmetric(
                //             //       vertical: 12.0, horizontal: 2.0),
                //             //   decoration: BoxDecoration(
                //             //       shape: BoxShape.circle,
                //             //       color: _currentImage == index
                //             //           ? Color(0xffEE0033)
                //             //           : Color(0xffEBEEF0)),
                //             // );
                //           }).toList(),
                //         )))
              ],
            );
          }
          return Center(
              child: SkeletonWidget(
            width: widthCustom,
            height: 120,
            radius: 16,
          ));
        }),
      ),
    );
  }
}
