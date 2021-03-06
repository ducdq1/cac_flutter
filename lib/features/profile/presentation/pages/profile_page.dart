import 'package:cached_network_image/cached_network_image.dart';
import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/chat/page/chats_page.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../../../injection_container.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isAuthViettel = false;
  String avartarPath;
  String fullName = "";
  String userName = "";
  bool isCustomer = true;
  int userType;
  @override
  void initState() {
    SharedPreferences prefs = singleton<SharedPreferences>();
    if (prefs != null) {
      avartarPath = prefs.getString("avartarPath");
      avartarPath = '$baseUrl' + (avartarPath == null ? '' : avartarPath);
      fullName = prefs.getString("fullName");
      userName = prefs.getString("userName");
      userType = prefs.getInt("userType")??0;
      isCustomer = isCustomerUser();
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
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      //color: const Color(0xff7c94b6),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(80)),
                      border: new Border.all(
                        color: Color(0xff7c94b6),
                        width: 2.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Container(
                          width: 130.0,
                          height: 130.0,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: avartarPath,
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
                  ),
                  SizedBox(height: 20),
                  Text(
                    fullName,
                    textScaleFactor: 1.5,
                    style: GoogleFonts.inter(
                        color: SECONDARY_TEXT_COLOR,
                        fontSize: FONT_SMALL,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 50),
                ],
              )),
              //userType != 3 ?
              SizedBox(),
              //     : OptionItemWidget(
              //   icon: 'icon_info.png',
              //   label: 'Nh???n tin',
              //   // route: ROUTER_INFO_PAGE,
              //   page: ChatsPage(),
              // ),
              isCustomer
                  ? SizedBox()
                  : OptionItemWidget(
                      icon: 'icon_settings.png',
                      label: 'C??i ?????t',
                      // route: ROUTER_CHANGE_PASSWORD_PAGE,
                      page: SettingsPage(),
                    ),
             OptionItemWidget(
                icon: 'icon_info.png',
                label: 'C???p nh???t ???ng d???ng',
                // route: ROUTER_INFO_PAGE,
                page: null,
                callback: () async {
                  String url;
                  if (Platform.isAndroid) {
                    url =
                        'https://play.google.com/store/apps/details?id=com.noithat.cac';
                  } else if (Platform.isIOS) {
                    url = 'https://apps.apple.com/us/app/id1582099464';
                  }

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
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
