import 'package:citizen_app/features/authentication/signin/presentation/dialogs/otp_dialog_widget.dart';
import 'package:flutter/material.dart';

Future<void> showOtpDialog(BuildContext context, String phone,
    [String password, bool isViettelSignIn = true]) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: false,
    useSafeArea: true,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 18),
        contentPadding:
            EdgeInsets.only(left: 18, right: 18, top: 35, bottom: 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: SingleChildScrollView(
          child: OTPDialogWidget(
            phone: phone,
            isViettelSignIn: isViettelSignIn,
            password: password,
          ),
        ),
      );
    },
  );
  // return AwesomeDialog(
  //   context: context,
  //   padding: EdgeInsets.all(18),
  //   buttonsBorderRadius: BorderRadius.all(Radius.circular(16)),
  //   headerAnimationLoop: false,
  //   dialogType: DialogType.NO_HEADER,
  //   animType: AnimType.SCALE,
  //   body: SingleChildScrollView(
  //     child: OTPDialogWidget(phone: phone, isViettelSignIn: isViettelSignIn),
  //   ),
  // )..show();
}
