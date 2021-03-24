import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/painting.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/core/functions/trans.dart';

Color getColor(int statusId) {
  switch (statusId) {
    case 0:
      return WAITING_STATUS_COLOR;
      break;
    case 1:
      return VERIFIED_STATUS_COLOR;
      break;
    case 2:
      return DENIED_STATUS_COLOR;
      break;
    case 3:
      return PROCESSING_STATUS_COLOR;
      break;
    case 4:
      return PROCESSING_STATUS_COLOR;
      break;
    case 5:
      return PROCESSING_STATUS_COLOR;
      break;
    case 6:
      return RESOLVED_STATUS_COLOR;
      break;
    case 7:
      return DENIED_STATUS_COLOR;
      break;
    case 8:
      return CANCELED_STATUS_COLOR;
      break;

    default:
      return Color(0xff353739);
      break;
  }
}

String getIcon(int statusId) {
  if (statusId == 1) {
    return SVG_ASSETS_PATH + 'icon_resolved.svg';
  } else if ( statusId == 2) {
    return SVG_ASSETS_PATH + 'icon_denied.svg';
  }else{
    return SVG_ASSETS_PATH + 'icon_waiting.svg';
  }
}

String getStatus(int statusId) {
  if (statusId == 1) {
    return 'Đã báo giá';
  } else if ( statusId == 2) {
    return trans(STATUS_DENNY);
  }else{
    return 'Chưa báo giá';
  }
}

String getIconNewsVerificationFromStatusId(int statusId) {
  switch (statusId) {
    case 0:
      return SVG_ASSETS_PATH + 'icon_waiting_news.svg';
      break;

    case 1:
      return SVG_ASSETS_PATH + 'icon_received.svg';
      break;
    case 2:
      return SVG_ASSETS_PATH + 'icon_verified_news.svg';
      break;

    case 3:
      return SVG_ASSETS_PATH + 'icon_canceled.svg';
      break;

    default:
      return SVG_ASSETS_PATH + 'icon_processing.svg';
      break;
  }
}

Color getColorNewsVerificationFromStatusId(int statusId) {
  switch (statusId) {
    case 0:
      return WAITING_STATUS_COLOR;
      break;

    case 1:
      return RECEIVED_STATUS_COLOR;
      break;

    case 2:
      return VERIFIED_STATUS_COLOR;
      break;

    case 3:
      return CANCELED_STATUS_COLOR;
      break;

    default:
      return PROCESSING_STATUS_COLOR;
      break;
  }
}

String getDayShortName(int index) {
  switch (index) {
    case 0:
      return trans(LABEL_MONDAY_SHORT);
    case 1:
      return trans(LABEL_TUEDAY_SHORT);
    case 2:
      return trans(LABEL_WEDDAY_SHORT);
    case 3:
      return trans(LABEL_THURDAY_SHORT);
    case 4:
      return trans(LABEL_FRIDAY_SHORT);
    case 5:
      return trans(LABEL_SATDAY_SHORT);
    case 6:
      return trans(LABEL_SUNDAY_SHORT);
    default:
      return "";
  }
}


