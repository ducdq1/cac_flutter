import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_event.dart';
import 'package:citizen_app/features/authentication/signup/presentation/active_account_otp_page.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_bloc.dart';
import 'package:citizen_app/features/common/dialogs/loading_dialog.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';

import 'bloc/signup_state.dart';
import 'widgets/signup_address_page/form_address_widget.dart';
import 'widgets/step_complete_widget.dart';

class SignUpAddressPage extends StatefulWidget {
  @override
  _SignUpAddressPageState createState() => _SignUpAddressPageState();
}

class _SignUpAddressPageState extends State<SignUpAddressPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
      title: trans(TITLE_SIGNUP_ACCOUNT),
      centerTitle: true,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (_, state) {
            if (state is RegisteringAccountState) {
              showLoadingDialog(context, trans(TITLE_SIGNING_UP));
            } else if (state is RegisterAccountSucceedState) {
              Navigator.pop(context);
              BlocProvider.of<AuthBloc>(context)
                  .add(AuthenticatedEvent(auth: state.auth));
              // Navigator.of(context).push(
              //   PageRouteTransition(
              //     animationType: AnimationType.slide_right,
              //     builder: (context) => ActiveAccountOtpPage(),
              //   ),
              // );
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteTransition(
                  animationType: AnimationType.slide_right,
                  builder: (context) => ActiveAccountOtpPage(),
                ),
                (route) => false,
              );
            } else if (state is RegisterAccountFaildState) {
              Navigator.pop(context);
              print(state.message);
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
          child: Column(
            children: [
              SizedBox(height: 50),
              StepCompleteWidget(total: 3, completeIndex: 1),
              SizedBox(height: 40),
              Text(
                trans(ENTER_PERMANENT_ADDRESS),
                style: GoogleFonts.inter(
                  fontSize: FONT_EX_LARGE,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: PRIMARY_TEXT_COLOR,
                ),
              ),
              FormAddressWidget(scrollController: _scrollController),
            ],
          ),
        ),
      ),
    );
  }
}
