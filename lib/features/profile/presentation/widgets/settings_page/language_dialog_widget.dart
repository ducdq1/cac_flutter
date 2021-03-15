import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum LanguageSetting { vi, en }

class LanguageDialogWidget extends StatefulWidget {
  final Function func;
  final String languagePicked;

  LanguageDialogWidget({Key key, this.languagePicked, this.func})
      : super(key: key);

  @override
  _LanguageDialogWidgetState createState() => _LanguageDialogWidgetState();
}

class _LanguageDialogWidgetState extends State<LanguageDialogWidget>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  String _character;

  @override
  void initState() {
    super.initState();
    setState(() {
      _character = widget.languagePicked;
    });
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
              SizedBox(height: 10),
              Center(
                child: Text(
                  trans(LANGUAGE),
                  style: GoogleFonts.roboto(
                    fontSize: FONT_MIDDLE,
                    color: PRIMARY_TEXT_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 5),
              Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    child: ListTile(
                      title: Text(trans(VIETNAMESE)),
                      leading: Radio(
                        value: "vi",
                        activeColor: PRIMARY_COLOR,
                        groupValue: _character,
                        onChanged: (String value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: ListTile(
                      title: Text(trans(ENGLISH)),
                      leading: Radio(
                        value: "en",
                        activeColor: PRIMARY_COLOR,
                        groupValue: _character,
                        onChanged: (String value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
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
                        trans(IGNORE),
                        style: GoogleFonts.roboto(
                          color: PRIMARY_COLOR,
                          fontSize: FONT_EX_SMALL,
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      widget.func(_character);
                    },
                    elevation: 0,
                    color: PRIMARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: PRIMARY_COLOR),
                    ),
                    child: Center(
                      child: Text(
                        trans(AGREE),
                        style: GoogleFonts.roboto(
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
}
