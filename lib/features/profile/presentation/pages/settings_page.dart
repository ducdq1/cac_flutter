import 'dart:io';
import 'dart:ui' as ui;

import 'package:citizen_app/core/functions/functions.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/common/dialogs/confirm_dialog.dart';
import 'package:citizen_app/features/common/http_proxy.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final pref = singleton<SharedPreferences>();
  String language = "vi";
  String locale = ui.window.locale.languageCode;
  bool valueFP = false;
  bool useProxy = false;
  bool _canCheckBiometric;
  String autherized = "Not autherized";

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    // print('language: ${language}');
    setState(() {
      language = handleLanguage();
      useProxy = pref.getBool('useProxy') ?? false;
    });
    // print('language: ${language}');
  }

  Future<bool> switchUseProxy(BuildContext context) async {
    if(!useProxy) {
      HttpProxy httpProxy = await HttpProxy.createHttpProxy(
          "10.61.11.42", "3128");
      HttpOverrides.global = httpProxy;
    }else{
      HttpOverrides.global = null;//await HttpProxy.createHttpProxy("", "");
    }

    setState(() {
      useProxy = !useProxy;
    });
    pref.setBool('useProxy', useProxy);
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
              InkWell(
                onTap: () {
                  showLanguageSettingDialog(
                      context: context,
                      languagePicked: language,
                      func: (String lang) async {
                        setState(() {
                          language = lang;
                        });
                        await pref.setString(
                            'languageDevice', language.toString());
                        Locale newLocale = Locale(language.toString(), '');
                        MyApp.setLocale(context, newLocale);

                        final authState =
                            BlocProvider.of<AuthBloc>(context).state;
                        if (authState is AuthenticatedState) {
                          BlocProvider.of<HomePageBloc>(context).add(
                              AppModulesFetched(
                                  provinceId: PROVINCE_ID,
                                  userId: 1));//authState.auth.userId
                        } else {
                          BlocProvider.of<HomePageBloc>(context).add(
                              AppModulesFetched(
                                  provinceId: PROVINCE_ID, userId: null));
                        }
                      });
                },
                child: TextSettingWidget(
                  icon: 'icon_lang.svg',
                  label: trans(SELECT_LANGUAGE),
                  value: language == "en" ? trans(ENGLISH) : trans(VIETNAMESE),
                ),
              ),
              ToggleFingerPrintWidget(
                  icon: 'icon_fingerprint_unselected.svg',
                  label: 'Use Proxy',
                  value: useProxy,
                  callback: () => switchUseProxy(context)),
              // ToggleNotificationWidget(
              //     icon: 'icon_notify.svg',
              //     label: trans(RECEIVE_NOTIFY),
              //     value: false),
            ],
          ),
        ),
      ),
    );
  }
}
