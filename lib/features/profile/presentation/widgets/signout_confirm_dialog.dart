import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_event.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_bloc.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_event.dart';
import 'package:citizen_app/features/profile/presentation/widgets/loader_dialog.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutConfirmDialog extends StatefulWidget {
  @override
  _SignOutConfirmDialogState createState() => _SignOutConfirmDialogState();
}

class _SignOutConfirmDialogState extends State<SignOutConfirmDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20.0),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Icon(
                  Icons.report_outlined,
                  color: Colors.orangeAccent,
                  size: 30,
                ),
              ),
              SizedBox(height: 20),
              Text(
                trans(TEXT_ALERT_CONFIRM_LOGOUT),
                style: GoogleFonts.inter(
                  fontSize: FONT_MIDDLE,
                  color: PRIMARY_TEXT_COLOR,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: PRIMARY_COLOR),
                    ),
                    child: Center(
                      child: Text(
                        trans(CANCEL),
                        style: GoogleFonts.inter(
                          color: PRIMARY_COLOR,
                          fontSize: FONT_EX_SMALL,
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      try{
                        showLoaderDialog(context);
                        final pref = singleton<SharedPreferences>();
                        await unsubscribe(getUserName());
                        await unsubscribe('create');
                        await unsubscribe('allCustomer');
                        await unsubscribe('customer');
                        if(pref.getString('myFirebaseUserId') !=null ) {
                          await FirebaseFirestore.instance.collection('users')
                              .doc(pref.getString('myFirebaseUserId'))
                              .update({"lastOnlineTime": DateTime.now(),
                            "status": "offline"});
                        }
                      }catch(e){
                        print('-------------------- Loi day');
                      }


                      await Future.delayed(Duration(milliseconds: 200));
                      BlocProvider.of<AuthBloc>(context)
                          .add(UnAuthenticatedEvent());
                      // BlocProvider.of<SignInBloc>(context)
                      //     .add(SignInClearEvent());


                      Navigator.of(context).pushNamedAndRemoveUntil(
                          ROUTER_SIGNIN, (Route<dynamic> route) => false);
                    },
                    elevation: 0,
                    color: PRIMARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: PRIMARY_COLOR),
                    ),
                    child: Center(
                      child: Text(
                        trans(TITLE_LOGOUT),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: FONT_EX_SMALL,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future unsubscribe(String value) async {
    try{
      if(value== null){
        return null;
      }
      await FirebaseMessaging().unsubscribeFromTopic(value);
    }catch(e){
      print('-------------------- Loi day');
    }
  }
}
