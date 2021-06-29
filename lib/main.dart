import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_event.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:citizen_app/features/authentication/signin/domain/usecases/signin_usecase.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_bloc.dart';
import 'package:citizen_app/features/authentication/signin/presentation/signin_page.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/active_account_bloc.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_bloc.dart';
import 'package:citizen_app/features/common/http_proxy.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/features/paht/domain/usecases/get_detailed_paht.dart';
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_issue_bloc/create_issue_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/detailed_paht_bloc/detailed_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/pages/approve_quotation_page.dart';
import 'package:citizen_app/features/paht/presentation/pages/business_hour_page.dart';
import 'package:citizen_app/features/paht/presentation/pages/choose_product_page.dart';
import 'package:citizen_app/features/paht/presentation/pages/pages.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_detail_page.dart';
import 'package:citizen_app/features/paht/presentation/pages/product_search.dart';
import 'package:citizen_app/features/paht/presentation/pages/qr_scaner.dart';
import 'package:citizen_app/features/profile/presentation/bloc/update_profile_bloc.dart';
import 'package:citizen_app/features/profile/presentation/pages/change_password_page.dart';
import 'package:citizen_app/features/profile/presentation/pages/profile_page.dart';
import 'package:citizen_app/features/profile/presentation/pages/settings_page.dart';
import 'package:citizen_app/features/profile/presentation/pages/update_profile_page.dart';
import 'package:citizen_app/features/profile/presentation/pages/view_info_page.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:citizen_app/simple_bloc_observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:citizen_app/features/paht/presentation/widgets/paht_page/saled_quotation_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/aprove_quotation_widget.dart';
import 'features/customer/presentation/pages/index_page.dart';
import 'features/profile/presentation/bloc/change_password_bloc.dart';
import 'injection_container.dart' as di;

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: PRIMARY_COLOR,
  ));
  await di.init();
  final pref = singleton<SharedPreferences>();
  WidgetsFlutterBinding.ensureInitialized();
  //if(pref.get('token') == null || pref.get('token').toString().isEmpty || pref.get("useProxy") == true) {
    HttpProxy httpProxy = await HttpProxy.createHttpProxy("10.61.11.42", "3128");
    HttpOverrides.global = httpProxy;
  //   pref.setBool("useProxy", true);
//  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.changeLanguage(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  final pref = singleton<SharedPreferences>();
  final navKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  changeLanguage(Locale locale) {
    print('locale: ${locale}');
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    String token = pref.get('userName');
    bool isCustomer =  pref.get('isCustomer');
    //token ='hard code';
    int loginTime = pref.get('loginTime');
    if(loginTime != null){
      int now =  DateTime.now().millisecondsSinceEpoch;
      if(now - loginTime> (1000 * 7 * 24 * 60 * 60) ){
        token = null;
      }
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateIssueBloc>(
          create: (BuildContext context) => singleton<CreateIssueBloc>(),
        ),
        BlocProvider<CategoryPahtBloc>(
          create: (BuildContext context) => singleton<CategoryPahtBloc>(),
        ),
        BlocProvider<SignInBloc>(
          create: (BuildContext context) =>
              SignInBloc(signInUseCase: SignInUseCase()),
        ),
        BlocProvider<AuthBloc>(
          create: (BuildContext context) =>
              AuthBloc()..add(UnknownAuthenticateEvent()),
        ),
        BlocProvider<SignUpBloc>(
          create: (BuildContext context) => SignUpBloc(),
        ),
        BlocProvider<ActiveAccountBloc>(
          create: (BuildContext context) => ActiveAccountBloc(),
        ),
        BlocProvider<ForgotPasswordBloc>(
          create: (BuildContext context) => ForgotPasswordBloc(),
        ),
        BlocProvider<ChangePasswordBloc>(
          create: (BuildContext context) => ChangePasswordBloc(),
        ),
        BlocProvider<UpdateProfileBloc>(
          create: (BuildContext context) => UpdateProfileBloc(),
        ),
        BlocProvider<HomePageBloc>(
            create: (BuildContext context) => singleton<HomePageBloc>()),
        BlocProvider<DetailedPahtBloc>(
          create: (BuildContext context) => singleton<DetailedPahtBloc>(),

        ),

      ],
      child: MaterialApp(
        locale: _locale,
        supportedLocales: [
          const Locale('vi', ''), // Vietnam, no country code
          const Locale('en', ''), // English, no country code
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode ==
                pref.getString('languageDevice')) {
              return supportedLocale;
            }
          }
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (Vietnamese, in this case).
          return supportedLocales.first;
        },
        navigatorKey: navKey,
        title: 'C.A.C Báo giá',
        initialRoute:
            (token != null && !token.isEmpty) ?
            isCustomer ? ROUTER_CUS_HOME_PAGE : ROUTER_HOME :  ROUTER_SIGNIN,
        // ROUTER_CUS_HOME_PAGE,
        routes: {
          ROUTER_SIGNIN: (context) => SignInPage(),
          ROUTER_PAHT: (context) => Paht(),
          ROUTER_HOME: (context) => HomePage(),
          ROUTER_SEARCH_PERSONAL_PAHT: (context) => PahtSearch(
                searchPahtType: 1,
              ),
          ROUTER_SEARCH_PUBLIC_PAHT: (context) => PahtSearch(
                searchPahtType: 0,
              ),
          ROUTER_CREATE_PAHT: (context) => PahtCreateIssue(),
          ROUTER_DETAILED_PAHT: (context) => PahtDetailPage(),
          ROUTER_CHOOSE_PRODUCT: (context) => ChooseProductPage(),
          ROUTER_PROFILE_PAGE: (context) => ProfilePage(),
          ROUTER_UPDATE_PROFILE_PAGE: (context) => UpdateProfilePage(),
          ROUTER_SETTINGS_PAGE: (context) => SettingsPage(),
          ROUTER_CHANGE_PASSWORD_PAGE: (context) => ChangePasswordPage(),
          ROUTER_INFO_PAGE: (context) => ViewInfoPage(),
          ROUTER_BUSINESS_HOUR_PAGE: (context) => BusinessHourPage(),
          ROUTER_QRCODE_SCANER: (context) => QRSCaner(),
          ROUTER_APROVE_PAHT: (context) => ApproveQuotation(),
          ROUTER_APPROVE_QUOTATION_PAGE : (context) => ApproveQuotationPage(),
          ROUTER_SALED_QUOTATION : (context) => SaledQuotation(),
          ROUTER_SEARCH_PRODUCT :(context) => ProductSearch(),
          ROUTER_CUS_HOME_PAGE: (context) => Indexpage()  ,
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
