import 'dart:convert';
import 'dart:io' show Platform;

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/phone_validate.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/text_field_custom.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/paht/data/models/media_from_server.dart';
import 'package:citizen_app/features/paht/data/models/media_picker_ios_model.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_issue_paht.dart';
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_issue_bloc/create_issue_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/poi_type_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'business_hour_page.dart';

const SIZE_ICON = 20.0;
const SIZE_PICKER_LOCATION_ICON = 36.0;
const SIZE_CAMERA_ICON = 36.0;
const Color ADDRESS_FIELD_COLOR = Color(0xffB9B9B9);
const Color BACKGROUND_ADD_MEDIA_COLOR = Color(0xffEBEEF0);

class PahtCreateIssue extends StatefulWidget {
  @override
  _PahtCreateIssueState createState() => _PahtCreateIssueState();
}

class _PahtCreateIssueState extends State<PahtCreateIssue>
    implements OnButtonClickListener {
  static const platform = const MethodChannel('citizens.app/media_picker_ios');

  List<MediaFromServer> listMedia;
  List<int> listMediaDeleted = [];
  int currentAlbumIndex;
  dynamic listMediaFromIOS;
  List<BusinessHourEntity> BUSINESS_HOUR = [];
  bool isAddedBusinessHour = false;
  TextEditingController _poiNameController;
  TextEditingController _phoneNumberController;
  TextEditingController _addressController;
  TextEditingController _webController;
  FocusNode _contentFocusNode;
  FocusNode _focusNodeError;
  GlobalKey<FormState> _formKey;
  String _poiTypeValue;
  bool _isSubmitted = false;

  FocusNode _poiNameFocusNode;
  FocusNode _addressFocusNode;
  FocusNode _phoneNumberFocusNode;
  FocusNode _webFocusNode;
  ScrollController parentScrollController;

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  Map<String, dynamic> _chosenLocation = {
    'address': '',
    'latitude': null,
    'longitude': null
  };

  UpdatePahtArgument args;

  initValue(args) async {
    if (args != null) {
      if (args.address != null) {
        _chosenLocation['address'] = args.address;
        _chosenLocation['latitude'] = args.latitude;
        _chosenLocation['longitude'] = args.longitude;
      }

      if (args.content != null) {
        _poiNameController.text = args.content;
      }

      if (args.poiType != null) {
        _poiTypeValue = args.poiType.toString();
      }

      if (args.BUSINESS_HOUR != null && args.BUSINESS_HOUR.isNotEmpty) {
        BUSINESS_HOUR = args.BUSINESS_HOUR;
        isAddedBusinessHour = true;
        //getBusinessHour();
      }

      if (args.phone != null) {
        _phoneNumberController.text = args.phone;
      }

      if (args.hyperlink != null) {
        _webController.text = args.hyperlink;
      }

      if (args.listMedia != null) {
        listMedia = args.listMedia;
      }
    }
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _addressController = TextEditingController();
    _poiNameController = TextEditingController();
    parentScrollController = new ScrollController();
    _phoneNumberController = TextEditingController();
    _webController = TextEditingController();
    _addressFocusNode = FocusNode();
    _contentFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    _webFocusNode = FocusNode();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments as UpdatePahtArgument;
      });
      initValue(args);
    });
    _poiNameFocusNode = FocusNode();

    Future.delayed(Duration(milliseconds: 500), () {
        BlocProvider.of<CategoryPahtBloc>(context).add(ListCategoriesFetched());
    });


    for (int i = 0; i < 7; i++) {
      BUSINESS_HOUR.add(BusinessHourEntity(day: i, status: 0));
    }

    super.initState();
  }

  Future<List<MediaPickerIOSModel>> parsedListMediaPicker(
      dynamic argJson) async {
    List<MediaPickerIOSModel> convertedList = (argJson as List).map((s) {
      return MediaPickerIOSModel.fromJson(s);
    }).toList();
    return convertedList;
  }

  onPop() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
        title:
            args == null ? trans(TITLE_CREATE_REPORT) : trans(LABEL_UPDATE_POI),
        centerTitle: true,
        body: BlocConsumer<CreateIssueBloc, CreateIssueState>(
          listener: (_, state) {
            if (state is CreateIssueSuccess) {
              //Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop('dialog');
              Fluttertoast.showToast(
                  msg: args == null
                      ? trans(TEXT_CREATE_ISSUE_SUCCESS)
                      : trans(TEXT_UPDATE_ISSUE_SUCCESS));

              Navigator.pop(context, true);
            }

            if (state is CreateIssueFailure) {
              if (state.error !=null && state.error.message != null && state.error.message.toString() == "UNAUTHORIZED") {
                Fluttertoast.showToast(msg: trans(MESSAGE_SESSION_EXPIRED));
                 Navigator.of(context).pushNamedAndRemoveUntil(
                    ROUTER_SIGNIN, (Route<dynamic> route) => false);
              }else{
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Fluttertoast.showToast(
                    msg: state.error.message.toString() != null
                        ? ( state.error.message.toString() == "Connection failed" ? trans(ERROR_CONNECTION_FAILED) : state.error.message.toString())
                        : args == null
                        ? trans(TEXT_CREATE_ISSUE_FAILED)
                        : trans(TEXT_UPDATE_ISSUE_FAILED));
              }
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: parentScrollController,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            poiNameField(),
                            PoiTypeWidget(
                                initialValue: _poiTypeValue,
                                onChange: (val) {
                                  _poiTypeValue = val;
                                  clearFocus();
                                }),
                            addressField(),
                            businessHourField(),
                            phoneNumberField(),
                            webField(),
                            photosField(),
                            mediasField(context),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: createIssueAction(),
                  ),
                ],
              ),
            );
          },
        ));
    // );
  }

  Widget poiNameField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_poi_name.svg',
              width: SIZE_ICON,
              height: SIZE_ICON,
            ),
            SizedBox(height: SIZE_ICON),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: InputWithTitleWidget(
                      titleInput: trans(LABEL_POI_NAME),
                      isRequired: true,
                      paddingTop: 0,
                      fontSize: FONT_MIDDLE,
                      textFieldWidget: InputValidateCustomWidget(
                        limitLength: 255,
                        scrollPaddingForTop: true,
                        scrollPadding: 200,
                        isShowBorder: false,
                        focusNode: _poiNameFocusNode,
                        controller: _poiNameController,
                        hintText: trans(LABEL_POI_NAME),
                        focusAction: () => FormTools.requestFocus(
                          currentFocusNode: _poiNameFocusNode,
                          //nextFocusNode: _idNumberFocusNode,
                          context: context,
                        ),
                        validates: [
                          EmptyValidate(),
                        ],
                        focusError: (FocusNode focusNode) {
                          if (_focusNodeError == null) {
                            _focusNodeError = focusNode;
                          }
                        },
                      )),
                )
              ]),
        ),
      ],
    );
  }

  Widget addressField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_pin.svg',
              width: SIZE_ICON,
              height: SIZE_ICON,
            ),
            //  SizedBox(height: SIZE_ICON + 10),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0),
                Container(
                  child: InputWithTitleWidget(
                      titleInput: trans(LOCATION),
                      isRequired: true,
                      paddingTop: 5,
                      fontSize: FONT_MIDDLE,
                      textFieldWidget: InkWell(
                        onTap: () async {
                          clearFocus();
                          // await Navigator.push(
                          //     context,
                              // CupertinoPageRoute(
                              //     builder: (context) => LocationPickerVTMaps(
                              //           chosenLocation: _chosenLocation,
                              //         ))).then((value) => setState(() {
                              //   if (value != null) {
                              //     _chosenLocation = value;
                              //   }
                              // }));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                _chosenLocation['address'] != null &&
                                        !_chosenLocation['address']
                                            .toString()
                                            .isEmpty
                                    ? _chosenLocation['address']
                                    : trans(LABEL_POI_CHOOSE_LOCATION),
                                style: GoogleFonts.inter(
                                    color: SECONDARY_TEXT_COLOR,
                                    fontSize:
                                        _chosenLocation['address'] != null &&
                                                !_chosenLocation['address']
                                                    .toString()
                                                    .isEmpty
                                            ? FONT_MIDDLE
                                            : FONT_SMALL),
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              IMAGE_ASSETS_PATH + 'icon_menu_bds.png',
                              width: SIZE_ICON,
                              height: SIZE_ICON,
                            ),
                          ],
                        ),
                      )),
                ),
                Divider(
                  color: (_isSubmitted && _chosenLocation['address'] == '') ||
                          (_isSubmitted && _chosenLocation['address'] == null)
                      ? Colors.red
                      : ADDRESS_FIELD_COLOR,
                ),
                (_isSubmitted && _chosenLocation['address'] == '') ||
                        (_isSubmitted && _chosenLocation['address'] == null)
                    ? Text(trans(ERROR_VALIDATE_EMPTY_ADDRESS_PAHT),
                        style: GoogleFonts.inter(
                            color: Colors.red, fontSize: FONT_SMALL))
                    : SizedBox()
              ]),
        ),
      ],
    );
  }

  Widget businessHourField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_time.svg',
              width: SIZE_ICON,
              height: SIZE_ICON,
            ),
            //  SizedBox(height: SIZE_ICON + 10),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Container(
                  child: InputWithTitleWidget(
                      titleInput: trans(LABEL_TIME_OPERATION),
                      isRequired: false,
                      paddingTop: 5,
                      fontSize: FONT_MIDDLE,
                      textFieldWidget: InkWell(
                        onTap: () async {
                          await Navigator.pushNamed(
                                  context, ROUTER_BUSINESS_HOUR_PAGE,
                                  arguments: BusinessHourArgument(
                                      businessHour: BUSINESS_HOUR))
                              .then((value) => setState(() {
                                    if (value != null) {
                                      isAddedBusinessHour = true;
                                      BUSINESS_HOUR = value;
                                    }
                                  }));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                getBusinessHourString(),
                                style: GoogleFonts.inter(
                                    color: SECONDARY_TEXT_COLOR,
                                    fontSize: FONT_SMALL),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Divider(
                  color: ADDRESS_FIELD_COLOR,
                ),
              ]),
        ),
      ],
    );
  }

  Widget phoneNumberField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_phone_number.svg',
              width: SIZE_ICON,
              height: SIZE_ICON,
            ),
            SizedBox(height: SIZE_ICON),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Container(
                  child: InputWithTitleWidget(
                      titleInput: trans(LABEL_CONTACT_PHONE),
                      // trans(LABEL_CONTENT_PAHT),
                      isRequired: false,
                      paddingTop: 0,
                      fontSize: FONT_MIDDLE,
                      textFieldWidget: InputValidateCustomWidget(
                        textInputType: TextInputType.number,
                        limitLength: 15,
                        scrollPaddingForTop: true,
                        scrollPadding: 200,
                        isShowBorder: false,
                        readOnly: false,
                        focusNode: _phoneNumberFocusNode,
                        controller: _phoneNumberController,
                        hintText: trans(LABEL_CONTACT_PHONE),
                        focusAction: () => FormTools.requestFocus(
                          currentFocusNode: _phoneNumberFocusNode,
                          nextFocusNode: _webFocusNode,
                          context: context,
                        ),
                        validates: [
                          PhoneValidate(),
                        ],
                        focusError: (FocusNode focusNode) {
                          //widget.focusNodeError(focusNode);
                        },
                      )),
                )
              ]),
        ),
      ],
    );
  }

  Widget webField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_web.svg',
              width: SIZE_ICON,
              height: SIZE_ICON,
            ),
            SizedBox(height: SIZE_ICON),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: InputWithTitleWidget(
                      titleInput: trans(LABEL_WEB_SITE),
                      isRequired: false,
                      paddingTop: 0,
                      fontSize: FONT_MIDDLE,
                      textFieldWidget: InputValidateCustomWidget(
                        textInputType: TextInputType.text,
                        limitLength: 500,
                        scrollPaddingForTop: true,
                        scrollPadding: 200,
                        isShowBorder: false,
                        focusNode: _webFocusNode,
                        controller: _webController,
                        hintText: trans(LABEL_WEB_SITE),
                        focusAction: () => FormTools.requestFocus(
                          currentFocusNode: _webFocusNode,
                          //nextFocusNode: _idNumberFocusNode,
                          context: context,
                        ),
                        validates: [
                          //PhoneValidate(),
                        ],
                        focusError: (FocusNode focusNode) {
                          //widget.focusNodeError(focusNode);
                        },
                      )),
                )
              ]),
        ),
      ],
    );
  }

  Widget photosField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_photo.svg',
              width: SIZE_ICON,
              height: SIZE_ICON,
            ),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: InputWithTitleWidget(
                    titleInput: trans(LABEL_MEDIA_PAHT),
                    isRequired: false,
                    paddingTop: 0,
                    fontSize: FONT_MIDDLE,
                    textFieldWidget: Text(
                      trans(TEXT_MAXIMUM_DATA_MEDIA),
                      style: GoogleFonts.inter(
                          color: SECONDARY_TEXT_COLOR, fontSize: FONT_MIDDLE),
                    ),
                  ),
                )
              ]),
        ),
      ],
    );
  }

  Widget mediasField(BuildContext contextBuild) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  listMedia == null
                      ? SizedBox()
                      : Row(
                          children: [
                            for (var i = 0; i < listMedia.length; i++)
                              Container(
                                  padding: EdgeInsets.all(2),
                                  width: 150,
                                  height: 150,
                                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: listMedia[i]
                                                    .type
                                                    .compareTo("Asset") ==
                                                0
                                            ? AssetThumb(
                                                asset: listMedia[i].asset,
                                                width: 150,
                                                height: 150,
                                              )
                                            : Image.network(
                                                listMedia[i].relUrl,
                                                fit: BoxFit.fill,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffeffaf3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16)),
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              new AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  PRIMARY_COLOR),
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes
                                                              : null,
                                                        ),
                                                      ));
                                                },
                                                errorBuilder:
                                                    (BuildContext context,
                                                        Object exception,
                                                        StackTrace stackTrace) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Color.fromRGBO(
                                                            97, 120, 130, 0.2)),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                          SVG_ASSETS_PATH +
                                                              'icon_image_default.svg'),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                            onTap: () {
                                              if (listMedia[i].id != null) {
                                                listMediaDeleted
                                                    .add(listMedia[i].id);
                                              }

                                              if (listMedia[i].asset != null) {
                                                images
                                                    .remove(listMedia[i].asset);
                                                images = images;
                                              }

                                              listMedia.remove(listMedia[i]);
                                              setState(
                                                () {
                                                  listMedia = listMedia;
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                SVG_ASSETS_PATH +
                                                    'icon_clear.svg',
                                                color: Colors.white,
                                                width: 25,
                                                height: 25,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ))
                          ],
                        ),
                  SizedBox(width: 5),
                  addMediaWidget(
                      context: contextBuild,
                      onTap: () async {
                        loadAssets();
                      }),
                ],
              )),
          // (_isSubmitted && listMedia == null)
          //     ? Padding(
          //         padding: const EdgeInsets.only(top: 5),
          //         child: Text(trans(ERROR_VALIDATE_EMPTY_MEDIA_PAHT),
          //             style: GoogleFonts.inter(
          //                 color: Colors.redAccent, fontSize: FONT_SMALL)),
          //       )
          //     : SizedBox()
        ]);
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          statusBarColor: "#ee0033",
          actionBarColor: "#ee0033",
          allViewTitle: "Tất cả",
          startInAllView: true,
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (resultList != null && resultList.isNotEmpty) {
        _error = error;
        //listMedia = resultList;
        images = resultList;
        if(listMedia == null){
          listMedia = [];
        }

        listMedia.removeWhere((item) => item.asset != null);

        for (int i = 0; i < resultList.length; i++) {
          listMedia.add(MediaFromServer(type: "Asset", asset: resultList[i]));
        }
      }
    });
  }

  void _showCupertinoDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return createIssueStatusContainer();
      },
    );
  }

  createIssueStatusContainer() {
    return AlertDialog(
      content: new Row(
        children: [
          SleekCircularSlider(
            appearance: CircularSliderAppearance(
              spinnerMode: true,
              size: 40,
              customColors: CustomSliderColors(
                dotColor: PRIMARY_COLOR,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: Text(
              trans(TEXT_WAITING_ALERT),
              style: GoogleFonts.inter(
                color: SECONDARY_TEXT_COLOR,
                fontSize: FONT_SMALL,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createIssueAction() {
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
                label: args == null
                    ? trans(TEXT_CREATE_ISSUE_BUTTON)
                    : trans(TEXT_UPDATE_ISSUE_BUTTON),
                ctx: this,
                id: 'primary_btn'),
          )
        ],
      ),
    );
  }

  @override
  onClick(String id) async {
    if (id == 'primary_btn') {
      setState(() {
        _isSubmitted = true;
      });

      clearFocus();

    if(!_formKey.currentState.validate()){
      FocusScope.of(context).requestFocus(_focusNodeError);
      _focusNodeError = null;
      if (parentScrollController.hasClients) {
        parentScrollController.animateTo(0,duration:Duration(milliseconds: 500),curve: Curves.fastOutSlowIn);
      }
      return;
    }
      if ((_chosenLocation['latitude'] == null ||
          _chosenLocation['longitude'] == null ||
          _chosenLocation['address'] == null ||
          _chosenLocation['address'].toString().isEmpty)) {
        if (parentScrollController.hasClients) {
          parentScrollController.animateTo(0,duration:Duration(milliseconds: 500),curve: Curves.fastOutSlowIn);
        }
        return;
      }

      if (_formKey.currentState.validate()) {
        BlocProvider.of<CreateIssueBloc>(context)
            .add(CreateIssueButtonPresseEvent(
          params: IssueParams(
              name: _poiNameController.text.trim(),
              address: _chosenLocation['address'],
              lat: _chosenLocation['latitude'].toString(),
              lng: _chosenLocation['longitude'].toString(),
              fromPoiType:
                  _poiTypeValue == null ? null : int.parse(_poiTypeValue),
              id: args == null ? null : int.parse(args.pahtId),
              hyperlink: _webController.text.trim(),
              phone: _phoneNumberController.text.trim(),
              businessHour: isAddedBusinessHour ? BUSINESS_HOUR : null,
              files: listMedia,
              deletePlaceImageIds: listMediaDeleted),
          type: args == null ? 0 : 1,
        ));

        _showCupertinoDialog(context);
      }
    }
    if (id == 'cancel_btn') {
      Navigator.pop(context);
    }
  }

  String getBusinessHourString() {
    if (!isAddedBusinessHour) {
      return trans(LABEL_TIME_OPERATION);
    } else {
      String results = '';
      List<int> listDay = [];
      int closedCount = 0;
      int openAllDayCount = 0;
      for (int i = 0; i < BUSINESS_HOUR.length; i++) {
        if (BUSINESS_HOUR[i].status == CLOSE_STATUS) {
          closedCount += 1;
        }
        if (BUSINESS_HOUR[i].status == OPEN_ALL_DAY_STATUS) {
          openAllDayCount += 1;
        }

        if (listDay.contains(i)) {
          continue;
        }
        BusinessHourEntity businessHourEntity = BUSINESS_HOUR[i];
        listDay.add(i);
        results += getDayShortName(i);
        for (int j = i + 1; j < BUSINESS_HOUR.length; j++) {
          BusinessHourEntity secondEntity = BUSINESS_HOUR[j];
          if (businessHourEntity.status == CLOSE_STATUS ||
              businessHourEntity.status == OPEN_ALL_DAY_STATUS) {
            if ((!listDay.contains(j) &&
                secondEntity.status == businessHourEntity.status)) {
              listDay.add(j);
              results += ', ' + getDayShortName(j);
            }
          } else {
            if (!listDay.contains(j) &&
                secondEntity.status == businessHourEntity.status &&
                businessHourEntity.openTime != null &&
                businessHourEntity.closeTime != null &&
                secondEntity.openTime != null &&
                secondEntity.closeTime != null &&
                businessHourEntity.openTime == secondEntity.openTime &&
                businessHourEntity.closeTime == secondEntity.closeTime) {
              listDay.add(j);
              results += ', ' + getDayShortName(j);
            }
          }
        }

        if (businessHourEntity.status == CLOSE_STATUS) {
          results += ": " + trans(LABEL_CLOSED) + '\n';
          ;
        } else if (businessHourEntity.status == OPEN_ALL_DAY_STATUS) {
          results += ": " + trans(LABEL_OPEN_24H) + '\n';
        } else if (businessHourEntity.openTime != null &&
            businessHourEntity.closeTime != null) {
          results += ": " +
              businessHourEntity.openTime +
              ' - ' +
              businessHourEntity.closeTime +
              "\n";
        }
      }

      if (closedCount == BUSINESS_HOUR.length) {
        results = trans(LABEL_CLOSED);
      } else if (openAllDayCount == BUSINESS_HOUR.length) {
        results = trans(LABEL_OPEN_24H) +" 24/7";
      }

      return results.trim();
    }
  }

  void clearFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

Future<bool> _checkPermission() async {
  final permissionStorageGroup =
      Platform.isIOS ? PermissionGroup.photos : PermissionGroup.storage;
  Map<PermissionGroup, PermissionStatus> res =
      await PermissionHandler().requestPermissions([
    permissionStorageGroup,
  ]);
  return res[permissionStorageGroup] == PermissionStatus.granted;
}

Widget addMediaWidget({Function onTap, BuildContext context}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
          color: BACKGROUND_ADD_MEDIA_COLOR,
          borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_camera.svg',
              width: SIZE_CAMERA_ICON,
              height: SIZE_CAMERA_ICON,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              trans(ACT_ADD),
              style: GoogleFonts.inter(
                  fontSize: FONT_SMALL, color: SECONDARY_TEXT_COLOR),
            ),
            SizedBox(
              height: 5,
            ),
            Text(trans(LABEL_MEDIA_PAHT),
                style: GoogleFonts.inter(
                    fontSize: FONT_SMALL, color: SECONDARY_TEXT_COLOR))
          ],
        ),
      ),
    ),
  );
}
