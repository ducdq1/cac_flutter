import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/phone_validate.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/bloc/forgot_password_event.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_address_page/captcha_widget.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_address_page/form_address_widget.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormSecretCodeWidget extends StatefulWidget {
  @override
  _FormSecretCodeWidgetState createState() => _FormSecretCodeWidgetState();
}

class _FormSecretCodeWidgetState extends State<FormSecretCodeWidget>
    implements OnButtonClickListener {
  FocusNode _phoneFocusNode;
  FocusNode _captchFocusNode;
  TextEditingController _phoneController;
  TextEditingController _captchaController;
  CaptchaIdObserve _captchaIdObserve;
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _phoneFocusNode = FocusNode();
    _captchFocusNode = FocusNode();
    _phoneController = TextEditingController();
    _captchaController = TextEditingController();
    _captchaIdObserve = CaptchaIdObserve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 38),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            InputValidateCustomWidget(
              limitLength: 10,
              focusNode: _phoneFocusNode,
              controller: _phoneController,
              label: trans(LABEL_LOGIN_PHONE),
              textInputType: TextInputType.number,
              isRequired: true,
              validates: [
                EmptyValidate(),
                PhoneValidate(),
              ],
              focusAction: () => FormTools.requestFocus(
                currentFocusNode: _phoneFocusNode,
                context: context,
                nextFocusNode: _captchFocusNode,
              ),
              focusError: (FocusNode focusNode) {},
            ),
            CaptchaWidget(
              captchaController: _captchaController,
              captchaIdObserve: _captchaIdObserve,
              captchaFocusNode: _captchFocusNode,
            ),
            SizedBox(height: 40),
            PrimaryButton(
              label: trans(GET_SECRET_CODE),
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
    if (_formKey.currentState.validate()) {
      BlocProvider.of<ForgotPasswordBloc>(context).add(FetchSecretCodeEvent(
        captchaId: _captchaIdObserve.id.trim(),
        captcha: _captchaController.text.trim(),
        phone: _phoneController.text.trim(),
      ));
    }
  }
}
