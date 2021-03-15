import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/home/data/models/models.dart';
import 'package:citizen_app/features/home/presentation/pages/web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:google_fonts/google_fonts.dart';

class CitizensMenuFooterItemWidget extends StatefulWidget {
  final AppFooterModel menuItem;

  CitizensMenuFooterItemWidget({this.menuItem});
  @override
  _CitizensMenuFooterItemWidgetState createState() =>
      _CitizensMenuFooterItemWidgetState();
}

class _CitizensMenuFooterItemWidgetState
    extends State<CitizensMenuFooterItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewPage(
                  title: widget.menuItem.name, link: widget.menuItem.link)),
        );
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 70) / 3,
        height: 150,
        decoration: BoxDecoration(
          color: Color(0xffE6EFF3).withOpacity(0.6),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
              child: Image.network(
                widget.menuItem.image,
                width: (MediaQuery.of(context).size.width - 70) / 3,
                height: 150,
                fit: BoxFit.fill,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Container(
                      color: Color(0xffE6EFF3).withOpacity(0.6),
                      width: (MediaQuery.of(context).size.width - 70) / 3,
                      height: 150,
                      child: Center(
                          child: Text(
                        '',
                        style: TextStyle(color: Colors.white),
                      )));
                },
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Color(0xffE6EFF3).withOpacity(0.6),
                    width: (MediaQuery.of(context).size.width - 70) / 3,
                    height: 150,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    PRIMARY_COLOR),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              )),
                        )),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 17.0, left: 10, right: 10),
                child: Text(
                  widget.menuItem.name.titleCase,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: FONT_SMALL *
                          MediaQuery.of(context).size.height *
                          0.001,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
