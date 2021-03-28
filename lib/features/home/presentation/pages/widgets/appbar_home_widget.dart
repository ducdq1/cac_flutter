import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/authentication/signin/presentation/signin_page.dart';
import 'package:citizen_app/features/common/dialogs/confirm_dialog.dart';
import 'package:citizen_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';

class AppBarHomeWidget extends StatefulWidget implements PreferredSizeWidget {
  // final void Function() reloadPage;

  AppBarHomeWidget({Key key})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _AppBarHomeWidgetState createState() => _AppBarHomeWidgetState();
}

class _AppBarHomeWidgetState extends State<AppBarHomeWidget> {
  // var auth = BlocProvider.of<AuthBloc>(context).state;
  // AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    // _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PRIMARY_COLOR,
      //actions: [NotificationBellWidget()],
      leading: IconButton(
        alignment: Alignment.center,
        // padding: EdgeInsets.only(left: 16),
        icon:
            Center(child: SvgPicture.asset(SVG_ASSETS_PATH + 'icon_user.svg')),
        onPressed: () {
          if (BlocProvider.of<AuthBloc>(context).state is UnAuthenticateState) {
            showConfirmDialog(
              context: context,
              icon: Icon(
                Icons.logout,
                color: Colors.orangeAccent,
              ),
              title: trans(LOGIN_REQUIRE),
              label: trans(TITLE_LOGIN_SCREEN),
              onSubmit: () {
                Navigator.of(context).push(
                  PageRouteTransition(
                    animationType: AnimationType.slide_right,
                    builder: (context) => SignInPage(),
                  ),
                );
              },
            );
          } else {
            Navigator.of(context).push(
              PageRouteTransition(
                animationType: AnimationType.scale,
                builder: (context) => ProfilePage(),
              ),
            );
          }
        },
      ),
      centerTitle: true,
      elevation: 0,
      title: Text(
        // APP_NAME,
        'Công ty TNHH C.A.C',
        style: GoogleFonts.openSans(
          color: Colors.white,
          fontSize: FONT_HUGE,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
