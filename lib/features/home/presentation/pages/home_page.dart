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

import '../../../../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// Completer<void> _refreshCompleter;

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final StopScrollController _stopScrollController = StopScrollController();
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
  void initState() {
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

    var _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

      },
    );

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
