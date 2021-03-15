import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/resources/values.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/presentation/pages/business_hour_page.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/input_open_time_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessHourEditPage extends StatefulWidget {
  final ScrollController scrollController = ScrollController();

  @override
  _BusinessHourEditPageState createState() => _BusinessHourEditPageState();
}

class _BusinessHourEditPageState extends State<BusinessHourEditPage>
    implements OnInputAddressClickListener, OnButtonClickListener {
  List<BusinessHourEntity> BUSINESS_HOUR = [];
  BusinessHourArgument args;
  List<int> listDayChoosed = [];
  bool _isOpenHourChecked = false;
  bool _isCloseHourChecked = false;
  TextEditingController _openTimeController;
  TextEditingController _closeTimeController;
  TimeOfDay openTimeSelected;
  TimeOfDay closeTimeSelected;
  String errorMessage = null;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(false);
  bool isCreatePage = true;

  @override
  void initState() {
    _openTimeController = new TextEditingController();
    _closeTimeController = new TextEditingController();
    super.initState();
  }

  initValue(BusinessHourArgument args) async {
    if (args != null) {
      BUSINESS_HOUR = args.businessHour;
      listDayChoosed.add(args.dayEdit);
      for (int i = 0; i < BUSINESS_HOUR.length; i++) {
        if (args.dayEdit == BUSINESS_HOUR[i].day) {
          switch (BUSINESS_HOUR[i].status) {
            case CLOSE_STATUS:
              setState(() {
                _isCloseHourChecked = true;
                _isOpenHourChecked = false;
                _isVisible.value = false;
              });
              break;
            case OPEN_ALL_DAY_STATUS:
              setState(() {
                _isOpenHourChecked = true;
                _isCloseHourChecked = false;
                _isVisible.value = false;
              });
              break;
            case OPEN_TIME_STATUS:
              setState(() {
                _isVisible.value = true;
                openTimeSelected =
                    getTimeOfDayFroData(BUSINESS_HOUR[i].openTime);
                closeTimeSelected =
                    getTimeOfDayFroData(BUSINESS_HOUR[i].closeTime);
                if (!_isCloseHourChecked && !_isOpenHourChecked) {
                  _openTimeController.text =
                      openTimeSelected.format(context).toString();
                  _closeTimeController.text =
                      closeTimeSelected.format(context).toString();
                }
              });
              break;
          }
        }
      }
    }

    if (openTimeSelected == null) {
      openTimeSelected = TimeOfDay(hour: 07, minute: 00);
    }

    if (closeTimeSelected == null) {
      closeTimeSelected = TimeOfDay(hour: 23, minute: 59);
    }
  }

  TimeOfDay getTimeOfDayFroData(String data) {
    try {
      return TimeOfDay(
          hour: int.parse(data.split(":")[0]),
          minute: int.parse(data.split(":")[1]));
    } catch (error) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (isCreatePage) {
      isCreatePage = false;
      args = ModalRoute.of(context).settings.arguments as BusinessHourArgument;
      initValue(args);
    }

    return Center(
      child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10.0),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Text(trans(LABEL_CHOOSE_DATE),
                    style: GoogleFonts.inter(
                      fontSize: FONT_MIDDLE,
                      color: PRIMARY_TEXT_COLOR,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 30),
                daysWidget(),
                SizedBox(height: 20),
                openTimeStatusWidget(),
                SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: _isVisible,
                  child: openTimeWidget(),
                  builder: (BuildContext context, dynamic value, Widget child) {
                    return value ? child : SizedBox();
                  },
                ),
                Visibility(
                  child: Text(
                    errorMessage == null ? '' : errorMessage,
                    style: GoogleFonts.inter(
                      fontSize: FONT_SMALL,
                      color: Colors.red,
                    ),
                  ),
                  visible: errorMessage == null ? false : true,
                ),
                SizedBox(height: 20),
                setOperationTimeAction()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget daysWidget() {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < BUSINESS_HOUR.length; i++)
              Row(children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (listDayChoosed.contains(i)) {
                        if (listDayChoosed.length > 1) {
                          listDayChoosed.remove(i);
                        }
                      } else {
                        listDayChoosed.add(i);
                      }
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 0.3,
                              color: listDayChoosed.contains(i)
                                  ? PRIMARY_COLOR.withOpacity(0.5)
                                  : PRIMARY_TEXT_COLOR.withOpacity(0.5)),
                          color: listDayChoosed.contains(i)
                              ? PRIMARY_COLOR.withOpacity(0.04)
                              : Colors.white),
                      child: Center(
                          child: Text(getDayShortName(i),
                              style: TextStyle(
                                  color: listDayChoosed.contains(i)
                                      ? PRIMARY_COLOR
                                      : PRIMARY_TEXT_COLOR)))),
                ),
              ]),
          ]),
    );
  }

  Widget openTimeStatusWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            child: FlatButton(
                // here toggle the bool value so that when you click
                // on the whole item, it will reflect changes in Checkbox
                onPressed: () => setState(() {
                      _isOpenHourChecked = !_isOpenHourChecked;
                      if (_isOpenHourChecked && _isCloseHourChecked) {
                        _isCloseHourChecked = !_isOpenHourChecked;
                      }

                      if (!_isOpenHourChecked && !_isCloseHourChecked) {
                        _isVisible.value = true;
                      } else {
                        _isVisible.value = false;
                      }
                    }),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Checkbox(
                          activeColor: PRIMARY_COLOR,
                          value: _isOpenHourChecked,
                          onChanged: (value) {
                            setState(() {
                              _isOpenHourChecked = value;
                              if (_isOpenHourChecked && _isCloseHourChecked) {
                                _isCloseHourChecked = !_isOpenHourChecked;
                              }

                              if (!_isOpenHourChecked && !_isCloseHourChecked) {
                                _isVisible.value = true;
                              } else {
                                _isVisible.value = false;
                              }
                            });
                          })),
                  // You can play with the width to adjust your
                  // desired spacing
                  SizedBox(width: 10.0),
                  Text(trans(LABEL_OPEN_24H))
                ])),
          ),
        ),
        Expanded(
          child: Container(
            child: FlatButton(
                // here toggle the bool value so that when you click
                // on the whole item, it will reflect changes in Checkbox
                onPressed: () => setState(() {
                      _isCloseHourChecked = !_isCloseHourChecked;
                      if (_isOpenHourChecked && _isCloseHourChecked) {
                        _isOpenHourChecked = !_isCloseHourChecked;
                      }

                      if (!_isOpenHourChecked && !_isCloseHourChecked) {
                        _isVisible.value = true;
                      } else {
                        _isVisible.value = false;
                      }
                    }),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Checkbox(
                          activeColor: PRIMARY_COLOR,
                          value: _isCloseHourChecked,
                          onChanged: (value) {
                            setState(() {
                              _isCloseHourChecked = value;
                              if (_isOpenHourChecked && _isCloseHourChecked) {
                                _isOpenHourChecked = !_isCloseHourChecked;
                              }

                              if (!_isOpenHourChecked && !_isCloseHourChecked) {
                                _isVisible.value = true;
                              } else {
                                _isVisible.value = false;
                              }
                            });
                          })),
                  // You can play with the width to adjust your
                  // desired spacing
                  SizedBox(width: 10.0),
                  Text(trans(LABEL_CLOSED))
                ])),
          ),
        ),
      ],
    );
  }

  Widget openTimeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 140,
              child: InputOpenTimeWidget(
                  controller: _openTimeController,
                  label: trans(LABEL_OPEN_TIME),
                  defaultValue: '07:00',
                  isRequired: false,
                  validates: [
                    EmptyValidate(),
                  ],
                  ctx: this,
                  id: "openTime",
                  focusError: (FocusNode focusNode) {}),
            ),
          ]),
        ),
        Expanded(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 140,
              child: InputOpenTimeWidget(
                controller: _closeTimeController,
                label: trans(LABEL_CLOSE_TIME),
                defaultValue: '23:59',
                isRequired: false,
                validates: [
                  EmptyValidate(),
                ],
                ctx: this,
                id: "closeTime",
              ),
            ),
          ]),
        )
      ],
    );
  }

  Widget setOperationTimeAction() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 142,
            child: OutlineCustomButton(
              label: trans(TEXT_CANCEL_CREATE_BUTTON),
              ctx: this,
              id: 'cancel_btn',
            ),
          ),
          Container(
            width: 142,
            child: PrimaryButton(
                label: trans(TEXT_CREATE_ISSUE_BUTTON),
                ctx: this,
                id: 'primary_btn'),
          )
        ],
      ),
    );
  }

  void selectTime(TextEditingController controller, TimeOfDay timeSelected,
      String id) async {
    setState(() {
      errorMessage = null;
    });

    if (timeSelected == null) {
      timeSelected = TimeOfDay.now();
    }
    timeSelected =
        await showTimePicker(context: context, initialTime: timeSelected);
    setState(() {
      controller.text = timeSelected.format(context).toString();
      if (id.compareTo("openTime") == 0) {
        openTimeSelected = timeSelected;
      } else if (id.compareTo("closeTime") == 0) {
        closeTimeSelected = timeSelected;
      }
    });
  }

  void saveData() {
    for (int i = 0; i < listDayChoosed.length; i++) {
      int daySelected = listDayChoosed[i];
      for (int j = 0; j < BUSINESS_HOUR.length; j++) {
        if (daySelected == BUSINESS_HOUR[j].day) {
          if (_isOpenHourChecked) {
            BUSINESS_HOUR[j].status = OPEN_ALL_DAY_STATUS;
          } else if (_isCloseHourChecked) {
            BUSINESS_HOUR[j].status = CLOSE_STATUS;
          } else {
            BUSINESS_HOUR[j].status = OPEN_TIME_STATUS;
            BUSINESS_HOUR[j].openTime =
                openTimeSelected.format(context).toString();
            BUSINESS_HOUR[j].closeTime =
                closeTimeSelected.format(context).toString();
          }
        }
      }
    }
  }

  String validateOpenTimeData() {
    if (!_isOpenHourChecked && !_isCloseHourChecked) {
      String errorMessage = trans(LABEL_CLOSE_TIME_INVALID);
      if (closeTimeSelected.hour < openTimeSelected.hour) {
        return errorMessage;
      } else if ((closeTimeSelected.hour == openTimeSelected.hour) &&
          (closeTimeSelected.minute < openTimeSelected.minute)) {
        return errorMessage;
      }
    }

    return null;
  }

  @override
  onClick(String id) {
    switch (id) {
      case "primary_btn":
        setState(() {
          errorMessage = validateOpenTimeData();
          if (errorMessage != null) {
            return;
          } else {
            saveData();
            Navigator.pop(context, BUSINESS_HOUR);
          }
        });

        break;

      case "cancel_btn":
        Navigator.of(context).pop();
        break;

      case "openTime":
        selectTime(_openTimeController, openTimeSelected, id);
        break;
      case "closeTime":
        selectTime(_closeTimeController, closeTimeSelected, id);
        break;
      default:
        break;
    }
  }
}
