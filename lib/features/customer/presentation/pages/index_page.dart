import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/chat/api/firebase_api.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/features/chat/page/my_chat_page.dart';
import 'package:citizen_app/features/common/blocs/blocs.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/customer/presentation/bloc/notification/notification_bloc.dart';
import 'package:citizen_app/features/customer/presentation/bloc/productCategory/product_category_bloc.dart';
import 'package:citizen_app/features/customer/presentation/bloc/promotion/promotion_bloc.dart';
import 'package:citizen_app/features/customer/presentation/pages/product_category_page.dart';
import 'package:citizen_app/features/customer/presentation/pages/products_page.dart';
import 'package:citizen_app/features/customer/presentation/pages/promotions_page.dart';
import 'package:citizen_app/features/home/presentation/pages/home_page.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/appbar_home_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/banner_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/profile/presentation/pages/view_info_page.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../../../main.dart';

import 'package:get_it/get_it.dart';

const SIZE_ICON_BOTTOM_BAR = 28.0;
const SIZE_ICON_FLOATING_BUTTON = 24.0;
const SIZE_ICON_ACTIONS = 20.0;

class Indexpage extends StatefulWidget {
  @override
  _IndexpageState createState() => _IndexpageState();
}

class _IndexpageState extends State<Indexpage> {
  bool isFilter = false;
  int indexTab = 0;
  final ScrollController _scrollController = ScrollController();
  final StopScrollController _stopScrollController = StopScrollController();
  int badgeCount = 0;
  var _firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid;
  User myUser;
  // var streamController = StreamController<int>()
  //   ..sink.add(0); //cho nay sai roi, no return ve void
  //.add(0);

  @override
  void initState() {

    badgeCount = 0;
    initFirebaseData();
    super.initState();
    // _addBadgeCount();
    // Future.delayed(Duration(milliseconds: 5000), _addBadgeCount);
    // BlocProvider.of<BottomNavigationBloc>(context)
    //     .add(NotificationEvent(numBadge: badgeCount ++ ));

    _firebaseMessaging = FirebaseMessaging();
    initFlutterLocalNotificationsPlugin();
    String userName = pref.get('userName');
    print(userName);
    var isCustomer = pref.getBool('isCustomer') ?? false;
    if (isCustomer) {
      _firebaseMessaging.subscribeToTopic('allCustomer');
    }

    if (userName != null) {
      _firebaseMessaging.subscribeToTopic(userName);
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> msg) async {
        print("customer onMessage1: $msg");
        print('badgeCount ' + badgeCount.toString());
        badgeCount++;
        updateBadgeData(badgeCount);
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
        Navigator.pushNamed(context, ROUTER_CUS_HOME_PAGE);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.pushNamed(context, ROUTER_CUS_HOME_PAGE);
      },
    );
  }

  Future<bool> _onBackPressed() async{
    if(myUser !=null) {
      await FirebaseFirestore.instance.collection('users')
          .doc(myUser.idUser)
          .update({"lastOnlineTime": DateTime.now(),
        "status": "offline"});
    }
    exit(0);
    return false;
  }

  void updateBadgeData(int vaue) {
    singleton<NotificationBloc>().add(NotificationEvent(vaue));
  }

  void initFlutterLocalNotificationsPlugin() async {
    // if (Platform.isAndroid) {
    //
    //   List<Map<String, String>>  _installedApps = await AppAvailability.getInstalledApps();
    //
    //   print(await AppAvailability.checkAvailability("com.android.chrome"));
    //   // Returns: Map<String, String>{app_name: Chrome, package_name: com.android.chrome, versionCode: null, version_name: 55.0.2883.91}
    //   AppAvailability.launchApp("com.zing.zalo").then((_) {
    //   }).catchError((err) {
    //     print(err);
    //   });
    //
    //   print(await AppAvailability.isAppEnabled("com.android.chrome"));
    //   // Returns: true
    //
    // }
    // else if (Platform.isIOS) {
    //   // iOS doesn't allow to get installed apps.
    //   //_installedApps = iOSApps;
    //
    //   print(await AppAvailability.checkAvailability("calshow://"));
    //   // Returns: Map<String, String>{app_name: , package_name: calshow://, versionCode: , version_name: }
    //
    // }

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
    if (!isCustomer) {
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

  void initFirebaseData() async {
    //await FirebaseApi.getAdminUser();
    myUser = await FirebaseApi.getMyUser();
    bool isCustomer =  pref.getBool('isCustomer');
    if (isCustomer) {
      await FirebaseApi.checkHasMessage(myUser.idUser, myUser);
    }
  }

  void handleRefresh(context, {int indexTab}) {}

  @override
  Widget build(BuildContext context) {
    // lam sao han goi y code anh he?
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationBloc>(
            create: (context) => BottomNavigationBloc()
              ..add(
                TabStarted(),
              )),
        BlocProvider<NotificationBloc>(
            create: (context) =>
                singleton<NotificationBloc>()..add(NotificationEvent(0))),
        BlocProvider<PromotionBloc>(
            create: (context) =>
                singleton<PromotionBloc>()..add(ListPromotionFetching())),
        // BlocProvider<ProductCategoryBloc>(
        //   create: (context) => singleton<ProductCategoryBloc>()
        //     ..add(
        //       ListProductCategoriesFetching(),
        //     ),
        // ),
      ],
      child: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (BuildContext context, BottomNavigationState state) {
          return WillPopScope(
            onWillPop: _onBackPressed,
            child: Scaffold(
              backgroundColor: PRIMARY_COLOR,
              appBar: AppBarHomeWidget(),
              bottomNavigationBar:
                  BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
                builder: (BuildContext context, BottomNavigationState state) {
                  return FABBottomAppBarWidget(
                    color: Color(0xff606060),
                    // backgroundColor: Colors.white,
                    //selectedColor: COLOR_BACKGROUND,
                    // notchedShape: CircularNotchedRectangle(),
                    onTabSelected: (index) {
                      BlocProvider.of<BottomNavigationBloc>(context)
                          .add(TabTapped(index: index));
                      if (indexTab == index) {
                        return;
                      }
                      setState(() {
                        indexTab = index;
                      });
                      if (indexTab == 2) {
                        badgeCount = 0;
                        print('badgeCount ' + badgeCount.toString());
                        updateBadgeData(badgeCount);
                      }
                      if (indexTab == 0) {
                        BlocProvider.of<PromotionBloc>(context)
                            .add(ListPromotionFetching());
                      } else if (indexTab == 1) {
                        // BlocProvider.of<ProductCategoryBloc>(context)
                        //     .add(ListProductCategoriesFetching());
                      }
                    },
                    items: [
                      FABBottomAppBarItem(
                        icon: Image.asset(
                          ICONS_ASSETS + 'ic_km.png',
                          width: SIZE_ICON_BOTTOM_BAR,
                          height: SIZE_ICON_BOTTOM_BAR,
                        ),
                        iconActive: Image.asset(
                          ICONS_ASSETS + 'ic_km_active.png',
                          width: SIZE_ICON_BOTTOM_BAR,
                          height: SIZE_ICON_BOTTOM_BAR,
                        ),
                        text: 'Khuyến mãi',
                      ),
                      FABBottomAppBarItem(
                          icon: Image.asset(
                            ICONS_ASSETS + 'ic_product.png',
                            width: SIZE_ICON_BOTTOM_BAR,
                            height: SIZE_ICON_BOTTOM_BAR,
                          ),
                          iconActive: Image.asset(
                            ICONS_ASSETS + 'ic_product_active.png',
                            width: SIZE_ICON_BOTTOM_BAR,
                            height: SIZE_ICON_BOTTOM_BAR,
                          ),
                          text: 'Sản phẩm'),
                      FABBottomAppBarItem(
                          icon: Image.asset(
                            ICONS_ASSETS + 'ic_message.png',
                            width: SIZE_ICON_BOTTOM_BAR,
                            height: SIZE_ICON_BOTTOM_BAR,
                          ),
                          iconActive: Image.asset(
                            ICONS_ASSETS + 'ic_message_active.png',
                            width: SIZE_ICON_BOTTOM_BAR,
                            height: SIZE_ICON_BOTTOM_BAR,
                          ),
                          text: 'Nhắn tin',
                          badgeCount: 0),
                      FABBottomAppBarItem(
                          icon: Image.asset(
                            ICONS_ASSETS + 'ic_lienhe.png',
                            width: SIZE_ICON_BOTTOM_BAR,
                            height: SIZE_ICON_BOTTOM_BAR,
                          ),
                          iconActive: Image.asset(
                            ICONS_ASSETS + 'ic_lienhe_active.png',
                            width: SIZE_ICON_BOTTOM_BAR,
                            height: SIZE_ICON_BOTTOM_BAR,
                          ),
                          text: 'Liên hệ'),
                    ],
                  );
                },
              ),
              body: Stack(children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 100),
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height - 150),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          //Colors.white,// Color(0xffF8F2E3),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              //color: Color(0xffFFF1CE),//,
                              child: Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: BlocBuilder<BottomNavigationBloc,
                                    BottomNavigationState>(
                                  builder: (BuildContext context,
                                      BottomNavigationState state) {
                                    try {
                                      _scrollController.jumpTo(0);
                                    } catch (e) {
                                      print('---- LOI');
                                    }
                                    if (state is BottomNavigationInitial ||
                                        state is FirstTabLoaded) {
                                      print('PromotionPage');
                                      BlocProvider.of<PromotionBloc>(context)
                                          .add(ListPromotionFetching());
                                      return PromotionPage();
                                    }
                                    if (state is SecondTabLoaded) {
                                      print('ProductCategoryPage');
                                      return ProductsPage();
                                    }

                                    if (state is Tab3Loaded) {
                                      return MyChatPage();
                                    }

                                    if (state is Tab4Loaded) {
                                      return ViewInfoPage();
                                    }

                                    return SkeletonPahtWidget();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          child: BannerWidget(
                        scrollController: _scrollController,
                        stopScrollController: _stopScrollController,
                      )),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 80,
                    right: 0,
                    child: Visibility(
                      visible: indexTab == 3,
                      child: IconButton(
                        icon: Image.asset(
                          ICONS_ASSETS + 'icon-zalo.png',
                          //  width: 100, height: 100
                        ),
                        iconSize: 65,
                        onPressed: () {
                          UrlLauncher.launch("https://zalo.me/0865181579");
                        },
                      ),
                    )),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Visibility(
                    visible: indexTab == 3,
                    child: IconButton(
                      icon: Image.asset(
                        ICONS_ASSETS + 'ic_call_now.png',
                        //  width: 100, height: 100
                      ),
                      iconSize: 70,
                      onPressed: () {
                        UrlLauncher.launch("tel://02363812805");
                      },
                    ),
                  ),
                )
              ]),
            ),
          );
        },
      ),
    );
  }
}

class BadgeCount {
  int value;

  BadgeCount(this.value);
}
