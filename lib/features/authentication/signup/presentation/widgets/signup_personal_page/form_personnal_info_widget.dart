import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/email_validate.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/id_code_validate.dart';
import 'package:citizen_app/features/authentication/signup/data/enums.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_bloc.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_state.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'group_radio_widget.dart';
import 'input_datetime_widget.dart';

class FormPersonalInfoWidget extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController identityNoController;
  final TextEditingController emailController;
  final TextEditingController genderController;
  final TextEditingController dobController;
  final Function focusNodeError;
  final double scrollPadding;

  FormPersonalInfoWidget({
    this.scrollPadding = 200,
    this.dobController,
    this.emailController,
    this.genderController,
    this.identityNoController,
    this.usernameController,
    this.focusNodeError,
  });
  @override
  _FormPersonalInfoWidgetState createState() => _FormPersonalInfoWidgetState();
}

class _FormPersonalInfoWidgetState extends State<FormPersonalInfoWidget> {
  FocusNode _usernameFocusNode;
  FocusNode _idNumberFocusNode;
  FocusNode _emailFocusNode;

  @override
  void initState() {
    final state = BlocProvider.of<SignUpBloc>(context).state;
    if (state is SignUpUpdatedFieldsState) {
      widget.usernameController.text = state.entity.name ?? '';
      widget.identityNoController.text = state.entity.identityNo ?? '';
      widget.emailController.text = state.entity.email ?? '';
      widget.dobController.text = state.entity.dob ?? '';
    }
    _usernameFocusNode = FocusNode();
    _idNumberFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    widget.genderController.text = '1';
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
            limitLength: 255,
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
            defaultValue: Gender.male,
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
            limitLength: 12,
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
            limitLength: 100,
            isRequired: false,
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
