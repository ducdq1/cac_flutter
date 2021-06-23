import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'required_label_widget.dart';

class RadioData<T> {
  String label;
  T value;

  RadioData({this.label, this.value});
}

class GroupRadioWidget<T> extends StatefulWidget {
  final T defaultValue;
  final bool isRequired;
  final String label;
  final Function onChoice;
  final List<RadioData<T>> radios;

  GroupRadioWidget({
    @required this.label,
    @required this.radios,
    this.onChoice,
    this.defaultValue,
    this.isRequired = true,
  });
  @override
  _GroupRadioWidgetState createState() => _GroupRadioWidgetState<T>();
}

class _GroupRadioWidgetState<T> extends State<GroupRadioWidget> {
  T _radioSelected;

  @override
  void initState() {
    _radioSelected = widget.defaultValue ?? widget.radios.first.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        child: Column(
          children: [
            RequiredLabelWidget(
              label: widget.label,
              isRequired: widget.isRequired,
            ),
            SizedBox(height: 6),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.radios.map((item) {
                return Container(
                  margin: EdgeInsets.only(top: 6),
                  child: LabeledRadio<T>(
                    label: '${item.label}',
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    value: item.value,
                    groupValue: _radioSelected,
                    onChanged: (T newValue) {
                      setState(() {
                        _radioSelected = newValue;
                      });
                      widget.onChoice(_radioSelected);
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class LabeledRadio<T> extends StatelessWidget {
  const LabeledRadio({
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final T groupValue;
  final T value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) onChanged(value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(
                unselectedWidgetColor: BORDER_COLOR,
              ),
              child: Container(
                width: 24,
                height: 24,
              ),
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: FONT_MIDDLE,
                color: PRIMARY_TEXT_COLOR,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
