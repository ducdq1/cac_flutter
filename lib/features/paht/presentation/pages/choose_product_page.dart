import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/failure_widget/failure_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_widget.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/paht/data/models/image_model.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/tonkho_model.dart';
import 'package:citizen_app/features/paht/presentation/bloc/detailed_paht_bloc/detailed_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/public_paht_bloc/public_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/pages/media_presenter_page.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/appbar_heading_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/paht_info_tabview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:equatable/equatable.dart';

const PADDING_CONTENT_HORIZONTAL = 16.0;
const SIZE_ARROW_BACK_ICON = 24.0;

class ChooseProductPage extends StatefulWidget {
  @override
  _ChooseProductPageState createState() => _ChooseProductPageState();
}

class SearchProductParam extends Equatable {
  final String productCode;
  final String productName;
  final String userName;

  SearchProductParam({this.productCode, this.productName, this.userName});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  Map<String, dynamic> toJson() {
    return {
      'productCode': productCode,
      'productName': productName,
      'userName': userName
    };
  }
}

class _ChooseProductPageState extends State<ChooseProductPage>
    with TickerProviderStateMixin
    implements OnButtonClickListener {
  TabController _controller;
  final tabs = [trans(TITLE_INFORMATION_SCREEN), trans(LABEL_MEDIA_PAHT)];
  int _index;
  PahtDetailArgument arg;
  String productCode;
  ProductModel productModel;
  TonKhoModel tonKhoModel;
  bool firstLoad = true;
  FocusNode _passFocusNode;
  TextEditingController _passController;
  TextEditingController _notController;
  FocusNode _noteFocusNode;
  int selectedImageId = -1;
  ImageModel image;
  QuotationDetailModel quotationDetailModel;
  @override
  void initState() {
    bool firstLoad = true;
    _controller = TabController(vsync: this, length: 2);
    _index = _controller.index;
    _passFocusNode = FocusNode();
    _passController = TextEditingController();
    _notController = TextEditingController();
    _noteFocusNode  = FocusNode();
    _controller.addListener(() {
      setState(() {
        _index = _controller.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (firstLoad) {
      firstLoad = false;
      arg = ModalRoute.of(context).settings.arguments as PahtDetailArgument;
      productCode = arg.productCode;
      quotationDetailModel = arg.quotationDetailModel;
      if(quotationDetailModel !=null){
        _passController.text = quotationDetailModel.amount.toString();
        _notController.text = quotationDetailModel.note;
        selectedImageId = quotationDetailModel.attachId ;

      }
      BlocProvider.of<DetailedPahtBloc>(context).add(
        DetailedPahtFetching(pahtId: productCode),
      );
    }
    return BaseLayoutWidget(
        title: 'Thông tin sản phẩm',
        centerTitle: true,
        body: Scaffold(
          body: BlocConsumer<DetailedPahtBloc, DetailedPahtState>(
              listener: (context, state) {
            if (state is DetailedPahtFailure &&
                state.error.toString() == "UNAUTHORIZED") {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  ROUTER_SIGNIN, (Route<dynamic> route) => false);
            }
          }, builder: (context, state) {
            child:
            if (state is DetailedPahtSuccess) {
              if (state.searchProductModel.lstProduct != null &&
                  state.searchProductModel.lstProduct.isNotEmpty) {
                productModel = state.searchProductModel.lstProduct[0];
                tonKhoModel = state.searchProductModel.tonKhoModel;

                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        // TabBarCustomWidget(controller: _controller),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.only(top: 0),
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Container(
                                  color: Colors.white,
                                  child: Container(
                                    //height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                      ///color: Color(0xffE6EFF3).withOpacity(0.6),
                                      color: Color.fromARGB(153, 250, 245, 232),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          color: Color(0xfff1e3c0),
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Image.asset(
                                                ICONS_ASSETS + 'icon_info.png',
                                                width: 32,
                                                height: 32,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Thông tin",
                                                  style: GoogleFonts.inter(
                                                    fontSize: FONT_EX_MIDDLE,
                                                    color: Color(0xff0F8E70),
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(children: [
                                          SizedBox(width: 30),
                                          SvgPicture.asset(
                                            SVG_ASSETS_PATH +
                                                'icon_poi_name.svg',
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                              child: Container(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                Text("Tên Sản phẩm",
                                                    style: GoogleFonts.inter(
                                                      fontSize: FONT_MIDDLE,
                                                      color: PRIMARY_TEXT_COLOR,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                SizedBox(height: 10),
                                                Text(
                                                  productModel == null
                                                      ? ""
                                                      : productModel
                                                          .productName,
                                                  style: GoogleFonts.inter(
                                                    fontSize: FONT_MIDDLE,
                                                    color:
                                                        Colors.amber.shade900,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ]))),
                                        ]),
                                        SizedBox(height: 18),
                                        Row(
                                          children: [
                                            SizedBox(width: 30),
                                            Image.asset(
                                              ICONS_ASSETS + 'icon_scan_qr.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                                child: Container(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                  Text("Mã Sản phẩm",
                                                      style: GoogleFonts.inter(
                                                        fontSize: FONT_MIDDLE,
                                                        color:
                                                            PRIMARY_TEXT_COLOR,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    productModel == null
                                                        ? ""
                                                        : productModel
                                                            .productCode,
                                                    style: GoogleFonts.inter(
                                                      fontSize: FONT_MIDDLE,
                                                      color:
                                                          Colors.amber.shade900,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ]))),
                                          ],
                                        ),
                                        SizedBox(height: 18),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 30),
                                              Image.asset(
                                                ICONS_ASSETS +
                                                    'icon_ware_house.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                  child: Container(
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                    Text("Tồn kho",
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: FONT_MIDDLE,
                                                          color:
                                                              PRIMARY_TEXT_COLOR,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      tonKhoModel == null ||
                                                              tonKhoModel
                                                                      .so_luong ==
                                                                  null
                                                          ? "Không có thông tin"
                                                          : tonKhoModel.so_luong
                                                              .toString(),
                                                      style: GoogleFonts.inter(
                                                        color: Colors
                                                            .amber.shade900,
                                                        fontSize: FONT_MIDDLE,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ])))
                                            ]),
                                        SizedBox(height: 10),
                                        Container(
                                            // color: Color(0xfff1e3c0),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              ///color: Color(0xffE6EFF3).withOpacity(0.6),
                                              color: Color(0xfff1e3c0),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Image.asset(
                                                  ICONS_ASSETS +
                                                      'icon_images.png',
                                                  width: 32,
                                                  height: 32,
                                                ),
                                                SizedBox(width: 10),
                                                Text("Hình ảnh",
                                                    style: GoogleFonts.inter(
                                                      fontSize: FONT_EX_MIDDLE,
                                                      color: Color(0xff0F8E70),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                              ],
                                            )),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                            //width: ,

                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: productModel
                                                    .images.isNotEmpty
                                                ? GridView.count(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    crossAxisCount: 3,
                                                    childAspectRatio: 1.0,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    mainAxisSpacing: 4.0,
                                                    crossAxisSpacing: 4.0,
                                                    children: _getTiles(
                                                        productModel.images,
                                                        context))
                                                : Text("Không có hình ảnh",
                                                    style: GoogleFonts.inter(
                                                      fontSize: FONT_EX_MIDDLE,
                                                      color: Color(0xff0F8E70),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        addProductField()
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Text(
                              'Không tìm thấy thông tin của sản phẩm: ' +
                                  productCode,
                              style: GoogleFonts.inter(
                                color: PRIMARY_TEXT_COLOR,
                                fontSize: FONT_MIDDLE,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ));
              }
            } else if (state is DetailedPahtFailure) {
              return NoNetworkFailureWidget(
                  message: state.error.toString() == "UNAUTHORIZED"
                      ? trans(MESSAGE_SESSION_EXPIRED)
                      : state.error.toString(),
                  onPressed: () {
                    BlocProvider.of<DetailedPahtBloc>(context)
                        .add(DetailedPahtFetching(pahtId: productCode));
                  });
            }
            return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SkeletonPahtWidget(
                      itemCount: 1,
                    ),
                    Text('Đang lấy thông tin...',
                        style: GoogleFonts.inter(
                          color: PRIMARY_TEXT_COLOR,
                          fontSize: FONT_MIDDLE,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ));
          }),
        ));
  }

  Widget addProductField() {
    return Container(
      decoration: BoxDecoration(
        ///color: Color(0xffE6EFF3).withOpacity(0.6),
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 12,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InputValidateWidget(
                          isRequired: true,
                          label: 'Số lượng',
                          limitLength: 20,
                          focusNode: _passFocusNode,
                          textInputType: TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          controller: _passController,
                          focusAction: () => FormTools.requestFocus(
                            currentFocusNode: _passFocusNode,
                            nextFocusNode: _noteFocusNode,
                            context: context,
                          ),
                          validates: [
                            EmptyValidate(),
                          ],
                        ),
                        InputValidateWidget(
                          isRequired: true,
                          label: 'Ghi chú',
                          limitLength: 2000,
                          focusNode: _noteFocusNode,
                          textInputType: TextInputType.text ,
                          controller: _notController,
                          focusAction: () => FormTools.requestFocus(
                            currentFocusNode: _noteFocusNode,
                            nextFocusNode: null,
                            context: context,
                          ),
                          validates: [
                            EmptyValidate(),
                          ],
                        )
                      ]),
                ),
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
                          label: 'Chọn', ctx: this, id: 'primary_btn'),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _getTiles(List<ImageModel> imageModels, BuildContext context) {
    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < imageModels.length; i++) {
      ImageModel imageModel = imageModels[i];
      tiles.add(GridTile(
          child: Container(
            decoration: BoxDecoration(
              color: selectedImageId == imageModel.attachId ? Colors.blue : Color.fromARGB(153, 250, 245, 232),
              borderRadius: BorderRadius.all(Radius.circular(10)),

            ),
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),

        child:
                //FadeInImage.memoryNetwork(placeholder: AssetImage('sdsadas'), image: '$baseUrl' + url),
                InkWell(
              onTap: () async {
                setState(() {
                  if(selectedImageId == imageModel.attachId){
                    selectedImageId = -1;
                    image =null;
                  }else {
                    selectedImageId = imageModel.attachId;
                    image = imageModel;
                  }
                });
              },
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: '$baseUrl' + imageModel.path + imageModel.name,
                placeholder: (context, url) =>
                    new CircularProgressIndicator(strokeWidth: 2.0),
                height: 15,
                width: 15,
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
        ),
      ),
            ),
          )));
    }
    return tiles;
  }

  @override
  onClick(String id) async {
    if (id == 'primary_btn') {
      String amountStr = _passController.text.toString();
      double amount;
      try {
        amount = double.parse(amountStr);
      } catch (error) {
        FocusScope.of(context).requestFocus(_passFocusNode);
        return;
      }

      if (amountStr.isEmpty || amount == 0) {
        FocusScope.of(context).requestFocus(_passFocusNode);
      } else {
        QuotationDetailModel model = QuotationDetailModel(
            productCode: productModel.productCode,
            productId: productModel.productId,
            productName: productModel.productName,
            unit: productModel.unit,
            amount: amount,
            image: image,
            note: _notController.text.trim(),
            attachId: selectedImageId == -1 ? null : selectedImageId);
        Navigator.pop(context, model);
      }
    }
    if (id == 'cancel_btn') {
      Navigator.pop(context);
    }
  }
}
