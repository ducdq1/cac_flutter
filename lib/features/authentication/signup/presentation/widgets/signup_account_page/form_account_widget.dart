import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/password_validate.dart';
import 'package:citizen_app/core/utils/validate/phone_validate.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';

class FormAccountWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passController;
  final Function focusNodeError;
  final Function onNext;
  FormAccountWidget(
      {this.formKey,
      this.passController,
      this.phoneController,
      this.focusNodeError,
      this.onNext});
  @override
  _FormAccountWidgetState createState() => _FormAccountWidgetState();
}

class _FormAccountWidgetState extends State<FormAccountWidget> {
  FocusNode _phoneFocusNode;
  FocusNode _passFocusNode;

  @override
  void initState() {
    _phoneFocusNode = FocusNode();
    _passFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 38),
        child: Column(
          children: [
            Text(
              trans(ENTER_ACCOUNT_INFORMATION),
              style: GoogleFonts.inter(
                fontSize: FONT_EX_LARGE,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: PRIMARY_TEXT_COLOR,
              ),
            ),
            SizedBox(height: 30),
            InputValidateCustomWidget(
              limitLength: 11,
              focusNode: _phoneFocusNode,
              controller: widget.phoneController,
              label: trans(LABEL_LOGIN_PHONE),
              focusAction: () {
                FormTools.requestFocus(
                  currentFocusNode: _phoneFocusNode,
                  nextFocusNode: _passFocusNode,
                  context: context,
                );
              },
              textInputType: TextInputType.number,
              validates: [
                EmptyValidate(),
                PhoneValidate(),
              ],
              focusError: (FocusNode focusNode) {
                widget.focusNodeError(focusNode);
              },
            ),
            InputValidateCustomWidget(
              limitLength: 30,
              onEditingComplete: widget.onNext,
              focusNode: _passFocusNode,
              controller: widget.passController,
              label: trans(LABEL_LOGIN_PASSWORD),
              focusAction: () => FormTools.requestFocus(
                currentFocusNode: _passFocusNode,
                context: context,
              ),
              textInputType: TextInputType.text,
              focusError: (FocusNode focusNode) {
                widget.focusNodeError(focusNode);
              },
              obscureText: true,
              textInputAction: TextInputAction.done,
              // scrollPadding: MediaQuery.of(context).size.height / 2,
              validates: [
                PasswordValidate(),
              ],
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
