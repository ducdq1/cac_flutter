import 'dart:io';
import 'dart:ui' as ui;

import 'package:citizen_app/core/functions/functions.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/common/dialogs/confirm_dialog.dart';
import 'package:citizen_app/features/common/http_proxy.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/profile/presentation/widgets/settings_page/language_dialog.dart';
import 'package:citizen_app/features/profile/presentation/widgets/settings_page/text_setting_widget.dart';
import 'package:citizen_app/features/profile/presentation/widgets/settings_page/toggle_fingerprint_widget.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:citizen_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget  {
  @override
  _SettingsPageState createState() => _SettingsPageState();


}

class _SettingsPageState extends State<SettingsPage>   implements OnButtonClickListener{
  final pref = singleton<SharedPreferences>();
  String language = "vi";
  String locale = ui.window.locale.languageCode;
  bool valueFP = false;
  bool useProxy = false;
  bool _canCheckBiometric;
  String autherized = "Not autherized";
  TextEditingController controller;
  TextEditingController applicationController;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  onClick(String id) {
    saveConfig();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    controller = new TextEditingController();
    applicationController = new TextEditingController();
    // print('language: ${language}');
    setState(() {
      language = handleLanguage();
      useProxy = pref.getBool('useProxy') ?? false;

      String appName = pref.getString('APPLICATION_NAME');
      applicationController.text =appName == null || appName.isEmpty ? "ketoan" : appName;

      String IP_SERVER = pref.getString('IP_SERVER');
      controller.text = IP_SERVER == null || IP_SERVER.isEmpty
          ? "http://117.2.164.156/"
          : IP_SERVER;
    });
    super.initState();
    // print('language: ${language}');
  }

  Future<bool> saveConfig() async {
    pref.setString('IP_SERVER', controller.text);
    pref.setString('APPLICATION_NAME',applicationController.text);
    return useProxy;
  }

  Future<bool> switchFP(BuildContext context) async {
    bool succeedSaveFPToCache = valueFP;
    if (valueFP == true) {
      await showConfirmDialog(
          context: context,
          label: trans(AGREE),
          title: trans(CONFIRM_DELETE_FINGERPRINT),
          onSubmit: () {
            setState(() {
              valueFP = false;
            });
            succeedSaveFPToCache = false;
            pref.remove('fingerprint');
            pref.remove('authTemp');
            pref.remove('tokenTemp');
          });
    } else {
      // showFingerPrintDialog(context: context);
      print('_canCheckBiometric: $_canCheckBiometric');
      setState(() {
        valueFP = succeedSaveFPToCache;
      });
    }

    return succeedSaveFPToCache;
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
      title: trans(TITLE_SETTING_SCREEN),
      centerTitle: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            children: [
              // TextSettingWidget(
              //   icon: 'icon_setup.svg',
              //   label: 'Thiết lập người dùng',
              //   value: 'Khách du lịch',
              // ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image.asset(
                    //   IMAGE_ASSETS_PATH + 'icon_info.png',
                    //   width: 24,
                    //   height: 24,
                    //   fit: BoxFit.fill,
                    // ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IP máy chủ: ',
                              style: GoogleFonts.inter(
                                fontSize: FONT_MIDDLE,
                                fontWeight: FontWeight.bold,
                                color: PRIMARY_TEXT_COLOR,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: controller,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: BORDER_COLOR, width: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: PRIMARY_COLOR, width: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  //enabledBorder: InputBorder.none,
                                  //errorBorder: InputBorder.none,
                                  //disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Địa chỉ máy chủ"),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Ứng dụng: ',
                              style: GoogleFonts.inter(
                                fontSize: FONT_MIDDLE,
                                fontWeight: FontWeight.bold,
                                color: PRIMARY_TEXT_COLOR,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: applicationController,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: BORDER_COLOR, width: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: PRIMARY_COLOR, width: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  //enabledBorder: InputBorder.none,
                                  //errorBorder: InputBorder.none,
                                  //disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Địa chỉ máy chủ"),
                            )
                          ]),

                    ),
                  ]),
              // ToggleNotificationWidget(
              //     icon: 'icon_notify.svg',
              //     label: trans(RECEIVE_NOTIFY),
              //     value: false),
              SizedBox(height: 30),
              PrimaryButton(
                  label: 'Lưu thông tin', ctx: this, id: 'share_btn')],
          ),
        ),
      ),
    );
  }
}
