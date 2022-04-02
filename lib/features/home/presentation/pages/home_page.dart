import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/authentication/signin/presentation/signin_page.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/features/home/presentation/bloc/bloc/home_page_bloc.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/appbar_home_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/home_page_builder.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/sos_button_widget.dart';
import 'package:citizen_app/features/paht/data/repositories/paht_repository_impl.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:route_transitions/route_transitions.dart';
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

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState(){
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    final Animation curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _animation = Tween(begin: 0.0, end: 29.0).animate(curve);
    _controller.repeat(reverse: true);

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

    String userName = pref.get('userName');
    updateLastLogin();

    _firebaseMessaging = FirebaseMessaging();

    initFlutterLocalNotificationsPlugin();
    String token = _firebaseMessaging.getToken().toString();
    print('Firebase Device Token:  '  + token);
    print(userName);
      int userType = pref.getInt('userType');
      String userRole = pref.get('userRole');

      if(userRole !=null && userRole == UserField.ROLE_MESSAGE ){
        _firebaseMessaging.subscribeToTopic('customer');
      }

      if(userType !=null && userType == 3){
        _firebaseMessaging.subscribeToTopic('create');
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
          Navigator.pushNamed(context, ROUTER_HOME);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
          Navigator.pushNamed(context, ROUTER_HOME);
      },
    );
  }

  void updateLastLogin() async{
    String userName = pref.get('userName');
    String pw = pref.get('pw');
    PahtRepositoryImpl repo = PahtRepositoryImpl(localDataSource: singleton(),
      networkInfo: singleton(),
      remoteDataSource: singleton(),);
    print('Checking user........');

    bool isValidUser = await repo.checkUser(userName,pw);
    if (userName == null || isValidUser == false) {
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteTransition(
            animationType: AnimationType.slide_right,
            builder: (context) => SignInPage(isCustomer: false),
          ),
              (route) => false,
        );
      });
    }
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
    var isCustomer = isCustomerUser();
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

        Scaffold(
      //resizeToAvoidBottomPadding: false,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: "scan",
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icons/icon_scan_qr_white.png',
                      width: 29,
                      height: 29,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.scaleDown,
                    ),
                    AnimatedBuilder(
                      animation: _animation,
                      child: Container(
                        color: Colors.white,
                        height: 1.5,
                        width: 29,
                      ),
                      builder: (_, widget) {
                        return Transform.translate(
                          offset: Offset(0.0, _animation.value),
                          child: widget,
                        );
                      },
                    )
                  ],
                ),
                // Icon( '/icons/icon_scan_qr.png', color: Colors.white, size: 29,),
                backgroundColor: PRIMARY_COLOR,
                tooltip: 'Quét mã',
                elevation: 5,
                splashColor: Colors.grey,
                onPressed: () async {
                  onScanClick(context);
                },
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
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
void onScanClick(BuildContext context) async{
  final PermissionHandler _permissionHandler =
  PermissionHandler();
  var permissionStatus =
  await _permissionHandler
      .checkPermissionStatus(
      PermissionGroup.camera);

  switch (permissionStatus) {
    case PermissionStatus.granted:
      var value = await Navigator.of(context)
          .pushNamed(ROUTER_QRCODE_SCANER);
      if (value != null) {
        Navigator.pushNamed(
            context, ROUTER_DETAILED_PAHT,
            arguments: PahtDetailArgument(
                productCode: value));
      }

      break;
    case PermissionStatus.denied:
    case PermissionStatus.restricted:
    case PermissionStatus.unknown:
      await _permissionHandler
          .requestPermissions(
          [PermissionGroup.camera]);
      var permissionStatus =
      await _permissionHandler
          .checkPermissionStatus(
          PermissionGroup.camera);

      switch (permissionStatus) {
        case PermissionStatus.granted:
          var value = await Navigator.of(
              context)
              .pushNamed(ROUTER_QRCODE_SCANER);
          if (value != null) {
            Navigator.pushNamed(
                context, ROUTER_DETAILED_PAHT,
                arguments: PahtDetailArgument(
                    productCode: value));
          }
      }
      break;
    default:
  }
}

class StopScrollController {
  void Function() stopScroll;
}
