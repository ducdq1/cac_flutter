import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/signup/data/models/signup_model.dart';
import 'package:citizen_app/features/authentication/signup/presentation/signup_address_page.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/group_signup_button_widget.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_personal_page/form_personnal_info_widget.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/step_complete_widget.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/signup_bloc.dart';
import 'bloc/signup_event.dart';

class SignUpPersonalPage extends StatefulWidget {
  @override
  _SignUpPersonalPageState createState() => _SignUpPersonalPageState();
}

class _SignUpPersonalPageState extends State<SignUpPersonalPage> {
  static GlobalKey _formKey;
  TextEditingController _usernameController;
  TextEditingController _identityNoController;
  TextEditingController _emailController;
  TextEditingController _genderController;
  TextEditingController _dobController;
  FocusNode _focusNodeError;

  void _focusError(FocusNode focusNode) {
    if (_focusNodeError == null) _focusNodeError = focusNode;
  }

  @override
  void initState() {
    if (_formKey == null) {
      _formKey = GlobalKey<FormState>();
    }

    _usernameController = TextEditingController();
    _identityNoController = TextEditingController();
    _emailController = TextEditingController();
    _genderController = TextEditingController();
    _dobController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
      title: trans(TITLE_SIGNUP_ACCOUNT),
      centerTitle: true,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            StepCompleteWidget(total: 3, completeIndex: 0),
            SizedBox(height: 35),
            Text(
              trans(ENTER_ACCOUNT_INFORMATION),
              style: GoogleFonts.inter(
                fontSize: FONT_EX_LARGE,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: PRIMARY_TEXT_COLOR,
              ),
            ),
            Form(
              key: _formKey,
              child: FormPersonalInfoWidget(
                dobController: _dobController,
                usernameController: _usernameController,
                emailController: _emailController,
                genderController: _genderController,
                identityNoController: _identityNoController,
                focusNodeError: _focusError,
              ),
            ),
            SizedBox(height: 40),
            GroupSignUpButtonWidget(
              formKey: _formKey,
              router: SignUpAddressPage(),
              onInValidate: () {},
              onValidate: () {
                final tmp = SignUpModel();
                tmp.email = _emailController.text.trim();
                tmp.dob = _dobController.text.trim();
                tmp.name = _usernameController.text.trim();
                tmp.gender = int.tryParse(_genderController.text.trim());
                tmp.identityNo = _identityNoController.text.trim();
                BlocProvider.of<SignUpBloc>(context)
                    .add(SignUpUpdateFieldsEvent(entity: tmp));
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
