import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/phone_validate.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_bloc.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_event.dart';
import 'package:citizen_app/features/authentication/signin/presentation/dialogs/otp_dialog.dart';
import 'package:citizen_app/features/authentication/signin/presentation/widgets/note_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'group_button_widget.dart';

class FormSignInViettelWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  FormSignInViettelWidget({this.formKey});
  @override
  _FormSignInViettelWidgetState createState() =>
      _FormSignInViettelWidgetState();
}

class _FormSignInViettelWidgetState extends State<FormSignInViettelWidget> {
  FocusNode _phoneFocusNode;
  TextEditingController _phoneController;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    _phoneController = TextEditingController();
    _phoneFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputValidateWidget(
              label: trans(LABEL_LOGIN_PHONE),
              limitLength: 10,
              focusNode: _phoneFocusNode,
              textInputType: TextInputType.number,
              scrollPadding: 250,
              controller: _phoneController,
              validates: [
                EmptyValidate(),
                PhoneValidate(),
              ],
            ),
            SizedBox(height: 10),
            NoteWidget(),
            SizedBox(height: 40),
            GroupButtonWidget(
              primaryLabel: trans(TITLE_LOGIN_SCREEN),
              secondaryLabel: trans(LOGIN_WITH_ACCOUNT),
              isViettelSignin: true,
              primaryBtnId: 'signin_viettel_btn',
              secondBtnId: 'signin_account_navigate_btn',
              formKey: widget.formKey,
              onSubmit: () async {
                if (_isButtonDisabled == false) {
                  _isButtonDisabled = true;
                  FocusScope.of(context).unfocus();
                  await Future.delayed(Duration(milliseconds: 100));
                  BlocProvider.of<SignInBloc>(context)
                      .add(SignInOtpEvent(phone: _phoneController.text.trim()));
                  await showOtpDialog(
                    context,
                    _phoneController.text.trim(),
                  );
                  _isButtonDisabled = false;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
