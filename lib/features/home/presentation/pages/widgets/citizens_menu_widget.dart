import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/home/data/models/models.dart';
import 'package:citizen_app/features/home/presentation/pages/web_view_page.dart';
import 'package:flutter/material.dart';

import 'citizens_menu_item_widget.dart';

class CitizensMenuWidget extends StatefulWidget {
  final List<AppServiceModel> menu;

  CitizensMenuWidget({this.menu});
  @override
  _CitizensMenuWidgetState createState() => _CitizensMenuWidgetState();
}

class _CitizensMenuWidgetState extends State<CitizensMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 58, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text('Dịch vụ chính'.toUpperCase(),
          //     style:
          //         TextStyle(fontSize: FONT_SMALL, fontWeight: FontWeight.w700)),
          SizedBox(height: 22),
           Wrap(
              direction: Axis.horizontal,
              spacing: 32.0,
              runSpacing: 16.0,
              // mainAxisSpacing: 12,
              // crossAxisSpacing: 32,
              // crossAxisCount: 3,
              // childAspectRatio: 3 / 6,
              children: widget.menu
                  .asMap()
                  .map((i, element) => MapEntry(
                        i,
                        CitizensMenuItemWidget(
                          label: widget.menu[i].name,
                          icon: widget.menu[i].icon,
                          needRedirect: widget.menu[i].needRedirect,
                          onPress: () {
                            print(widget.menu[i].serviceType);
                              Navigator.pushNamed(
                                  context, '/${widget.menu[i].serviceType}');

                          },
                        ),
                      ))
                  .values
                  .toList(),
            ),

        ],
      ),
    );
  }
}
