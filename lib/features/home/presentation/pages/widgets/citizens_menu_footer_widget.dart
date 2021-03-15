import 'package:citizen_app/features/home/data/models/models.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/citizens_menu_footer_item_widget.dart';
import 'package:flutter/material.dart';

class CitizensMenuFooterWidget extends StatefulWidget {
  final List<AppFooterModel> menu;

  CitizensMenuFooterWidget({Key key, this.menu}) : super(key: key);

  @override
  _CitizensMenuFooterWidgetState createState() =>
      _CitizensMenuFooterWidgetState();
}

class _CitizensMenuFooterWidgetState extends State<CitizensMenuFooterWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 150, top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('Dịch vụ tích hợp'.toUpperCase(),
          //     style:
          //         TextStyle(fontSize: FONT_SMALL, fontWeight: FontWeight.w700)),
          // SizedBox(height: 26),
          Wrap(
            direction: Axis.horizontal,
            spacing: 18.0,
            runSpacing: 20.0,
            children: widget.menu
                .asMap()
                .map((i, element) => MapEntry(
                      i,
                      CitizensMenuFooterItemWidget(
                        menuItem: widget.menu[i],
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
