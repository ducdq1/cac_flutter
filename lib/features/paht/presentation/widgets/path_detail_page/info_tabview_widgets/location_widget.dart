import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/paht/presentation/pages/location_issue_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';

class LocationWidget extends StatefulWidget {
  final String address;
  final String lattitude;
  final String longitude;
  final String name;

  LocationWidget({this.address, this.longitude, this.lattitude, this.name});

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget>
    implements OnButtonClickListener {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, top: 26, right: 24, bottom: 21),
      decoration: BoxDecoration(
          color: Color.fromARGB(153, 250, 245, 232),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    ICONS_ASSETS + 'icon_gps_2x.png',
                    width: 30,
                    height: 40,
                  ),
                  SizedBox(width: 00),
                  Text(
                    trans(LOCATION),
                    style: GoogleFonts.inter(
                      color: PRIMARY_TEXT_COLOR,
                      fontSize: FONT_MIDDLE,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Center(
              child: Text(
                widget.address ?? '',
                style: GoogleFonts.inter(
                  color: PRIMARY_TEXT_COLOR,
                  fontSize: FONT_MIDDLE,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 142,
              child: PrimaryButton(
                label: trans(VIEW_MAP),
                ctx: this,
                id: 'location_btn',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  onClick(String id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationIssuePage(
          lattitude: double.tryParse(widget.lattitude),
          longitude: double.tryParse(widget.longitude),
          address: widget.name,
        ),
      ),
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: PRIMARY_COLOR,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
}
