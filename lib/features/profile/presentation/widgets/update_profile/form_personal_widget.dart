import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/email_validate.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/id_code_validate.dart';
import 'package:citizen_app/features/authentication/signup/data/enums.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_personal_page/group_radio_widget.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_personal_page/input_datetime_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:flutter/material.dart';

class FormPersonalWidget extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController identityNoController;
  final TextEditingController emailController;
  final TextEditingController genderController;
  final TextEditingController dobController;
  final TextEditingController phoneController;
  final Function focusNodeError;
  final double scrollPadding;

  FormPersonalWidget({
    this.scrollPadding = 200,
    this.dobController,
    this.emailController,
    this.genderController,
    this.identityNoController,
    this.usernameController,
    this.phoneController,
    this.focusNodeError,
  });
  @override
  _FormPersonalWidgetState createState() => _FormPersonalWidgetState();
}

class _FormPersonalWidgetState extends State<FormPersonalWidget> {
  FocusNode _usernameFocusNode;
  FocusNode _idNumberFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _phoneFocusNode;
  Gender _defaultGender;

  @override
  void initState() {
    _usernameFocusNode = FocusNode();
    _idNumberFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();

    /// Initial value gender radio
    if (widget.genderController.text.trim().isNotEmpty) {
      switch (int.parse(widget.genderController.text.trim())) {
        case 1:
          _defaultGender = Gender.male;
          break;
        case 2:
          _defaultGender = Gender.female;
          break;
        default:
          _defaultGender = Gender.unknown;
      }
    } else {
      widget.genderController.text = '1';
      _defaultGender = Gender.male;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 38),
      child: Column(
        children: [
          SizedBox(height: 30),
          InputValidateCustomWidget(
            scrollPaddingForTop: true,
            scrollPadding: widget.scrollPadding,
            focusNode: _usernameFocusNode,
            controller: widget.usernameController,
            label: trans(FULL_NAME),
            focusAction: () => FormTools.requestFocus(
              currentFocusNode: _usernameFocusNode,
              nextFocusNode: _idNumberFocusNode,
              context: context,
            ),
            validates: [
              EmptyValidate(),
            ],
            focusError: (FocusNode focusNode) {
              widget.focusNodeError(focusNode);
            },
          ),
          SizedBox(height: 5),
          InputDatetimeWidget(
            scrollPadding: widget.scrollPadding,
            hintText: trans(BIRTH_DAY),
            controller: widget.dobController,
            validates: [EmptyValidate()],
          ),
          SizedBox(height: 20),
          GroupRadioWidget<Gender>(
            label: trans(GENDER),
            radios: [
              RadioData<Gender>(label: trans(MALE), value: Gender.male),
              RadioData<Gender>(label: trans(FEMALE), value: Gender.female),
              RadioData<Gender>(
                label: trans(UNKNOWN),
                value: Gender.unknown,
              ),
            ],
            defaultValue: _defaultGender,
            onChoice: (Gender radio) {
              switch (radio) {
                case Gender.female:
                  widget.genderController.text = '2';
                  break;
                case Gender.male:
                  widget.genderController.text = '1';
                  break;
                default:
                  widget.genderController.text = '3';
              }
            },
          ),
          SizedBox(height: 30),
          InputValidateCustomWidget(
            scrollPaddingForTop: true,
            scrollPadding: widget.scrollPadding,
            focusNode: _idNumberFocusNode,
            controller: widget.identityNoController,
            label: trans(ID_NUMBER),
            textInputType: TextInputType.number,
            focusAction: () => FormTools.requestFocus(
                currentFocusNode: _idNumberFocusNode,
                nextFocusNode: _emailFocusNode,
                context: context),
            validates: [IDCodeValidate()],
            focusError: (FocusNode focusNode) {
              widget.focusNodeError(focusNode);
            },
          ),
          SizedBox(height: 5),
          InputValidateCustomWidget(
            scrollPaddingForTop: true,
            scrollPadding: widget.scrollPadding,
            focusNode: _phoneFocusNode,
            controller: widget.phoneController,
            label: trans(LABEL_LOGIN_PHONE),
            textInputType: TextInputType.number,
            focusAction: () => FormTools.requestFocus(
                currentFocusNode: _phoneFocusNode,
                nextFocusNode: _emailFocusNode,
                context: context),
            validates: [IDCodeValidate()],
            focusError: (FocusNode focusNode) {
              widget.focusNodeError(focusNode);
            },
          ),
          SizedBox(height: 5),
          InputValidateCustomWidget(
            scrollPaddingForTop: true,
            focusNode: _emailFocusNode,
            controller: widget.emailController,
            label: 'Email',
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validates: [
              EmailValidate(),
            ],
            focusError: (FocusNode focusNode) {
              widget.focusNodeError(focusNode);
            },
            scrollPadding: MediaQuery.of(context).size.height / 2,
          ),
        ],
      ),
    );
  }
}
