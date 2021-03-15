import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future showDeleteConfirmDialog(
    {BuildContext context, Function onSubmit, Bloc bloc}) async {
  return await showDialog(
      context: context,
      builder: (_) {
        return bloc != null
            ? BlocProvider.value(
                value: bloc,
                child: DeleteConfirmDialog(onSubmit: onSubmit),
              )
            : DeleteConfirmDialog(
                onSubmit: onSubmit,
              );
      });
}

class DeleteConfirmDialog extends StatefulWidget {
  final Function onSubmit;

  DeleteConfirmDialog({this.onSubmit});

  @override
  _DeleteConfirmDialogState createState() => _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends State<DeleteConfirmDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        margin: EdgeInsets.symmetric(horizontal: 17),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                trans(CONFIRM_DELETE_INFO),
                style: GoogleFonts.inter(
                  fontSize: FONT_MIDDLE,
                  color: PRIMARY_TEXT_COLOR,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            RaisedButton(
              onPressed: widget.onSubmit,
              elevation: 0,
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Center(
                child: Text(
                  trans(TEXT_DELETE_BUTTON),
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: FONT_MIDDLE,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: PRIMARY_COLOR),
              ),
              child: Center(
                child: Text(
                  trans(TEXT_CANCEL_CREATE_BUTTON),
                  style: GoogleFonts.inter(
                      color: PRIMARY_COLOR,
                      fontSize: FONT_MIDDLE,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
