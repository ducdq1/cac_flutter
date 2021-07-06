import 'dart:convert';

import 'package:citizen_app/core/resources/api.dart';
import 'package:citizen_app/features/chat/model/message.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../utils.dart';

class FirebaseApi {

  static Future sendMessageToAllUser(List<User> users,String message,String type, User senderUser) async {

  for(int i =0; i< users.length;i++) {
      try {
        print('send massage to ' + users[i].name);
        await uploadMessage(
            users[i].idUser, message, senderUser, type);
      }catch(e){
        print('Loi send massage to ' + users[i].name);
      }
        print('send massage thanh cong to ' + users[i].name);
    }
    await sendNotification('allCustomer','Tin nhắn từ '+ senderUser.name,message);
  }

  static Future<void> sendNotification(String to,String title,String message) async{
     http.Client client = singleton();
     try {
       var url = 'https://fcm.googleapis.com/fcm/send';
       var header = {
         "Content-Type": "application/json",
         "Authorization": "key=AAAAqfPZ1sQ:APA91bECNLIxhv2ZFNpVrNA_x33P7bK1el3jQBe3KbImmFjFxwRcM9vCsL7x6pf4Xx4rU0Nhi549sIAvsAtDS5ozHQRcZwlbT-nP-mCU1-vQbgihMXFydGMJxoLzzlGkPxotL3bm1nbY",
         "Accept-Encoding": "UTF-8"
       };
       var request = {
         "notification": {
           "title": 'Tin nhắn từ ' + title,
           "body": message,
           "sound": "default",
           //"color": "#990000",
         },
         "priority": "high",
         "to": "/topics/" + to,
       };

     //  var client = new Client();
       print('----> send noitify to: '+request.toString());
       var response =
           await client.post(url, headers: header, body: json.encode(request));
       print('----> response '+response.body.toString());
       return true;
     } catch (e, s) {
       print(e);
       return false;
     }
  }

  static Future<User> getAdminUser() async {
    String firebaseAdminUserId = pref.getString('firebaseAdminUserId');
    String firebaseAdminUserName = pref.getString('firebaseAdminUserName');
    String firebaseAdminUserAvatar = pref.getString('firebaseAdminUserAvatar');
   // if (firebaseAdminUserId == null) {
      QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("role", isEqualTo: 'admin')
          .get();
      if (documentSnapshot != null &&
          documentSnapshot.docs != null &&
          documentSnapshot.docs.length > 0) {
        User user = User.fromJson(documentSnapshot.docs.first.data());
        await pref.setString('firebaseAdminUserId', user.idUser);
        await pref.setString('firebaseAdminUserName', user.name);
        await pref.setString('firebaseAdminUserAvatar', user.urlAvatar);
        //await pref.setString('firebaseAdminUserAvatar', user.urlAvatar);
        return user;
      }
    //}
    return User(
        idUser: firebaseAdminUserId,
        name: firebaseAdminUserName,
        urlAvatar: firebaseAdminUserAvatar);
  }


  static Future<User> getUserByPhone(String phone) async {
    QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("phone", isEqualTo: phone)
        .get();
    if (documentSnapshot != null &&
        documentSnapshot.docs != null &&
        documentSnapshot.docs.length > 0) {
      User user = User.fromJson(documentSnapshot.docs.first.data());
      return user;
    }
    return null;
  }

  static Future<User> getMyUser() async {
    bool isCustomer = await pref.getBool('isCustomer');
    if (!isCustomer) {
      return getAdminUser();
    }

    String idUser = pref.getString('myFirebaseUserId');
    String name = pref.getString('myFirebaseUserFullName');
    String avartar = pref.getString('myFirebaseUserAvatar');
    if (idUser == null) {
      String phone = pref.getString('userName');
      User myUser = await FirebaseApi.getUserByPhone(phone);
      if (myUser == null) {
        String fullName = pref.getString('fullName');
        String avartarPath = pref.getString('avartarPath');

        await FirebaseApi.createUser(User(role: 'user',
            phone: phone,
            name: fullName,
            urlAvatar: avartarPath != null ? '$baseUrl' + avartarPath : ''));
        myUser = await FirebaseApi.getUserByPhone(phone);
      }
      await pref.setString('myFirebaseUserId', myUser.idUser);
      await pref.setString('myFirebaseUserFullName', myUser.name);
      await pref.setString('myFirebaseUserAvatar', myUser.urlAvatar);
      return myUser;
    }

    return User(idUser: idUser, name: name, urlAvatar: avartar);
  }

  static Future<String> getMyUserId() async {
    String myId = pref.getString('myFirebaseUserId');
    if (myId == null) {
      String phone = pref.getString('userName');
      String fullName = pref.getString('fullName');
      User myUser = await getUserByPhone(phone);
      String avartarPath = pref.getString('avartarPath');
      if (myUser == null) {
        await FirebaseApi.createUser(User(
            role: 'user',
            phone: phone,
            name: fullName,
            urlAvatar: '$baseUrl' + avartarPath));
        myUser = await FirebaseApi.getUserByPhone(phone);
        await pref.setString('myFirebaseUserId', myUser.idUser);
        await pref.setString('myFirebaseUserFullName', myUser.name);
        myId = myUser.idUser;
      }
    }
    return myId;
  }

  static Stream<List<User>> getUsers() => FirebaseFirestore.instance
      .collection('users')
      //.where("idUser", whereNotIn: [myId])
      .where("role", whereNotIn: ['admin'])
      .orderBy("role")

      ///.orderBy(UserField.lastMessageTime, descending: true) Z?Xz/zx ,
      .snapshots()
      .transform(Utils.transformer(User.fromJson));

  static Future uploadMessage(
      String idUser, String message, User myUser,String type) async {
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');

    final newMessage = Message(
      idUser: myUser.idUser,
      urlAvatar: myUser.urlAvatar,
      username: myUser.name,
      message: message,
      createdAt: DateTime.now(),
      type: type
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('users');
    await refUsers
        .doc(idUser)
        .update({UserField.lastMessageTime: DateTime.now()});
  }



  static Stream<List<Message>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static Future addRandomUsers(List<User> users) async {
    final refUsers = FirebaseFirestore.instance.collection('users');

    final allUsers = await refUsers.get();
    for (final user in users) {
      print(user.idUser);
    }
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(idUser: userDoc.id);

        await userDoc.set(newUser.toJson());
        return;
      }
    }
  }

  static Future createUser(User user) async {
    final refUsers = FirebaseFirestore.instance.collection('users');
    final userDoc = refUsers.doc();
    final newUser = user.copyWith(idUser: userDoc.id);
    await userDoc.set(newUser.toJson());
  }
}
