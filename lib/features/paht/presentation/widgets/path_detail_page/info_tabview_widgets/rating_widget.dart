import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingWidget extends StatefulWidget {
  final int rating;
  RatingWidget({this.rating});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, top: 26, right: 24, bottom: 21),
      decoration: BoxDecoration(
          color: Color.fromARGB(153, 250, 245, 232),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trans(EVALUATION),
            style: GoogleFonts.inter(
              color: PRIMARY_TEXT_COLOR,
              fontSize: FONT_MIDDLE,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            trans(HAVE_EVALUATED),
            style: GoogleFonts.inter(
              color: PRIMARY_TEXT_COLOR,
              fontSize: FONT_MIDDLE,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 14),
          Row(
            children: [
              SvgPicture.asset(
                SVG_ASSETS_PATH + 'icon_clock.svg',
              ),
              SizedBox(width: 9),
              Text(
                '12:00, 24/11/2019'.toUpperCase(),
                style: GoogleFonts.inter(
                  color: PRIMARY_TEXT_COLOR,
                  fontSize: FONT_MIDDLE,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: RatingBar.builder(
              initialRating: widget.rating ?? 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 142,
              child: PrimaryButton(
                label: ACT_SUBMIT_EVALUATION,
                ctx: this,
                id: 'location_btn',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
