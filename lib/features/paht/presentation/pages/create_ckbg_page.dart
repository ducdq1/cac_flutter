import 'dart:io' show Platform;
import 'dart:ui';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_personal_page/input_datetime_widget.dart';
import 'package:citizen_app/features/common/dialogs/delete_confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/text_field_custom.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/home/presentation/pages/web_view_ckbg_page.dart';
import 'package:citizen_app/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_ckbg.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_ckbg_bloc/create_ckbg_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_issue_bloc/create_issue_bloc.dart';
import 'package:citizen_app/features/paht/presentation/pages/product_search.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/ckbg_detail_item_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/ckbg_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../injection_container.dart';

const SIZE_ICON = 20.0;
const SIZE_PICKER_LOCATION_ICON = 36.0;
const SIZE_CAMERA_ICON = 36.0;
const Color ADDRESS_FIELD_COLOR = Color(0xffB9B9B9);
const Color BACKGROUND_ADD_MEDIA_COLOR = Color(0xffEBEEF0);
const double SIZE_PADDING_ICON = 180;

class CreateCKBGPage extends StatefulWidget {
  @override
  _CreateCKBGPageState createState() => _CreateCKBGPageState();
}

class _CreateCKBGPageState extends State<CreateCKBGPage>
    with SingleTickerProviderStateMixin
    implements OnButtonClickListener {
  int currentAlbumIndex;
  dynamic listMediaFromIOS;
  bool isAddedBusinessHour = false;
  TextEditingController _poiNameController;
  TextEditingController _phoneNumberController;
  TextEditingController _addressController;
  TextEditingController noteController;
  FocusNode _focusNodeError;
  GlobalKey<FormState> _formKey;
  ScrollController scrollController;
  FocusNode _poiNameFocusNode;
  FocusNode _addressFocusNode;
  FocusNode _phoneNumberFocusNode;
  FocusNode _notFocusNode;
  ScrollController parentScrollController;
  CKBGModel pahtModel;
  String NOTE_CONTENT =
      '4/ Hàng trả lại không được vượt quá 10% so với hàng đặt.';
  List<CKBGDetailModel> listQuotationDetailModel = [];
  final prefs = singleton<SharedPreferences>();
  int imageIdSelected;

  AnimationController _controller;
  Animation<double> _animation;

  bool _isSPGach = true;

  UpdateCKBGArgument args;

  initValue(UpdateCKBGArgument args) async {
    if (args != null && args.pahtModel != null) {
      pahtModel = args.pahtModel;
      listQuotationDetailModel = args.listCKGBDetailModel;
      if (listQuotationDetailModel == null) {
        listQuotationDetailModel = [];
      }

      if (pahtModel.cusName != null) {
        _poiNameController.text = pahtModel.cusName;
      }

      if (pahtModel.cusAddress != null) {
        _addressController.text = pahtModel.cusAddress;
      }

      if (pahtModel.cusPhone != null) {
        _phoneNumberController.text = pahtModel.cusPhone;
      }

      if (pahtModel.type != null) {
        _isSPGach = pahtModel.type == 0;
      }
      if (pahtModel.content != null) {
        noteController.text = pahtModel.content;
      } else {
        noteController.text = NOTE_CONTENT;
      }

      if (pahtModel.ckbgId != null) {
        BlocProvider.of<CreateCKBGBloc>(context).add(
          GetListCKBGDetailEvent(id: pahtModel.ckbgId),
        );
      }
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    final Animation curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _animation = Tween(begin: 0.0, end: 29.0).animate(curve);
    _controller.repeat(reverse: true);

    _formKey = GlobalKey<FormState>();
    noteController = TextEditingController();
    _addressController = TextEditingController();
    _poiNameController = TextEditingController();
    parentScrollController = new ScrollController();
    _phoneNumberController = TextEditingController();
    _addressFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    _notFocusNode = FocusNode();
    scrollController = new ScrollController();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments as UpdateCKBGArgument;
      });
      initValue(args);
    });
    _poiNameFocusNode = FocusNode();

    super.initState();
  }

  onPop() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
        title: args == null ? 'Tạo cam kết' : 'Cập nhật cam kết',
        centerTitle: true,
        body: BlocConsumer<CreateCKBGBloc, CreateCKBGState>(
          listener: (_, state) {
            if (state is GetListCKBGDetailSuccess) {
              setState(() {
                listQuotationDetailModel = state.listCKBGDetailModel;
              });
            }

            if (state is CreateCKBGSuccess) {
              setState(() {
                pahtModel.fileName = state.fileName;
              });

              //Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop('dialog');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewPageCKBG(
                          title: 'Chi tiết báo giá',
                          link: '$baseUrl' + 'ck_bao_gia/' + state.fileName,
                        )),
              );

              //Navigator.pop(context, true);
            }

            if (state is CreateCKBGFailure) {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              Fluttertoast.showToast(
                  msg: state.error.message.toString() != null
                      ? (state.error.message.toString() == "Connection failed"
                          ? trans(ERROR_CONNECTION_FAILED)
                          : state.error.message.toString())
                      : args == null
                          ? 'Tạo Cam kết thất bại'
                          : 'Cập nhật cam kết thất bại');
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
                            quotationTypField(),
                            Divider(height: 2, color: Colors.green),
                            SizedBox(
                              height: 5,
                            ),
                            listProductField(),
                            state is GetListQuotationDetailLoading
                                ? Center(child: LoadingWidget())
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        border: Border.all(
                          width: 0.2,
                          color: PRIMARY_COLOR,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(children: [
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        !_isSPGach
                            ? SizedBox()
                            : TextField(
                                controller: noteController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  helperText: '',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: BORDER_COLOR, width: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: BORDER_COLOR, width: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                )),
                        createIssueAction()
                      ])),
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
                        limitLength: 500,
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
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(
                trans(TEXT_WAITING_ALERT),
                style: GoogleFonts.inter(
                  color: SECONDARY_TEXT_COLOR,
                  fontSize: FONT_SMALL,
                ),
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listProductField() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sản phẩm (' + listQuotationDetailModel.length.toString() + ')',
            style: GoogleFonts.inter(
                color: Colors.green,
                fontSize: FONT_EX_LARGE,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 10),
            itemBuilder: (BuildContext context, int index) {
              return CKBGDetailItemWidget(
                onDelete: () {
                  showDeleteConfirmDialog(
                    context: context,
                    onSubmit: () {
                      setState(() {
                        listQuotationDetailModel.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
                onEdit: () {
                  Navigator.pushNamed(context, ROUTER_CKBG_CHOOSE_PRODUCT,
                          arguments: CKBGDetailArgument(
                              productCode:
                                  listQuotationDetailModel[index].productCode,
                              ckbgDetailModel: listQuotationDetailModel[index]))
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        listQuotationDetailModel[index] = value;
                      });
                    }
                  });
                },
                isPersonal: false,
                ckbgDetailModel: listQuotationDetailModel[index],
                onTap: () {},
              );
            },
            // itemCount: widget.hasReachedMax
            //     ? widget.pahts.length
            //     : widget.pahts.length + 1,
            itemCount: listQuotationDetailModel.length,
            controller: scrollController,
          )
        ]);
  }

  Widget createIssueAction() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(children: [
        Row(
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
        SizedBox(height: 20,),
        pahtModel.fileName ==null ? SizedBox() :  Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                width: 142,
                child: PrimaryButton(
                    label: 'Xem cam kết', ctx: this, id: 'view_pdf_btn'),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget quotationTypField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 10),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                child: FlatButton(
                    // here toggle the bool value so that when you click
                    // on the whole item, it will reflect changes in Checkbox
                    onPressed: () => setState(() {
                          _isSPGach = !_isSPGach;
                        }),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                  activeColor: PRIMARY_COLOR,
                                  value: _isSPGach,
                                  onChanged: (value) {
                                    setState(() {
                                      _isSPGach = value;
                                    });
                                  })),
                          // You can play with the width to adjust your
                          // desired spacing
                          SizedBox(width: 10.0),
                          Expanded(child: Text('Gạch men'))
                        ])),
              ),
            ),
            Expanded(
              child: Container(
                child: FlatButton(
                    // here toggle the bool value so that when you click
                    // on the whole item, it will reflect changes in Checkbox
                    onPressed: () => setState(() {
                          _isSPGach = !_isSPGach;
                        }),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                  activeColor: PRIMARY_COLOR,
                                  value: !_isSPGach,
                                  onChanged: (value) {
                                    setState(() {
                                      _isSPGach = !value;
                                    });
                                  })),
                          // You can play with the width to adjust your
                          // desired spacing
                          SizedBox(width: 10.0),
                          Expanded(child: Text('Thiết bị'))
                        ])),
              ),
            ),
          ],
        )),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  onClick(String id) async {
    if (id == 'primary_btn') {
      clearFocus();
      if (listQuotationDetailModel.isEmpty) {
        Fluttertoast.showToast(
          msg: "Phải chọn ít nhất 1 sản phẩm.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      for (int i = 0; i < listQuotationDetailModel.length; i++) {
        if (listQuotationDetailModel[i].price == null) {
          Fluttertoast.showToast(
              msg: "Bạn chưa nhập giá cho sản phẩm: " +
                  listQuotationDetailModel[i].productCode);
          return;
        }
        if (listQuotationDetailModel[i].amount == null) {
          Fluttertoast.showToast(
              msg: "Bạn chưa nhập số lượng cho sản phẩm: " +
                  listQuotationDetailModel[i].productCode);
          return;
        }

        if (listQuotationDetailModel[i].percent == null) {
          Fluttertoast.showToast(
              msg: "Bạn chưa nhập đặt cọc (%) cho sản phẩm: " +
                  listQuotationDetailModel[i].productCode);
          return;
        }

        if (listQuotationDetailModel[i].pickDate == null) {
          Fluttertoast.showToast(
              msg: "Bạn chưa nhập ngày lấy hàng cho sản phẩm: " +
                  listQuotationDetailModel[i].productCode);
          return;
        }


      }



      if (_formKey.currentState.validate()) {
        final userName = prefs.get('userName').toString();
        final userFullName = prefs.get('fullName').toString();

        BlocProvider.of<CreateCKBGBloc>(context).add(
            CreateCKBGButtonPresseEvent(
                createCKBGParams: CreateCKBGParams(
                    ckbg: CKBGModel(
                        ckbgId: pahtModel == null ? null : pahtModel.ckbgId,
                        type: _isSPGach ? 0 : 1,
                        cusName: _poiNameController.text.trim(),
                        cusAddress: _addressController.text.trim(),
                        cusPhone: _phoneNumberController.text.trim(),
                        createUserCode: userName,
                        content: noteController.text.trim(),
                        createUserFullName: userFullName),
                    lstCKBGDetail: listQuotationDetailModel)));

        _showCupertinoDialog(context);
      }
    }

    if (id == 'cancel_btn') {
      Navigator.pop(context);
    }


    if (id == 'view_pdf_btn') {
      if (pahtModel.fileName == null || pahtModel.fileName.isEmpty) {
        Fluttertoast.showToast(msg: 'Không có file báo giá để xem');
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewPageCKBG(
                  title: 'Chi tiết báo giá',
                  link: '$baseUrl' + 'ck_bao_gia/' + pahtModel.fileName,
                  //model: pahtModel,
                )),
      );
    }
  }

  void clearFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void gotoDetailProductPage(String cameraScanResult, int productId) {
    Navigator.pushNamed(context, ROUTER_CKBG_CHOOSE_PRODUCT,
            arguments: CKBGDetailArgument(
                productCode: cameraScanResult, productId: productId))
        .then((value) => {
              if (value != null)
                {
                  setState(() {
                    if (value is CKBGDetailModel) {
                      CKBGDetailModel exist;
                      int indexExist = -1;
                      for (int i = 0;
                          i < listQuotationDetailModel.length;
                          i++) {
                        if (listQuotationDetailModel[i].productId ==
                            value.productId) {
                          exist = value;
                          indexExist = i;
                        }
                      }

                      if (exist == null) {
                        listQuotationDetailModel.add(value);
                      } else {
                        listQuotationDetailModel[indexExist] = (value);
                      }
                    }
                  })
                }
            });
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
