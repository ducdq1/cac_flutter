import 'dart:async';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';

class Validators {
  // final validateUsername = StreamTransformer<String, String>.fromHandlers(
  //     handleData: (username, sink) {
  //   Pattern pattern = r'^0+[0-9]{7,10}$';
  //   RegExp regex = new RegExp(pattern);
  //   if (username.trim().isEmpty) {
  //     sink.addError(trans(ERROR_VALIDATE_EMPTY_PHONE_LOGIN)));
  //   } else if (!regex.hasMatch(username)) {
  //     sink.addError(trans(ERROR_INVALID_PHONE_LOGIN)));
  //   } else {
  //     sink.add(username);
  //   }
  // });

  // final validatePassword = StreamTransformer<String, String>.fromHandlers(
  //     handleData: (password, sink) {
  //   if (password.trim().isEmpty) {
  //     sink.addError(trans(ERROR_VALIDATE_EMPTY_PASSWORD_LOGIN));
  //   } else {
  //     sink.add(password);
  //   }
  // });
  // final validateCurrentPassword =
  //     StreamTransformer<String, String>.fromHandlers(
  //         handleData: (password, sink) {
  //   if (password.trim().isEmpty) {
  //     sink.addError(ERROR_VALIDATE_EMPTY_CURRENT_PASSWORD_LOGIN);
  //   } else {
  //     sink.add(password);
  //   }
  // });
  // final validateNewPassword = StreamTransformer<String, String>.fromHandlers(
  //     handleData: (password, sink) {
  //   if (password.trim().isEmpty) {
  //     sink.addError(ERROR_VALIDATE_EMPTY_NEW_PASSWORD_LOGIN);
  //   } else {
  //     sink.add(password);
  //   }
  // });
  final validateNewsVerificationContent =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (feedback, sink) {
    if (feedback.trim().isEmpty) {
      sink.addError(trans(ERROR_VALIDATE_EMPTY_NEWS_VERIFICATION_CONTENT));
    } else {
      sink.add(feedback);
    }
  });
  final validateNewsVerificationLink =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (feedback, sink) {
    if (feedback.trim().isEmpty) {
      sink.addError(trans(ERROR_VALIDATE_EMPTY_NEWS_VERIFICATION_LINK));
    } else {
      sink.add(feedback);
    }
  });
  final validatePAHTContent = StreamTransformer<String, String>.fromHandlers(
      handleData: (feedback, sink) {
    if (feedback.trim().isEmpty) {
      sink.addError(trans(ERROR_VALIDATE_EMPTY_PAHT_CONTENT));
    } else {
      sink.add(feedback);
    }
  });
  final validatePAHTAddress = StreamTransformer<String, String>.fromHandlers(
      handleData: (feedback, sink) {
    if (feedback.trim().isEmpty) {
      sink.addError(trans(ERROR_VALIDATE_EMPTY_PAHT_ADDRESS));
    } else {
      sink.add(feedback);
    }
  });
  final validatePAHTMedia = StreamTransformer<String, String>.fromHandlers(
      handleData: (feedback, sink) {
    if (feedback.trim().isEmpty) {
      sink.addError(trans(ERROR_VALIDATE_EMPTY_PAHT_MEDIA));
    } else {
      sink.add(feedback);
    }
  });
}
