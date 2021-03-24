import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/phone_validate.dart';
import 'package:citizen_app/features/common/dialogs/delete_confirm_dialog.dart';
import 'package:citizen_app/features/common/utils.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/text_field_custom.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/paht/data/models/media_from_server.dart';
import 'package:citizen_app/features/paht/data/models/media_picker_ios_model.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_issue_paht.dart';
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_issue_bloc/create_issue_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_item_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/FrameLabelWidget.dart';
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
  ScrollController scrollController;
  FocusNode _poiNameFocusNode;
  FocusNode _addressFocusNode;
  FocusNode _phoneNumberFocusNode;
  FocusNode _webFocusNode;
  ScrollController parentScrollController;
  PahtModel pahtModel;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  List<ProductModel> listProductModel = [];
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

      if (args.phone != null) {
        _phoneNumberController.text = args.phone;
      }

      pahtModel = args.pahtModel;

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
    scrollController = new ScrollController();
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: FloatingActionButton(
            child: Image.asset(
              'assets/icons/icon_scan_qr.png',
              height: 29,
              width: 29,
            ),
            // Icon( '/icons/icon_scan_qr.png', color: Colors.white, size: 29,),
            backgroundColor: Colors.amber,
            tooltip: 'Quét mã',
            elevation: 5,
            splashColor: Colors.grey,
            onPressed: () {},
          ),
        ),
        title: args == null ? 'Tạo báo giá' : 'Cập nhật báo giá',
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
              if (state.error != null &&
                  state.error.message != null &&
                  state.error.message.toString() == "UNAUTHORIZED") {
                Fluttertoast.showToast(msg: trans(MESSAGE_SESSION_EXPIRED));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    ROUTER_SIGNIN, (Route<dynamic> route) => false);
              } else {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Fluttertoast.showToast(
                    msg: state.error.message.toString() != null
                        ? (state.error.message.toString() == "Connection failed"
                            ? trans(ERROR_CONNECTION_FAILED)
                            : state.error.message.toString())
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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            poiNameField(),
                            addressField(),
                            phoneNumberField(),
                            listProductField()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        border: Border.all(
                          width: 0.2,
                          color: PRIMARY_COLOR,
                        ),
                      ),
                      child: createIssueAction()),
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
                      titleInput: 'Tên khách hàng',
                      isRequired: true,
                      paddingTop: 0,
                      fontSize: FONT_SMALL,
                      textFieldWidget: InputValidateCustomWidget(
                        limitLength: 255,
                        scrollPaddingForTop: true,
                        scrollPadding: 200,
                        isShowBorder: false,
                        focusNode: _poiNameFocusNode,
                        controller: _poiNameController,
                        hintText: 'Tên khách hàng',
                        focusAction: () => FormTools.requestFocus(
                          currentFocusNode: _poiNameFocusNode,
                          nextFocusNode: _addressFocusNode,
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
                      titleInput: 'Địa chỉ',
                      isRequired: true,
                      paddingTop: 0,
                      fontSize: FONT_SMALL,
                      textFieldWidget: InputValidateCustomWidget(
                        textInputType: TextInputType.text,
                        limitLength: 15,
                        scrollPaddingForTop: true,
                        scrollPadding: 200,
                        isShowBorder: false,
                        readOnly: false,
                        focusNode: _addressFocusNode,
                        controller: _addressController,
                        hintText: 'Địa chỉ',
                        focusAction: () => FormTools.requestFocus(
                          currentFocusNode: _addressFocusNode,
                          nextFocusNode: _phoneNumberFocusNode,
                          context: context,
                        ),
                        validates: [
                          EmptyValidate(),
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
                Container(
                  child: InputWithTitleWidget(
                      titleInput: 'Điện thoại',
                      // trans(LABEL_CONTENT_PAHT),
                      isRequired: false,
                      paddingTop: 0,
                      fontSize: FONT_SMALL,
                      textFieldWidget: InputValidateCustomWidget(
                        textInputType: TextInputType.number,
                        limitLength: 15,
                        scrollPaddingForTop: true,
                        scrollPadding: 200,
                        isShowBorder: false,
                        readOnly: false,
                        focusNode: _phoneNumberFocusNode,
                        controller: _phoneNumberController,
                        hintText: 'Điện thoại',
                        focusAction: () => FormTools.requestFocus(
                          currentFocusNode: _phoneNumberFocusNode,
                          //nextFocusNode: _webFocusNode,
                          context: context,
                        ),
                        validates: [],
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

  Widget listProductField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sản phẩm',
                  style: GoogleFonts.inter(
                      color: PRIMARY_TEXT_COLOR,
                      fontSize: FONT_EX_LARGE,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),

                ListView.builder(
                  padding: EdgeInsets.only(bottom: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return  PAHTITemWidget(
                              onDelete: () {
                                showDeleteConfirmDialog(
                                    context: context,
                                    onSubmit: () {

                                      Navigator.pop(context);
                                    },
                                 );
                              },
                              onEdit: () {
                                Navigator.pushNamed(context, ROUTER_CREATE_PAHT,
                                    arguments: UpdatePahtArgument(
                                        content: pahtModel.cusName,
                                        address: pahtModel.cusAddress
                                    ))
                                    .then((value) {

                                });
                              },
                             // isPersonal: widget.isPersonal,
                              pahtModel: pahtModel,
                              onTap: () {
                                // Navigator.pushNamed(
                                //   context,
                                //   ROUTER_DETAILED_PAHT,
                                //   arguments: PahtDetailArgument(
                                //       poiDetail: widget.pahts[index],
                                //       id: widget.pahts[index].id.toString(),
                                //       title: widget.pahts[index].name),
                                // );
                              },
                            );
                  },
                  // itemCount: widget.hasReachedMax
                  //     ? widget.pahts.length
                  //     : widget.pahts.length + 1,
                  itemCount: listProductModel.length,
                  controller: scrollController,
                )


              ]),
        ),
      ],
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

      if (!_formKey.currentState.validate()) {
        FocusScope.of(context).requestFocus(_focusNodeError);
        _focusNodeError = null;
        if (parentScrollController.hasClients) {
          parentScrollController.animateTo(0,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }
        return;
      }
      if ((_chosenLocation['latitude'] == null ||
          _chosenLocation['longitude'] == null ||
          _chosenLocation['address'] == null ||
          _chosenLocation['address'].toString().isEmpty)) {
        if (parentScrollController.hasClients) {
          parentScrollController.animateTo(0,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
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
              //files: listMedia,
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
