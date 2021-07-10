import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final User user;

  const ProfileHeaderWidget({
    @required this.name,
    this.user,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        color: PRIMARY_COLOR,
        padding: EdgeInsets.all(10).copyWith(left: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BackButton(color: Colors.white),
                Expanded(
                  child: Column(mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                        user.phone !=null && user.phone.isNotEmpty ?  Text(
                      user.phone,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        //fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ):SizedBox(width: 4),
                  ]),
                ),
                user.phone !=null && user.phone.isNotEmpty ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(child: buildIcon(Icons.call),onTap: () async {
                      if(await UrlLauncher.canLaunch("tel://"+user.phone)) {
                        UrlLauncher.launch("tel://"+user.phone);
                      }
                    },),
                    //SizedBox(width: 12),
                    //buildIcon(Icons.videocam),
                  ],
                ): SizedBox(width: 0),
                SizedBox(width: 4),
              ],
            )
          ],
        ),
      );

  Widget buildIcon(IconData icon) => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          //color: Colors.white54,
        ),
        child: Icon(icon, size: 25, color: Colors.white),
      );
}
