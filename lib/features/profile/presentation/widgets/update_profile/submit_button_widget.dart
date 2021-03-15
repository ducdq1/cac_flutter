import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class SubmitButtonWidget extends StatefulWidget {
  final Function validate;
  final Function invalidate;
  final GlobalKey<FormState> formKey;

  SubmitButtonWidget({this.formKey, this.invalidate, this.validate});
  @override
  _SubmitButtonWidgetState createState() => _SubmitButtonWidgetState();
}

class _SubmitButtonWidgetState extends State<SubmitButtonWidget>
    implements OnButtonClickListener {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 38),
      child: PrimaryButton(label: trans(UPDATE), ctx: this),
    );
  }

  @override
  onClick(String id) {
    if (widget.formKey.currentState.validate()) {
      widget.validate();
    } else {
      widget.invalidate();
    }
  }
}
