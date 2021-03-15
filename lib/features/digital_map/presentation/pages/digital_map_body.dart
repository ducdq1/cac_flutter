import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/digital_map/data/models/filter_category_model.dart';
import 'package:citizen_app/features/digital_map/data/models/marker_info_model.dart';
import 'package:citizen_app/features/digital_map/presentation/blocs/filter_category/filter_category_bloc.dart';
import 'package:citizen_app/features/digital_map/presentation/blocs/marker_info/marker_info_bloc.dart';
import 'package:citizen_app/features/digital_map/presentation/pages/digital_map_categories_menu.dart';
import 'package:citizen_app/features/digital_map/presentation/pages/digital_map_list_filter.dart';
import 'package:citizen_app/features/digital_map/presentation/widgets/filter_card_widget.dart';
import 'package:citizen_app/features/digital_map/presentation/widgets/marker_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:vtmap_gl/vtmap_gl.dart';
import 'dart:io' show Platform;

class DigitalMapBody extends StatefulWidget {
  DigitalMapBody({Key key}) : super(key: key);

  @override
  _DigitalMapBodyState createState() => _DigitalMapBodyState();
}

class _DigitalMapBodyState extends State<DigitalMapBody> {
  //Controller
  TextEditingController _controllerText;
  MapboxMapController controller;
  CarouselController pressMarkerCarouselController = CarouselController();

  LocationData _currentLocation;
  double _latitude = 16.05963693382427;
  double _longitude = 108.21664467782574;
  MarkerInfoBloc _markerInfoBloc;

  //Check loading circule ở bên phải text field
  bool loadingPosition = false;

  //Check text field empty?
  bool filterBoxEmpty = true;

  //Text field value
  String valueSearchBox = "";
  //List<WayPoint> _selectedLine;

  //marker đang chọn, dùng để xóa và sửa vị trí marker đang chọn
  Symbol markerSelected;

  //Vị trí của Carousel, sử dụng khi xử lý top vào marker, nếu lướt carousel cách thông thường từ indexTap = -1
  int indexTap = -1;

  //Check press Button "Chỉ đường" -> press thì direct = true
  bool direct = false;

  //Check line direct -> Đang chỉ đường thì isDirecting = true
  bool isDirecting = false;
  double directLatitude;
  double directLongitude;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerText = TextEditingController();
    _markerInfoBloc = BlocProvider.of<MarkerInfoBloc>(context);
  }

  @override
  void dispose() {
    _controllerText.dispose();
    controller?.onSymbolTapped?.remove(_onSymbolTapped);
    super.dispose();
  }

  void _handleSubmitText(String valueSubmit) async {
    _clearLine();
    indexTap = null;
    setState(() {
      // _selectedLine = null;
      loadingPosition = true;
      valueSearchBox = valueSubmit;
    });
    _markerInfoBloc.add(ListMarkerInfoFetched(
        query: valueSubmit, proximity: [_longitude, _latitude]));
    _markerInfoBloc.listen(
      (state) {
        if (state is MarkerInfoSuccess) {
          _onStyleLoaded(state.listMarkerInfo);
        }
      },
    );
    await Future.delayed(Duration(milliseconds: 300));
    indexTap = -1;
  }

  void _handleSubmitButton(String valueSubmit) {
    _handleSubmitText(valueSubmit);
    _controllerText.text = valueSubmit;
    FocusScope.of(context).unfocus();
    setState(() {
      filterBoxEmpty = false;
    });
  }

  //!LINE
  // Add Line to map
  void _addLine(double latitude, double longitude) async {
    if (_currentLocation != null) {
      await _clearLine();
      setState(() {
        isDirecting = true;
      });
      print("isDirecting: $isDirecting");

      directLatitude = latitude;
      directLongitude = longitude;
      var wayPoints = List<WayPoint>();
      final _stop1 = WayPoint(
          name: "Way Point 2", latitude: latitude, longitude: longitude);
      final _origin = WayPoint(
          name: "Way Point 1",
          latitude: _currentLocation.latitude,
          longitude: _currentLocation.longitude);

      wayPoints.add(_origin);
      wayPoints.add(_stop1);
      controller.buildRoute(wayPoints: wayPoints);

      _updatePositionMarker(markerSelected, LatLng(latitude, longitude));
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
          LatLng(_currentLocation.latitude, _currentLocation.longitude), 16);
      controller.animateCamera(cameraUpdate);
      indexTap = -1;
      direct = false;
    } else {
      Fluttertoast.showToast(msg: trans(LABEL_REQUIRE_GPS));
    }
  }

  //Hiển thị các bước đường đi
  void _showDirectDetail() {
    var wayPoints = List<WayPoint>();
    final _stop1 = WayPoint(
        name: "Way Point 4",
        latitude: directLatitude,
        longitude: directLongitude);
    final _origin = WayPoint(
        name: "Way Point 3",
        latitude: _currentLocation.latitude,
        longitude: _currentLocation.longitude);

    wayPoints.add(_origin);
    wayPoints.add(_stop1);

    controller.startNavigation(
        wayPoints: wayPoints,
        options: VTMapOptions(
          access_token: ACCESS_TOKEN_VTMAPS,
          mode: VTMapNavigationMode.driving,
          simulateRoute: false,
          zoom: 100,
          language: "vi",
        ));
  }

  Future<void> _clearLine() async {
    await controller.clearRoute();
    setState(() {
      isDirecting = false;
    });
  }

  //!MARKER
  void _onStyleLoaded(List<MarkerInfoModel> listMarker) async {
    print("_onStyleLoaded");
    await _clearMarkers();
    markerSelected = null;
    // List<Uint8List> lists = await addImageFromNetwork(listMarker);

    // await addImageFromAsset('markerSelected');

    // Add Marker Selected (init: 0)
    if (markerSelected == null) {
      await addImageFromAsset('markerSelected');
      markerSelected = await _addAndCatchMarker('markerSelected', [-100, -100]);
    }

    for (int i = 0; i < listMarker.length; i++) {
      await addImageFromAsset(
          i.toString(),
          Platform.isIOS
              ? 'assets/icons/icon_other_bds_2x.png'
              : 'assets/icons/icon_other_bds_3x.png');
      _addMarker(i.toString(), listMarker[i].center);
    }

    // //Network
    // for (int i = 0; i < listMarker.length; i++) {
    //   // controller.addImage(listMarker[i].text, lists[i]);
    //   // _addMarker(listMarker[i].text, listMarker[i].center);
    //   controller.addImage(i.toString(), lists[i]);
    //   _addMarker(i.toString(), listMarker[i].center);
    // }

    setState(() {
      loadingPosition = false;
    });
  }

  void _addMarker(String iconImage, List<double> center) {
    List<int> availableNumbers = Iterable<int>.generate(12).toList();
    controller.symbols.forEach(
        (s) => availableNumbers.removeWhere((i) => i == s.data['count']));

    if (availableNumbers.isNotEmpty) {
      controller.addSymbol(
          _getSymbolOptions(iconImage, availableNumbers.first, center),
          {'count': availableNumbers.first});
    }
  }

  Future<Symbol> _addAndCatchMarker(String iconImage, List<double> center) {
    List<int> availableNumbers = Iterable<int>.generate(12).toList();
    controller.symbols.forEach(
        (s) => availableNumbers.removeWhere((i) => i == s.data['count']));

    return controller.addSymbol(
        _getSymbolOptions(iconImage, availableNumbers.first, center),
        {'count': availableNumbers.first});
  }

  Future<void> _clearMarkers() {
    return controller.clearSymbols();
  }

  Future<void> _removeMarker(Symbol marker) {
    return controller.removeSymbol(marker);
  }

  void _updatePositionMarker(Symbol marker, LatLng geometry) {
    SymbolOptions markerOption = SymbolOptions(geometry: geometry);

    controller.updateSymbol(
      marker,
      marker.options.copyWith(markerOption),
    );
  }

  SymbolOptions _getSymbolOptions(
      String iconImage, int symbolCount, List<double> latLngFilter) {
    // LatLng center = LatLng(latLngFilter[1], latLngFilter[0]);
    LatLng center = LatLng(latLngFilter[1], latLngFilter[0]);
    LatLng geometry = LatLng(center.latitude, center.longitude);
    return SymbolOptions(
      geometry: geometry,
      iconImage: iconImage,
    );
  }

  // Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, [String assetName]) async {
    String defaultAssest = Platform.isIOS
        ? 'assets/icons/icon_gps_2x.png'
        : 'assets/icons/icon_gps_3x.png';
    final ByteData bytes = await rootBundle.load(assetName ?? defaultAssest);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  // Adds a network image
  Future<List<Uint8List>> addImageFromNetwork(
      List<MarkerInfoModel> listMarker) async {
    print("convert to utf8 - doing");
    List<Uint8List> lists = [];

    var responses = await Future.wait([
      for (MarkerInfoModel marker in listMarker) http.get(marker.markername),
    ]);
    print("convert to utf8 - get_http_done");
    print(responses);
    for (var i = 0; i < responses.length; i++) {
      lists.add(await _handleImageFetchedToUint8List(responses[i]));
    }
    print("convert to utf8 - convert_utf_done");
    print("convert to utf8 - done");
    return lists;
  }

  _handleImageFetchedToUint8List(http.Response response) async {
    Uint8List list;
    if (response.statusCode <= 299)
      list = response.bodyBytes.buffer.asUint8List();
    else {
      final ByteData bytes =
          await rootBundle.load('assets/icons/icon_other_bds_3x.png');
      list = bytes.buffer.asUint8List();
    }
    return list;
  }

  _gotoMarkerCamera(int show, [bool _direct = true]) async {
    indexTap = show;
    direct = _direct;
    final state = BlocProvider.of<MarkerInfoBloc>(context).state;
    if (markerSelected != null && state is MarkerInfoSuccess) {
      // markerSelected = await _addAndCatchMarker(
      //     'markerSelected',
      //     state.listMarkerInfo[index].center);
      LatLng positionCurrent = LatLng(state.listMarkerInfo[show].center[1],
          state.listMarkerInfo[show].center[0]);

      _updatePositionMarker(markerSelected, positionCurrent);
    }
    await pressMarkerCarouselController.animateToPage(show);
  }

  //!INIT MAP
  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);
    _pushPage();
  }

  //Handle Tap on Marker
  void _onSymbolTapped(Symbol symbol) async {
    int page = int.parse(symbol.options.iconImage);
    _gotoMarkerCamera(page, false);
  }

  void _pushPage() async {
    final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions != PermissionStatus.GRANTED) {
      await location.requestPermission();
    }
    _currentLocation = await location.getLocation();
    print(_currentLocation);
  }

  void _onCameraIdle() async {
    _latitude = controller.cameraPosition.target.latitude;
    _longitude = controller.cameraPosition.target.longitude;
    // print(_longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<MarkerInfoBloc, MarkerInfoState>(
          builder: (BuildContext context, MarkerInfoState state) {
        return Stack(
          children: [
            VTMap(
              accessToken: ACCESS_TOKEN_VTMAPS,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: _currentLocation == null
                      ? LatLng(16.05963693382427, 108.21664467782574)
                      : LatLng(_currentLocation.latitude,
                          _currentLocation.longitude),
                  zoom: 14),
              onCameraIdle: _onCameraIdle,
              gpsControlEnable: false,
              compassEnabled: false,
            ),
            Positioned(
              top: 6,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: MediaQuery.of(context).size.width - 32,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(48),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 6), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      filterBoxEmpty
                          ? Image.asset(
                              ICONS_ASSETS + 'icon_filter_bds.png',
                              height: 20,
                              fit: BoxFit.fill,
                            )
                          : InkWell(
                              onTap: () async {
                                _markerInfoBloc.add(ListMarkerInfoClear());
                                if (!loadingPosition) {
                                  // if (_selectedLine != null) {
                                  //   // controller.removeLine(_selectedLine);
                                  // }

                                  _clearLine();
                                  await _clearMarkers();
                                  _controllerText.clear();
                                  setState(() {
                                    filterBoxEmpty = true;
                                  });
                                  indexTap = -1;
                                }
                              },
                              child: Icon(Icons.clear, size: 20)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        child: TextField(
                          enabled: !loadingPosition,
                          controller: _controllerText,
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: trans(ENTER_KEY_WORD_TO_SEARCH),
                          ),
                          onChanged: (String value) {
                            if (value != '') {
                              // if (_selectedLine != null) {
                              //   // controller.removeLine(_selectedLine);
                              //   _selectedLine = null;
                              // }
                              setState(() {
                                filterBoxEmpty = false;
                              });
                            } else
                              setState(() {
                                filterBoxEmpty = true;
                              });
                          },
                          onSubmitted: (String value) {
                            if (value != '') {
                              _handleSubmitText(value);
                            }
                          },
                        ),
                      ),
                      loadingPosition
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      PRIMARY_COLOR),
                                  strokeWidth: 2.0),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              child: BlocBuilder<FilterCategoryBloc, FilterCategoryState>(
                  builder: (BuildContext context, FilterCategoryState state) {
                return (state is FilterCategoryFailure)
                    ? SizedBox()
                    : (state is FilterCategorySuccess &&
                            loadingPosition == false)
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.only(top: 10, left: 16),
                              scrollDirection: Axis.horizontal,
                              child: Row(children: [
                                for (FilterCategoryModel category
                                    in state.listFilterCategory)
                                  SizedBox(
                                    child: InkWell(
                                      onTap: () {
                                        // if (_selectedLine != null) {
                                        //   // controller.removeLine(_selectedLine);
                                        //   _selectedLine = null;
                                        // }
                                        _handleSubmitButton(category.name);
                                      },
                                      child: FilterCardWidget(
                                          icon: category.iconName,
                                          text: category.name),
                                    ),
                                  ),
                                SizedBox(
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteTransition(
                                            animationType:
                                                AnimationType.slide_up,
                                            builder: (context) =>
                                                DigitalMapCategoriesMenu(
                                                    handleSubmitButton:
                                                        _handleSubmitButton),
                                          ),
                                        );
                                      },
                                      child: FilterCardWidget(
                                          icon: 'icon_filter_moreFilter.png',
                                          text: trans(LABEL_OTHER))),
                                ),
                              ]),
                            ),
                          )
                        : SizedBox();
              }),
            ),
            isDirecting
                ? Positioned(
                    top: 110,
                    right: 16,
                    child: InkWell(
                      onTap: () {
                        _showDirectDetail();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(44),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset:
                                    Offset(0, 6), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.near_me,
                                  color: PRIMARY_COLOR, size: 20),
                              Text(trans(TITLE_STEPS),
                                  style: TextStyle(color: PRIMARY_COLOR))
                            ],
                          )),
                    ),
                  )
                : SizedBox(),
            (state is MarkerInfoSuccess &&
                    !loadingPosition &&
                    state.listMarkerInfo.length > 0)
                ? Positioned(
                    bottom: 165,
                    left: 16,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteTransition(
                            animationType: AnimationType.slide_up,
                            builder: (context) => DigitalMapListFilter(
                                listMarker: state.listMarkerInfo,
                                valueSearchBox: valueSearchBox,
                                gotoMarkerCamera: _gotoMarkerCamera,
                                addLine: _addLine),
                          ),
                        );
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36),
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
                          child: Icon(Icons.list,
                              size: 30, color: SECONDARY_TEXT_COLOR)),
                    ),
                  )
                : SizedBox(),
            (state is MarkerInfoSuccess &&
                    !loadingPosition &&
                    state.listMarkerInfo.length > 0)
                ? Positioned(
                    bottom: 25,
                    child: Container(
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
                            onPageChanged: (index, _) async {
                              print('indexCurrent: $indexTap');
                              if (index == indexTap || indexTap < 0) {
                                LatLng positionCurrent = LatLng(
                                    state.listMarkerInfo[index].center[1],
                                    state.listMarkerInfo[index].center[0]);

                                if (markerSelected != null && indexTap == -1) {
                                  // markerSelected = await _addAndCatchMarker(
                                  //     'markerSelected',
                                  //     state.listMarkerInfo[index].center);
                                  LatLng positionCurrent = LatLng(
                                      state.listMarkerInfo[index].center[1],
                                      state.listMarkerInfo[index].center[0]);

                                  _updatePositionMarker(
                                      markerSelected, positionCurrent);
                                }

                                if (direct == false) {
                                  CameraUpdate cameraUpdate =
                                      CameraUpdate.newLatLngZoom(
                                          positionCurrent, 16);
                                  controller.animateCamera(cameraUpdate);
                                }

                                direct = false;
                                indexTap = -1;
                              }
                            }),
                        carouselController: pressMarkerCarouselController,
                        items: state.listMarkerInfo.toList().map((marker) {
                          return MarkerCard(
                              marker: marker,
                              listMarker: state.listMarkerInfo,
                              addLine: _addLine,
                              gotoMarkerCamera: _gotoMarkerCamera,
                              pressMarkerCarouselController:
                                  pressMarkerCarouselController);
                        }).toList(),
                      ),
                    ),
                  )
                : SizedBox(),
            Positioned(
                right: 16,
                bottom: (state is MarkerInfoSuccess &&
                        !loadingPosition &&
                        state.listMarkerInfo.length > 0)
                    ? 153
                    : 30,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(72),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ]),
                  child: FlatButton(
                    onPressed: () {
                      _pushPage();
                      controller.animateCamera(CameraUpdate.newLatLngZoom(
                        LatLng(_currentLocation.latitude,
                            _currentLocation.longitude),
                        15.0,
                      ));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(72.0),
                    ),
                    child: Center(
                      child: Image.asset(
                          ICONS_ASSETS +
                              (_currentLocation != null
                                  ? 'icon_gps_button_active.png'
                                  : 'icon_gps_button.png'),
                          height: 32,
                          width: 32),
                    ),
                  ),
                ))
          ],
        );
      }),
    );
  }
}
