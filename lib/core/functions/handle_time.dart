import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:intl/intl.dart';

String handleTime(String time) {

  String result = '';
  try {
    if (time == null || time == '') return '9999-99-99 99:99:99';
    if (DateTime
        .now()
        .difference(DateTime.parse(time))
        .inSeconds < 60) {
      result =
          DateTime
              .now()
              .difference(DateTime.parse(time))
              .inSeconds
              .toString() +
              ' ' +
              trans(LABEL_SECONDS_AGO);
    } else if (DateTime
        .now()
        .difference(DateTime.parse(time))
        .inMinutes < 60) {
      result =
          DateTime
              .now()
              .difference(DateTime.parse(time))
              .inMinutes
              .toString() +
              ' ' +
              trans(LABEL_MINUTES_AGO);
    } else if (DateTime
        .now()
        .difference(DateTime.parse(time))
        .inHours < 24) {
      result =
          DateTime
              .now()
              .difference(DateTime.parse(time))
              .inHours
              .toString() +
              ' ' +
              trans(LABEL_HOURS_AGO);
    } else {
      result = DateFormat("dd-MM-yyyy").format(DateTime.parse(time));
    }
  }catch(error){

  }
  return result;
}

String formatTime(String time) {
  String result = '';
  try {
    if (time == null || time == '') return '';
      result = DateFormat("dd-MM-yyyy").format(DateTime.parse(time));
  }catch(error){
  }
  return result;
}




