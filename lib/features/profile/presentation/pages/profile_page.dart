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
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isAuthViettel = false;

  @override
  void initState() {
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
              //_isAuthViettel ?
                  SizedBox(),
                  // : OptionItemWidget(
                  //     icon: 'icon_update.png',
                  //     label: trans(UPDATE_ACCOUNT),
                  //     // route: ROUTER_UPDATE_PROFILE_PAGE,
                  //     page: UpdateProfilePage(),
                  //   ),
              OptionItemWidget(
                icon: 'icon_settings.png',
                label: trans(TITLE_SETTING_SCREEN),
                // route: ROUTER_SETTINGS_PAGE,
                page: SettingsPage(),
              ),
              // _isAuthViettel ?

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
