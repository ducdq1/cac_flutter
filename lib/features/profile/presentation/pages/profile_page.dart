import 'package:cached_network_image/cached_network_image.dart';
import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/profile/presentation/pages/change_password_page.dart';
import 'package:citizen_app/features/profile/presentation/pages/settings_page.dart';
import 'package:citizen_app/features/profile/presentation/pages/update_profile_page.dart';
import 'package:citizen_app/features/profile/presentation/pages/view_info_page.dart';
import 'package:citizen_app/features/profile/presentation/widgets/profile_page/option_item_widget.dart';
import 'package:citizen_app/features/profile/presentation/widgets/signout_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../injection_container.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isAuthViettel = false;
  String avartarPath;
  String fullName = "";

  @override
  void initState() {
    SharedPreferences prefs = singleton<SharedPreferences>();
    if (prefs != null) {
      avartarPath = prefs.getString("avartarPath");
      avartarPath = '$baseUrl' + avartarPath;
      fullName = prefs.getString("fullName");
    }
    isAuthViettel().then((isAuthViettel) {
      setState(() {
        _isAuthViettel = isAuthViettel;
      });
    });
    super.initState();
  }

  Future<bool> isAuthViettel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int isAuthViettel = prefs.getInt("isAuthViettel");

      if (isAuthViettel == 1) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // print(sharedPreferences.getString('isViettelAuth'));
    final auth =
        (BlocProvider.of<AuthBloc>(context).state as AuthenticatedState).auth;
    return BaseLayoutWidget(
      title: transWithContext(TITLE_PROFILE_SCREEN, context),
      centerTitle: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Center(
                  child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: avartarPath + '2',
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(strokeWidth: 2.0),
                          height: 15,
                          width: 15,
                          errorWidget: (context, url, error) => Image.asset(
                            ICONS_ASSETS + 'default-avatar.png',
                            height: 100,
                            width: 100,
                          ),
                        )),
                  ),
                  SizedBox(height: 20),
                  Text(
                    fullName,
                    textScaleFactor: 1.5,
                    style: GoogleFonts.inter(
                      color: SECONDARY_TEXT_COLOR,
                      fontSize: FONT_SMALL,
                      fontWeight: FontWeight.bold
                    ),

                  ), SizedBox(height: 50),
                ],
              )),

              SizedBox(),
              // : OptionItemWidget(
              //     icon: 'icon_change_password.png',
              //     label: trans(TITLE_CHANGE_PASSWORD),
              //     // route: ROUTER_CHANGE_PASSWORD_PAGE,
              //     page: ChangePasswordPage(),
              //   ),
              OptionItemWidget(
                icon: 'icon_info.png',
                label: trans(INFORMATION),
                // route: ROUTER_INFO_PAGE,
                page: ViewInfoPage(),
              ),
              OptionItemWidget(
                icon: 'icon_sign_out.png',
                label: trans(TITLE_LOGOUT),
                callback: () async {
                  showDialog(
                    context: context,
                    builder: (_) => SignOutConfirmDialog(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
