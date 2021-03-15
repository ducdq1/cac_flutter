import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/password_validate.dart';
import 'package:citizen_app/core/utils/validate/phone_validate.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/bloc/forgot_password_event.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/bloc/forgot_password_state.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormResetPasswordWidget extends StatefulWidget {
  @override
  _FormResetPasswordWidgetState createState() =>
      _FormResetPasswordWidgetState();
}

class _FormResetPasswordWidgetState extends State<FormResetPasswordWidget>
    implements OnButtonClickListener {
  FocusNode _phoneFocusNode;
  FocusNode _secretCodeFocusNode;
  FocusNode _newPasswordFocusNode;
  TextEditingController _phoneController;
  TextEditingController _secretCodeController;
  TextEditingController _newPasswordController;
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _phoneFocusNode = FocusNode();
    _secretCodeFocusNode = FocusNode();
    _newPasswordFocusNode = FocusNode();
    _phoneController = TextEditingController();
    _secretCodeController = TextEditingController();
    _newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 38),
        child: Column(
          children: [
            InputValidateCustomWidget(
              focusNode: _phoneFocusNode,
              controller: _phoneController,
              label: trans(LABEL_LOGIN_PHONE),
              focusAction: () => FormTools.requestFocus(
                currentFocusNode: _phoneFocusNode,
                context: context,
                nextFocusNode: _secretCodeFocusNode,
              ),
              validates: [
                EmptyValidate(),
                PhoneValidate(),
              ],
              focusError: (FocusNode focusNode) {},
            ),
            InputValidateCustomWidget(
              focusNode: _secretCodeFocusNode,
              controller: _secretCodeController,
              label: trans(LABEL_SECRET_CODE),
              focusAction: () => FormTools.requestFocus(
                currentFocusNode: _phoneFocusNode,
                context: context,
                nextFocusNode: _newPasswordFocusNode,
              ),
              validates: [
                EmptyValidate(),
              ],
              focusError: (FocusNode focusNode) {},
            ),
            InputValidateCustomWidget(
              focusNode: _newPasswordFocusNode,
              controller: _newPasswordController,
              label: trans(LABEL_NEW_PASSWORD),
              validates: [
                EmptyValidate(),
                PasswordValidate(),
              ],
              focusError: (FocusNode focusNode) {},
            ),
            SizedBox(height: 40),
            PrimaryButton(
              label: trans(LABEL_RESET_PASSWORD),
              ctx: this,
              id: 'reset_password_btn',
            ),
          ],
        ),
      ),
    );
  }

  @override
  onClick(String id) {
    final state = BlocProvider.of<ForgotPasswordBloc>(context).state;
    if (_formKey.currentState.validate() &&
        state is FetchSecretCodeSucceedState) {
      BlocProvider.of<ForgotPasswordBloc>(context).add(ResetPasswordEvent(
        newPassword: _newPasswordController.text.trim(),
        phone: _phoneController.text.trim(),
        secretCode: _secretCodeController.text.trim(),
      ));
    }
  }
}
