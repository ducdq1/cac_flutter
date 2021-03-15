import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class OTPGroupButtonWidget extends StatefulWidget {
  @override
  _OTPGroupButtonWidgetState createState() => _OTPGroupButtonWidgetState();
}

class _OTPGroupButtonWidgetState extends State<OTPGroupButtonWidget>
    implements OnButtonClickListener {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
                label: trans(TITLE_LOGIN_SCREEN),
                ctx: this,
                id: 'signin-otp-id'),
            SizedBox(height: 18),
            OutlineCustomButton(label: 'Đóng', ctx: this, id: 'cancel-btn-id'),
          ],
        ),
      ),
    );
  }

  @override
  onClick(String id) {
    if (id == 'cancel-btn-id') {
      Navigator.pop(context);
    }
  }
}
