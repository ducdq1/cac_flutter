import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../injection_container.dart';

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
  String avartarPath;

  @override
  void initState() {
    super.initState();
    // _authBloc = BlocProvider.of<AuthBloc>(context);
    SharedPreferences prefs = singleton<SharedPreferences>();
    setState(() {
      if (prefs != null) {
        avartarPath = prefs.getString("avartarPath");
        if (avartarPath != null && avartarPath.isNotEmpty) {
          avartarPath = '$baseUrl' + avartarPath;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PRIMARY_COLOR,
      //actions: [NotificationBellWidget()],
      leading: IconButton(
        alignment: Alignment.center,
        // padding: EdgeInsets.only(left: 16),
        icon: Center(
            child: (avartarPath == null || avartarPath.isEmpty)
                ? SvgPicture.asset(SVG_ASSETS_PATH + 'icon_user.svg')
                : ClipOval(
                    child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: avartarPath,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(strokeWidth: 2.0),
                          height: 15,
                          width: 15,
                          errorWidget: (context, url, error) => Image.asset(
                            ICONS_ASSETS + 'default-avatar.png',
                            height: 40,
                            width: 40,
                          ),
                        )),
                  )),
        onPressed: () {
          if (getUserName() == null || BlocProvider.of<AuthBloc>(context).state is UnAuthenticateState) {
            showConfirmDialog(
              context: context,
              icon: Icon(
                Icons.logout,
                color: Colors.orangeAccent,
              ),
              title: 'Để sử dụng tính năng này bạn phải cập nhật thông tin cá nhân',
              label: 'Cập nhật',
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
      title: Container(
        padding: EdgeInsets.only(right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'THIẾT BỊ NỘI THẤT C.A.C',
                  style: GoogleFonts.inter(
                    fontSize: FONT_LARGE,
                    fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '11 Pasteur, Hải Châu, Đà Nẵng',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
