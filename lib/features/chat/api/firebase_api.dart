import 'dart:convert';

import 'package:citizen_app/core/resources/api.dart';
import 'package:citizen_app/features/chat/model/message.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../utils.dart';

class FirebaseApi {
  static Future sendMessageToAllUser(
      String message, String type, User senderUser, Function callback) async {
    List<User> users = await getAllUsers().first;
    for (int i = 0; i < users.length; i++) {
      try {
        print('send massage to ' + users[i].name);
        callback((i + 1).toString() + '/' + users.length.toString());
        await uploadMessage(users[i].idUser, message, senderUser, type);
      } catch (e) {
        print('Loi send massage to ' + users[i].name);
      }
      print('send massage thanh cong to ' + users[i].name);
    }
    await sendNotification(
        'allCustomer', 'Tin nhắn từ ' + senderUser.name, message);
  }

  static Future<void> sendNotification(
      String to, String title, String message) async {
    http.Client client = singleton();
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAwBq6_qY:APA91bFM1k5zlGkyJ9oWUp6JyFqXNUz9QG3U4FvP5egddF24w9Nvs5xUwyJguQWTvjCSs1SASRZwhpeZd4SyYiedC-WZGXDYY10_AxyVd9rcxRNYYvjyCIe4-6XMvs4yW0foL4zY9QPd",
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
      print('----> send noitify to: ' + request.toString());
      var response =
          await client.post(url, headers: header, body: json.encode(request));
      print('----> response ' + response.body.toString());
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
    if (firebaseAdminUserId == null) {
      QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("role", isEqualTo: 'admin')
          .get();
      if (documentSnapshot != null &&
          documentSnapshot.docs != null &&
          documentSnapshot.docs.isNotEmpty) {
        User user = User.fromJson(documentSnapshot.docs.first.data());
        await pref.setString('firebaseAdminUserId', user.idUser);
        await pref.setString('firebaseAdminUserName', user.name);
        await pref.setString('firebaseAdminUserAvatar', user.urlAvatar);
        //await pref.setString('firebaseAdminUserAvatar', user.urlAvatar);
        return user;
      }
    }
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
    String role = pref.getString('myFirebaseUserRole');
    String phone = pref.getString('myFirebaseUserPhone');
    if (idUser == null) {
      String phone = pref.getString('userName');
      User myUser = await FirebaseApi.getUserByPhone(phone);
      if (myUser == null) {
        String fullName = pref.getString('fullName');
        String avartarPath = pref.getString('avartarPath');
        await FirebaseApi.createUser(User(
            role: 'user',
            phone: phone,
            name: fullName,
            urlAvatar: avartarPath != null ? '$baseUrl' + avartarPath : '',
            status: 'online',
            processor: 'null'));
        myUser = await FirebaseApi.getUserByPhone(phone);
      } else {
        updateUserStatus(idUser, "online");
      }
      await pref.setString('myFirebaseUserId', myUser.idUser);
      await pref.setString('myFirebaseUserFullName', myUser.name);
      await pref.setString('myFirebaseUserAvatar', myUser.urlAvatar);
      await pref.setString('myFirebaseUserRole', myUser.role);
      await pref.setString('myFirebaseUserPhone', myUser.phone);

      return myUser;
    }

    updateUserStatus(idUser, "online");

    return User(
        idUser: idUser,
        name: name,
        urlAvatar: avartar,
        role: role,
        phone: phone);
  }

  static updateUserStatus(String userId, String status) async {
    try {
      final refUsers = FirebaseFirestore.instance.collection('users');
      refUsers
          .doc(userId)
          .update({"lastOnlineTime": DateTime.now(), "status": status});
    } catch (e) {}
  }

  //Cap nhat lai user sẽ xu ly
  static updateUserProcessor(String userId, String processor) async {
    try {
      final refUsers = FirebaseFirestore.instance.collection('users');
      refUsers.doc(userId).update({"processor": processor});
    } catch (e) {}
  }

  static updateUserMessageHasRead(String userId,bool hasRead) async {
    try {
      final refUsers = FirebaseFirestore.instance.collection('users');
      refUsers.doc(userId).update({"messageHasRead": hasRead});
    } catch (e) {}
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
            urlAvatar: '$baseUrl' + avartarPath,
            processor: 'null'));
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
      //    .where("role", whereNotIn: ['admin']).
      .where("processor", whereIn: ['null',  pref.getString("userName")])
      //.orderBy("role",descending:  false)
      //.orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(User.fromJson));

  static Stream<List<User>> getAllUsers() => FirebaseFirestore.instance
      .collection('users')
  //.where("idUser", whereNotIn: [myId])
    .where("role", whereNotIn: ['admin'])
   //   .where("processor", whereIn: ['null',  pref.getString("userName")])
   .orderBy("role",descending:  false)
  //.orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(User.fromJson));

  static Future uploadMessage(
      String idUser, String message, User myUser, String type) async {
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');
    final msgDoc = refMessages.doc();
    final newMessage = Message(
          idMsg: msgDoc.id,
        idUser: myUser.idUser,
        urlAvatar: myUser.urlAvatar,
        username: myUser.name,
        message: message,
        createdAt: DateTime.now(),
        type: type);
    await msgDoc.set(newMessage.toJson());
  }

  static Stream<List<Message>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static Future<bool> checkHasMessage(String idUser, User myUser) async {
    final refUsers =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');
    final messages = await refUsers.get();
    if (messages.size == 0) {
      uploadMessage(idUser, 'Xin chào...', myUser, '0');
      return true;
    }
    return false;
  }

  static updateCustomerMessageHasRead(String userId,String idMessage) async {
    try {
      final refUsers =  FirebaseFirestore.instance
          .collection('chats/$userId/messages');
      refUsers.doc(idMessage).update({"hasRead": true});
    } catch (e) {}
  }

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
