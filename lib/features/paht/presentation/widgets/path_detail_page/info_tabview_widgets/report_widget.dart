import 'package:citizen_app/app_localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportWidget extends StatelessWidget {
  final String name;
  final String createdTime;
  final String category;
  final String description;
  final PahtModel poiDetail;

  ReportWidget(
      {this.name,
      this.createdTime,
      this.category,
      this.description,
      this.poiDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            SizedBox(width: 24),
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: FONT_EX_LARGE,
                  color: PRIMARY_TEXT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ]),
          SizedBox(height: 14),
          Row(
            children: [
              SvgPicture.asset(
                SVG_ASSETS_PATH + 'icon_poi_name.svg',
              ),
              SizedBox(width: 7),
              Text(
                category ?? trans(LABEL_URBAN_ENVIROMENT),
                style: GoogleFonts.inter(
                  color: PRIMARY_TEXT_COLOR,
                  fontSize: FONT_MIDDLE,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          SizedBox(height: 14),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  SVG_ASSETS_PATH + 'icon_pin.svg',
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    description,
                    style: GoogleFonts.inter(
                      color: PRIMARY_TEXT_COLOR,
                      fontSize: FONT_MIDDLE,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              ]),
          poiDetail.businessHour != null && poiDetail.businessHour.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          SVG_ASSETS_PATH + 'icon_time.svg',
                        ),
                        SizedBox(width: 10),
                        Text(
                          getBusinessHour(poiDetail.businessHour),
                          style: GoogleFonts.inter(
                            color: PRIMARY_TEXT_COLOR,
                            fontSize: FONT_MIDDLE,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ]))
              : SizedBox(),
          poiDetail.phone != null && poiDetail.phone.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          SVG_ASSETS_PATH + 'icon_phone_number.svg',
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            poiDetail.phone,
                            style: GoogleFonts.inter(
                              color: PRIMARY_TEXT_COLOR,
                              fontSize: FONT_MIDDLE,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ]),
                )
              : SizedBox(),
          poiDetail.hyperlink != null && poiDetail.hyperlink.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          SVG_ASSETS_PATH + 'icon_web.svg',
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Linkify(
                            onOpen: (link) async {
                              await launch(link.url);
                            },
                            text: poiDetail.hyperlink.startsWith('http') ? poiDetail.hyperlink :  'http://' + poiDetail.hyperlink,
                           // style: TextStyle(color: Colors.yellow),
                          linkStyle: TextStyle( fontSize: FONT_MIDDLE,
                            fontWeight: FontWeight.normal,),
                          ),
                          ),
                      ]),
                )
              : SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 3),
                  SvgPicture.asset(getIcon(poiDetail.approveStatus)),
                  SizedBox(width: 13),
                  Expanded(
                    child: Text(
                      getStatus(poiDetail.approveStatus),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: FONT_MIDDLE,
                          fontWeight: FontWeight.normal,
                          color: getColor(poiDetail.approveStatus)),
                    ),
                  )
                ]),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  String getBusinessHour(List<BusinessHourEntity> BUSINESS_HOUR) {
    if (BUSINESS_HOUR == null || BUSINESS_HOUR.isEmpty) {
      return '';
    }

    String results = '';
    List<int> listDay = [];
    int openAllDayCount = 0;
    int closedCount = 0;

    for (int i = 0; i < BUSINESS_HOUR.length; i++) {
      if (BUSINESS_HOUR[i].status == CLOSE_STATUS) {
        closedCount += 1;
      }
      if (BUSINESS_HOUR[i].status == OPEN_ALL_DAY_STATUS) {
        openAllDayCount += 1;
      }

      if (listDay.contains(i)) {
        continue;
      }

      BusinessHourEntity businessHourEntity = BUSINESS_HOUR[i];
      listDay.add(i);
      results += getDayShortName(i);
      for (int j = i + 1; j < BUSINESS_HOUR.length; j++) {
        BusinessHourEntity secondEntity = BUSINESS_HOUR[j];
        if (businessHourEntity.status == CLOSE_STATUS ||
            businessHourEntity.status == OPEN_ALL_DAY_STATUS) {
          if ((!listDay.contains(j) &&
              secondEntity.status == businessHourEntity.status)) {
            listDay.add(j);
            results += ', ' + getDayShortName(j);
          }
        } else {
          if (!listDay.contains(j) &&
              secondEntity.status == businessHourEntity.status &&
              businessHourEntity.openTime != null &&
              businessHourEntity.closeTime != null &&
              secondEntity.openTime != null &&
              secondEntity.closeTime != null &&
              businessHourEntity.openTime == secondEntity.openTime &&
              businessHourEntity.closeTime == secondEntity.closeTime) {
            listDay.add(j);
            results += ', ' + getDayShortName(j);
          }
        }
      }

      if (businessHourEntity.status == CLOSE_STATUS) {
        results += ": " + trans(LABEL_CLOSED) + '\n';
      } else if (businessHourEntity.status == OPEN_ALL_DAY_STATUS) {
        results += ": " + trans(LABEL_OPEN_24H) + '\n';
      } else if (businessHourEntity.openTime != null &&
          businessHourEntity.closeTime != null) {
        results += ": " +
            businessHourEntity.openTime +
            ' - ' +
            businessHourEntity.closeTime +
            "\n";
      }
    }

    if (closedCount == BUSINESS_HOUR.length) {
      results = trans(LABEL_CLOSED);
    } else if (openAllDayCount == BUSINESS_HOUR.length) {
      results = trans(LABEL_OPEN_24H) + " 24/7";
    }

    return results.trim();
  }
}
