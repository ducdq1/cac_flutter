import 'dart:async';
import 'dart:convert';

import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:vtmap_gl/vtmap_gl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

const TEXT_ADDRESS_COLOR = Color(0xff02184A);

class LocationPickerVTMaps extends StatefulWidget {
  final Map<String, dynamic> chosenLocation;

  const LocationPickerVTMaps({Key key, this.chosenLocation}) : super(key: key);

  @override
  _LocationPickerVTMapsState createState() => _LocationPickerVTMapsState();
}

class _LocationPickerVTMapsState extends State<LocationPickerVTMaps>
    implements OnButtonClickListener {
  MapboxMapController controller;
  LocationData _currentLocation;
  String _address;
  double _latitude;
  double _longitude;
  final location = Location();
  Timer _debounce;
  bool isFirst = true;

  void _onMapCreated(MapboxMapController controller) {
    print('_onMapCreated...');
    this.controller = controller;
  }

  void _onStyleLoadedCallback() {
    print('_onStyleLoadedCallback...');
    _pushPage();
  }

  void _pushPage() async {
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    var _hasPermissions = await location.hasPermission();
    if (_hasPermissions != PermissionStatus.GRANTED) {
      _hasPermissions = await location.requestPermission();
      if (_hasPermissions != PermissionStatus.GRANTED) {
        return;
      }
    }

    var _location = await location.getLocation();
    setState(() {
      _currentLocation = _location;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _onCameraIdle() async {
    print('_onCameraIdle...');
    setState(() {
      _address = null;
    });
    if (isFirst) {
      isFirst = false;
      Future.delayed(Duration(milliseconds: 1000), () {
        getAddress();
      });
    } else {
      getAddress();
    }
  }

  void getAddress() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      print('get Adress...');
      getAddressFromLocation(
              lat: controller.cameraPosition.target.latitude,
              lng: controller.cameraPosition.target.longitude)
          .then((value) {
        setState(() {
          _address = value;
          _latitude = controller.cameraPosition.target.latitude;
          _longitude = controller.cameraPosition.target.longitude;
        });
      });
    });
  }

  Future<String> getAddressFromLocation({
    @required double lat,
    @required double lng,
  }) async {
    final response = await http.get(
        'https://api.viettelmaps.vn/gateway/searching/v1/search/location?pt=$lat,$lng&access_token=$ACCESS_TOKEN_VTMAPS');
    final data = jsonDecode(response.body);
    final locationFromVTMaps = LocationVTMaps.fromJson(data['data']);

    return locationFromVTMaps.address;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Stack(
      children: [
        VTMap(
            accessToken: ACCESS_TOKEN_VTMAPS,
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            initialCameraPosition: CameraPosition(
                target: widget.chosenLocation != null &&
                        widget.chosenLocation['latitude'] != null
                    ? LatLng(
                        double.parse(
                            widget.chosenLocation['latitude'].toString()),
                        double.parse(
                            widget.chosenLocation['longitude'].toString()))
                    : _currentLocation == null
                        ? LatLng(16.05963693382427, 108.21664467782574)
                        : LatLng(_currentLocation.latitude,
                            _currentLocation.longitude),
                zoom: 14),
            onCameraIdle: _onCameraIdle,
            onCameraTrackingChanged: (value) {}),
        _address == null
            ? Center(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Card(
                        child: Container(
                      //alignment: Alignment.center,
                      width: 240,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    PRIMARY_COLOR))),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          trans(LABEL_LOADING_DATA),
                          style: GoogleFonts.inter(
                              color: TEXT_ADDRESS_COLOR, fontSize: FONT_MIDDLE),
                        ),
                      ]),
                    ))),
              )
            : Center(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 130),
                    child: Card(
                        child: Container(
                      width: 240,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _address == '' ? trans(NO_DATA) : _address,
                        style: GoogleFonts.inter(
                            color: TEXT_ADDRESS_COLOR, fontSize: FONT_MIDDLE),
                      ),
                    ))),
              ),
        Center(
          child: SvgPicture.asset(
            SVG_ASSETS_PATH + 'icon_marker.svg',
            width: 35,
            height: 35,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 142,
                  child: OutlineCustomButton(
                    label: trans(TEXT_CANCEL_BUTTON),
                    ctx: this,
                    id: 'cancel_btn',
                  ),
                ),
                Container(
                  width: 142,
                  child: PrimaryButton(
                      label: trans(TEXT_CHOOSE_LOCATION_PICKER),
                      ctx: this,
                      id: 'primary_btn'),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: PRIMARY_COLOR,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    super.dispose();
  }

  @override
  onClick(String id) {
    Map<String, dynamic> _chosenLocation = {
      'address': _address,
      'latitude': _latitude,
      'longitude': _longitude
    };
    if (id == 'cancel_btn') {
      Navigator.pop(context, widget.chosenLocation);
    }
    if (id == 'primary_btn') {
      Navigator.pop(context, _chosenLocation);
    }
  }
}

class LocationVTMaps extends Equatable {
  final int id;
  final String name;
  final String address;
  final String districtName;

  LocationVTMaps({this.id, this.name, this.address, this.districtName});

  factory LocationVTMaps.fromJson(Map<String, dynamic> json) {
    return LocationVTMaps(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      districtName: json['districtName'],
    );
  }

  @override
  List<Object> get props => [id, name, address, districtName];
}
