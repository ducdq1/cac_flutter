import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/appbar_home_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/home_page_builder.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/sos_button_widget.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// Completer<void> _refreshCompleter;

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final StopScrollController _stopScrollController = StopScrollController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid;
  final pref = singleton<SharedPreferences>();
  var _firebaseMessaging;
  // bool closeTopContainer = false;
  // double scale = 1;
  // int reload = 0;
  int userId;

  // void reloadPage() {
  //   setState(() {
  //     reload += 1;
  //   });
  // }

  @override
  void initState(){
    super.initState();
    final state = BlocProvider.of<AuthBloc>(context).state;
    if (state is AuthenticatedState) {
      //userId = state.auth.userId;
      userId = null;
      //print('state.auth.userId: ${state.auth.userId}');
      BlocProvider.of<HomePageBloc>(context)
          .add(AppModulesFetched(provinceId: PROVINCE_ID, userId: userId));
    } else {
      userId = null;
      BlocProvider.of<HomePageBloc>(context)
          .add(AppModulesFetched(provinceId: PROVINCE_ID, userId: userId));
    }

    _firebaseMessaging = FirebaseMessaging();

    initFlutterLocalNotificationsPlugin();
    String token = _firebaseMessaging.getToken().toString();
    print('Firebase Device Token:  '  + token);
    String userName = pref.get('userName');
    print(userName);
      int userType = pref.getInt('userType');
      if(userType !=null && userType == 3){
        _firebaseMessaging.subscribeToTopic('create');
        _firebaseMessaging.subscribeToTopic('customer');
      }
      if(userName !=null){
        _firebaseMessaging.subscribeToTopic(userName);
      }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> msg) async {
        print("home_page onMessage: $msg");
        var payload = {};
        if (Platform.isIOS) {
          payload = {}; //{"orderId": msg["orderId"], "type": msg["type"]};
          print('ios message');
          showNotification(
            title: msg['aps']['alert']['title'],
            body: msg['aps']['alert']['body'],
            payload: jsonEncode(payload),
          );
        } else {
          showNotification(
            title: msg['notification']['title'],
            body: msg['notification']['body'],
            payload: jsonEncode(payload),
          );
        }
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        if(userType ==3){
          Navigator.pushNamed(context, ROUTER_APROVE_PAHT);
        }else{
          Navigator.pushNamed(context, ROUTER_HOME);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
       if(userType ==3){
          Navigator.pushNamed(context, ROUTER_APROVE_PAHT);
        }else{
          Navigator.pushNamed(context, ROUTER_HOME);
        }
      },
    );
  }

  void initFlutterLocalNotificationsPlugin() async {
    final token = await _firebaseMessaging.getToken();
    print('token: ' + token.toString());
    initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      // macOS: initializationSettingsMacOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async {
        //selectNotificationSubject.add(payload);
      },
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(
      {String title, String body, String payload}) async {
    var isCustomer = pref.getBool('isCustomer') ?? false;
    if(isCustomer){
      return;
    }

    print(title.toString());
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'cac_app_id', 'cac_app_channel', 'show notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    if (payload != null) {
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //   'Đường chéo: ${sqrt(MediaQuery.of(context).size.width * MediaQuery.of(context).size.width + MediaQuery.of(context).size.height * MediaQuery.of(context).size.height)}');
    return
        // BlocListener<AuthBloc, AuthState>(
        //   listener: (_, state) {
        //     if (state is AuthenticatedState) {
        //       userId = state.auth.userId;
        //       print('state.auth.userId: ${state.auth.userId}');
        //       BlocProvider.of<HomePageBloc>(context)
        //           .add(AppModulesFetched(provinceId: PROVINCE_ID, userId: userId));
        //     } else {
        //       userId = null;
        //       BlocProvider.of<HomePageBloc>(context)
        //           .add(AppModulesFetched(provinceId: PROVINCE_ID, userId: userId));
        //     }
        //   },
        //   child:
        Scaffold(
      //resizeToAvoidBottomPadding: false,
      backgroundColor: PRIMARY_COLOR,
      appBar: AppBarHomeWidget(),
      //floatingActionButton: Container(
      //  height: 96,
      //  width: 96,
      //  child: SOSButtonWidget(),
      // ),
      body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              _stopScrollController.stopScroll();
              return true;
            }
            return false;
          },
          child: HomePageBuilder(
            scrollController: _scrollController,
            stopScrollController: _stopScrollController,
          )),
      // ),
    );
  }
}

class StopScrollController {
  void Function() stopScroll;
}
