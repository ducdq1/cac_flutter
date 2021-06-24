import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/customer/data/models/product_category_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const DESCRIPTION_COLOR = Color(0xff353739);

class ProductCategoryItemWidget extends StatelessWidget {
  final ProductCategoryModel model;
  final Function onTap;

  ProductCategoryItemWidget({@required this.model, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _itemWidget(context);
  }

  Widget _itemWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 5),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      //color: Color(0xff82C341), //Colors.green.withOpacity(0.8),
                      //borderRadius: BorderRadius.all(Radius.circular(6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(3, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                model.imageUrl,
                                width: (MediaQuery.of(context).size.width - 70) / 3,
                                //height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception,
                                    StackTrace stackTrace) {
                                  return Image.asset(IMAGE_ASSETS_PATH + 'banner_old.png');
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
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0, top: 10),
                                      child: Row(children: [
                                        Image.asset(
                                          ICONS_ASSETS + 'icon_112.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            model.name == null ? '' : model.name,
                                            style: GoogleFonts.inter(
                                              fontSize: FONT_MIDDLE,
                                              color: DESCRIPTION_COLOR,
                                              //Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              model.description == null
                                                  ? ''
                                                  : model.description,
                                              style: GoogleFonts.inter(
                                                  color: DESCRIPTION_COLOR,
                                                  fontSize: FONT_MIDDLE,
                                                  height: 1.5),
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  IMAGE_ASSETS_PATH + 'km31.png',
                  height: 35,
                ))
          ]),
        ),
      ),
    );
  }
}
