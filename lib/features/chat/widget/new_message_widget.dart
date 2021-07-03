import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/features/chat/api/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NewMessageWidget extends StatefulWidget {
  final String idUser;
  final myUser;

  const NewMessageWidget({
    @required this.idUser,
    this.myUser,
    Key key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';

  void sendMessage() async {
    print('sendMessage');
    FocusScope.of(context).unfocus();
    if(!_controller.text.isEmpty) {
      await FirebaseApi.uploadMessage(
          widget.idUser, _controller.text.trim(), widget.myUser);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Color(0xffF3F6FB),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.image,
              color: Colors.blue,
              size: 32,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 40,
                child: TextFormField(
                    onTap: () {},
                    controller: _controller,
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: FONT_SMALL,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: FONT_SMALL,
                          fontWeight: FontWeight.w100),
                      hintText: 'Nhập nội dung',
                      focusColor: Color(0xffa0b9de),
                      filled: true,
                      fillColor: Color(0xffa0b9de),
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      labelStyle: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: FONT_SMALL,
                          fontWeight: FontWeight.w600),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(36.0),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.25), width: 0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26.0),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.25), width: 0)),
                    )),
              ),
            ),
            // Expanded(
            //   child: TextField(
            //     controller: _controller,
            //     textCapitalization: TextCapitalization.sentences,
            //     autocorrect: true,
            //     enableSuggestions: true,
            //
            //     onChanged: (value) => setState(() {
            //       message = value;
            //     }),
            //   ),
            // ),
            SizedBox(width: 10),
            InkWell(
              onTap:  sendMessage,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      );
}
