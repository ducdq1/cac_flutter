import 'dart:io';
import 'dart:typed_data';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';

// import 'dart:async';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
//import 'package:webview_flutter/webview_flutter.dart';

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:recase/recase.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:share/share.dart';

// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_personal_page/input_datetime_widget.dart';
import 'package:citizen_app/features/common/dialogs/delete_confirm_dialog.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:citizen_app/features/common/widgets/inputs/text_field_custom.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:citizen_app/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:citizen_app/features/paht/data/models/media_picker_ios_model.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_issue_paht.dart';
import 'package:citizen_app/features/paht/presentation/bloc/category_paht_bloc/category_paht_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/create_issue_bloc/create_issue_bloc.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/approve_confirm_dialog.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/paht_list_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/quotation_detail_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

//import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../../../injection_container.dart';
import 'package:citizen_app/features/home/presentation/pages/web_view_page.dart';
import 'dart:math' as math;

class WebViewPage extends StatefulWidget {
  WebViewPage({Key key, @required this.title, @required this.link, this.model})
      : super(key: key);
  final String title;
  final String link;
  final PahtModel model;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>
    implements OnButtonClickListener {
  bool isLoading = true;
  bool downloading = true;
  String downloadingStr = "No data";
  double download = 0.0;
  File f;

  // FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();
  // double lineProgress = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseLayoutWidget(
        borderRadiusContent: 0,
        title: 'Bảng báo giá',
        body: Stack(
          children: [
            isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    // value: progress == 1.0 ? 0 : progress,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
                  )
                : SizedBox(),
            PDF().cachedFromUrl(widget.link,
                placeholder: (progress) => Center(child: Text('$progress %')),
                errorWidget: (error) => Center(child: Text(error.toString())),
                whenDone: (value) => {
                      // if (value != null) {
                      //   Fluttertoast.showToast(msg: value)
                      // }
                    }),
            widget.model.isInvalid != null && widget.model.isInvalid
                ? SizedBox()
                : Positioned.fill(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PrimaryButton(
                              label: 'Chia sẻ', ctx: this, id: 'share_btn'),
                        ))),
            widget.model.isInvalid != null && widget.model.isInvalid
                ? Positioned(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        IMAGE_ASSETS_PATH + 'huy_bg2.png',
                        fit: BoxFit.cover,
                        // height: 120,
                      ),
                    ),
                    // Align(
                    //     alignment: Alignment.center,
                    //     child:
                    //     Padding(
                    //       //padding: const EdgeInsets.only(bottom: 150.0),
                    //       child: Transform.rotate(
                    //         //angle: -math.pi / 4,
                    //         child: Text(
                    //           'HỦY   BÁO   GIÁ',
                    //           style: GoogleFonts.inter(
                    //               fontSize: 30,
                    //               color: Colors.red.withOpacity(0.5),
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //     )),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void saveImage(String value) async {
    //   Dio dio=Dio();
    //   var dir=await getApplicationDocumentsDirectory();
    //   f=File("${dir.path}/myimagepath.jpg");
    //   String fileName=widget.link.substring(widget.link.lastIndexOf("/")+1);
    //   dio.download(widget.link, "${dir.path}/$fileName",onReceiveProgress: (rec,total){
    //     setState(() {
    //       downloading=true;
    //       download=(rec/total)*100;
    //       print(fileName);
    //       downloadingStr="Downloading Image : "+(download).toStringAsFixed(0);
    //     });
    // });
  }

  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.grey[300],
      // value: progress == 1.0 ? 0 : progress,
      valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
    );
  }

  @override
  onClick(String id) async {
    if (id == 'share_btn') {
      await Share.share(widget.link);
    }
  }
}
