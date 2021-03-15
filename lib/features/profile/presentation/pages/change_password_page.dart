import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/password_validate.dart';
import 'package:citizen_app/core/utils/validate/similar_validate.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/common/dialogs/loading_dialog.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/profile/presentation/bloc/change_password_bloc.dart';
import 'package:citizen_app/features/profile/presentation/bloc/change_password_event.dart';
import 'package:citizen_app/features/profile/presentation/bloc/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/no_permission_failure_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    implements OnButtonClickListener {
  FocusNode _oldPasswordFocusNode;
  FocusNode _newPasswordFocusNode;
  FocusNode _confirmPasswordFocusNode;

  TextEditingController _oldPasswordController;
  TextEditingController _newPasswordController;
  TextEditingController _confirmPasswordController;
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _oldPasswordFocusNode = FocusNode();
    _newPasswordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();

    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth =
        (BlocProvider.of<AuthBloc>(context).state as AuthenticatedState).auth;
    return BaseLayoutWidget(
      title: trans(TITLE_CHANGE_PASSWORD),
      centerTitle: true,
      body: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (_, state) {
          if (state is ChangePasswordProcessingState) {
            showLoadingDialog(context, trans(CHANGING_PASSWORD));
          } else if (state is ChangePasswordSucceedState) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(ROUTER_SIGNIN, (route) => false);
          } else if (state is ChangePasswordFaildState) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        child:  SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 38),
                    child: Column(
                      children: [
                        SizedBox(height: 80),
                        InputValidateCustomWidget(
                          focusNode: _oldPasswordFocusNode,
                          controller: _oldPasswordController,
                          label: trans(LABEL_CURRENT_PASSWORD),
                          obscureText: true,
                          validates: [
                            EmptyValidate(),
                            PasswordValidate(),
                          ],
                          focusError: (FocusNode focusNode) {},
                        ),
                        InputValidateCustomWidget(
                          focusNode: _newPasswordFocusNode,
                          controller: _newPasswordController,
                          label: trans(LABEL_NEW_PASSWORD),
                          obscureText: true,
                          validates: [
                            EmptyValidate(),
                            PasswordValidate(),
                          ],
                          focusError: (FocusNode focusNode) {},
                        ),
                        InputValidateCustomWidget(
                          focusNode: _confirmPasswordFocusNode,
                          controller: _confirmPasswordController,
                          label: trans(ENTER_THE_PASSWORD),
                          obscureText: true,
                          validates: [
                            EmptyValidate(),
                            PasswordValidate(),
                            SimilarValidate(controller: _newPasswordController),
                          ],
                          focusError: (FocusNode focusNode) {},
                        ),
                        SizedBox(height: 40),
                        PrimaryButton(
                            label: trans(TITLE_CHANGE_PASSWORD), ctx: this)
                      ],
                    ),
                  ),
                ),
              )

      ),
    );
  }

  @override
  onClick(String id) {
    final auth = BlocProvider.of<AuthBloc>(context).state;
    if (_formKey.currentState.validate() && auth is AuthenticatedState) {
      BlocProvider.of<ChangePasswordBloc>(context)
          .add(StartChangingPasswordEvent(
        username: '',// auth.auth.phone,
        newPassword: _newPasswordController.text.trim(),
        oldPassword: _oldPasswordController.text.trim(),
      ));
    }
  }
}
