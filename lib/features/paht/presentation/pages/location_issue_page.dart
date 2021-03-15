import 'dart:ffi';
import 'dart:typed_data';

import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:vtmap_gl/vtmap_gl.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class LocationIssuePage extends StatefulWidget {
  final double lattitude;
  final double longitude;
  final String address;
  LocationIssuePage({this.lattitude, this.longitude,this.address});

  @override
  _LocationIssuePageState createState() => _LocationIssuePageState();
}

class _LocationIssuePageState extends State<LocationIssuePage> implements OnButtonClickListener {
  MapboxMapController controller;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    _pushPage();
  }

  void _onStyleLoadedCallback() {
    addImageFromAsset("assetImage",Platform.isIOS ? "assets/icons/icon_gps_2x.png" :  "assets/icons/icon_gps_3x.png");
    _addMarker("assetImage");
  }

  void _pushPage() async {
    final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions != PermissionStatus.GRANTED) {
      await location.requestPermission();
    }
  }

  void _addMarker(String iconImage) {
    List<int> availableNumbers = Iterable<int>.generate(12).toList();
    controller.symbols.forEach(
            (s) => availableNumbers.removeWhere((i) => i == s.data['count'])
    );

    if (availableNumbers.isNotEmpty) {
      controller.addSymbol(
          _getSymbolOptions(iconImage, availableNumbers.first),
          {'count': availableNumbers.first}
      );

    }
  }

  SymbolOptions _getSymbolOptions(String iconImage, int symbolCount){
    LatLng center =  LatLng(widget.lattitude, widget.longitude);
    LatLng geometry = LatLng(
        center.latitude,
        center.longitude
    );
    return SymbolOptions(
      geometry: geometry,
      iconImage: iconImage,
      fontNames: ["Open Sans Bold", "Arial Unicode MS Bold"],
      textField: widget.address ?? "",
      textSize: 12.5,
      textOffset: Offset(0, 0),
      textAnchor: 'top',
      textColor: '#0000BB',
    );
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          VTMap(
            accessToken: '62cd4c9e0f2a0c2a31e9cdc7485b33a5',
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lattitude, widget.longitude),
              zoom: 15,
            ),
          ),
          Positioned(
            bottom: 50,
            child: Container(
              width: 142,
              child: PrimaryButton(label: 'Đóng', ctx: this, id: ''),
            ),
          )
        ],
      ),
    );
  }

  @override
  onClick(String id) {
    Navigator.pop(context);
  }
}
