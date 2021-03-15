import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/common/dialogs/confirm_dialog.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:route_transitions/route_transitions.dart';

class NotificationBellWidget extends StatefulWidget {
  @override
  _NotificationBellWidgetState createState() => _NotificationBellWidgetState();
}

class _NotificationBellWidgetState extends State<NotificationBellWidget> {
  // String _router = ROUTER_SIGNIN;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              icon: Center(
                  child: SvgPicture.asset(SVG_ASSETS_PATH + 'icon_bell.svg')),
              onPressed: () {
                // if (_router == ROUTER_SIGNIN) {
                //   showConfirmDialog(
                //     context: context,
                //     icon: Icon(
                //       Icons.logout,
                //       color: Colors.orangeAccent,
                //     ),
                //     title: LOGIN_REQUIRE),
                //     label: 'Đăng nhập',
                //     onSubmit: () {
                //       Navigator.pushNamed(context, _router);
                //     },
                //   );
                // } else {
                //   Navigator.pushNamed(context, _router);
                // }
                if (BlocProvider.of<AuthBloc>(context).state
                    is UnAuthenticateState) {
                  showConfirmDialog(
                    context: context,
                    icon: Icon(
                      Icons.logout,
                      color: Colors.orangeAccent,
                    ),
                    title: trans(LOGIN_REQUIRE_TO_READ_NOTIFY),
                    label: trans(TITLE_LOGIN_SCREEN),
                    onSubmit: () {
                      Navigator.of(context).pushNamed(ROUTER_SIGNIN);
                    },
                  );
                } else {
                  Navigator.of(context).pushNamed(ROUTER_NOTIFICATION);
                }
              },
            ),
          ),
          BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
            if (state is HomePageSuccess &&
                state.appModules.hasNotification == true) {
              return Positioned(
                top: 18,
                right: 18,
                child: Icon(Icons.circle, color: Colors.red, size: 10),
              );
            } else
              return SizedBox();
          }),
        ],
      ),
    );
  }
}
