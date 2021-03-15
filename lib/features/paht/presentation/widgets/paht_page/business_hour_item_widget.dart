import 'dart:ui';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_app/core/resources/values.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';

const SIZE_ICON = 24.0;

class BusinessHourItemWidget extends StatelessWidget {
  final BusinessHourEntity entity;
  final int index;
  final Function onEdit;

  BusinessHourItemWidget({this.entity, this.index, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 0, bottom: 10, right: 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_time.svg',
              width: SIZE_ICON,
              height: SIZE_ICON,
            ),
            SizedBox(width: 20),
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Text(
                    getDayName(index),
                    style: GoogleFonts.inter(
                      fontSize: FONT_SMALL,
                      color: PRIMARY_TEXT_COLOR,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                  ),
                  Text(
                    getOperationTime(),
                    style: GoogleFonts.inter(
                      fontSize: FONT_SMALL,
                      color: PRIMARY_TEXT_COLOR,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                  ),
                ])),
            SizedBox(width: 20),
            InkWell(
              onTap: onEdit,
              child: SvgPicture.asset(
                SVG_ASSETS_PATH + 'icon_hour_edit.svg',
                width: SIZE_ICON,
                height: SIZE_ICON,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Divider(color: Color(0xffB9B9B9))
      ]),
    );
  }

  String getOperationTime() {
    if (entity != null) {
      String result;
      switch (entity.status) {
        case CLOSE_STATUS:
          return trans(LABEL_CLOSED);
        case OPEN_ALL_DAY_STATUS:
          return trans(LABEL_OPEN_24H);
        case OPEN_TIME_STATUS:
          return entity.openTime != null && entity.closeTime != null
              ? entity.openTime + ' - ' + entity.closeTime
              : '';
      }
    }
    return '';
  }

  String getDayName(int index) {
    switch (index) {
      case 0:
        return trans(LABEL_MONDAY);
      case 1:
        return trans(LABEL_TUEDAY);
      case 2:
        return trans(LABEL_WEDDAY);
      case 3:
        return trans(LABEL_THURDAY);
      case 4:
        return trans(LABEL_FRIDAY);
      case 5:
        return trans(LABEL_SATDAY);
      case 6:
        return trans(LABEL_SUNDAY);
      default:
        return "";
    }
  }
}
