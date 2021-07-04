import 'dart:io' as io;
import 'dart:math' as math;

import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/chat/api/firebase_api.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../injection_container.dart';

class NewMessageWidget extends StatefulWidget {
  final String idUser;
  final User myUser;
  final User toUser;

  const NewMessageWidget({
    @required this.idUser,
    this.myUser,
    this.toUser,
    Key key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  String message = '';
  var controller;
  var pref = singleton<SharedPreferences>();
  io.File imageFile;
  bool isLoading = false;

  void sendMessage() async {
    print('sendMessage');
    FocusScope.of(context).unfocus();
    if (_controller.text.isNotEmpty) {
      String message = _controller.text.trim();
      await FirebaseApi.uploadMessage(
          widget.idUser, message, widget.myUser, '0');
      _controller.clear();
      sendNotification(message);
    }
  }

  Future sendNotification(String message) async{
    String topic;
    var isCustomer = pref.getBool('isCustomer') ?? false;
    if (isCustomer) {
      topic = 'customer';
    } else {
      topic = widget.toUser.phone;
    }
    await FirebaseApi.sendNotification(
        topic, widget.myUser.name, message);
  }

  Future uploadFile() async {
    if (imageFile == null) {
      return null;
    }
    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);

    try {
      TaskSnapshot snapshot = await uploadTask;
      var imageUrl = await snapshot.ref.getDownloadURL();
      FirebaseApi.uploadMessage(
          widget.idUser, imageUrl, widget.myUser, '1');
      sendNotification('Hình ảnh');
      setState(() {
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future getImage() async {
    io.File pickedFile = await ImagePicker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = pickedFile;
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
    }
  }

  @override
  void initState() {
    //controller = AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Container(
        decoration: BoxDecoration(
          color: Color(0xffF3F6FB),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: getImage,
              child:
              SvgPicture.asset(
                SVG_ASSETS_PATH + 'icon_image_pick.svg',
                color: Colors.blue,
                height: 28,
                width: 28,
              ),
            ),
              SizedBox(
              width: isLoading ? 10 : 0,
            ) , isLoading ?   Container(padding: EdgeInsets.all(00),
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 1,))  :
            SizedBox(),
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
                        ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: FONT_SMALL,
                          ),
                      hintText: 'Nhập nội dung...',
                      focusColor: Colors.blue,
                      filled: true,
                      fillColor: Colors.blue,
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
              onTap: sendMessage,
              child: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: Transform.rotate(
                  angle: 325 * math.pi / 180,
                  child: Icon(
                    Icons.send,
                    // icon: AnimatedIcons.arrow_menu,
                    // progress: controller,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
