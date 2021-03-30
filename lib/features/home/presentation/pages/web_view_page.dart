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

class WebViewPage extends StatefulWidget {
  WebViewPage({Key key, @required this.title, @required this.link})
      : super(key: key);
  final String title;
  final String link;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>  implements OnButtonClickListener {
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

    // Enable hybrid composition.
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    // flutterWebViewPlugin.onProgressChanged.listen((progress) {
    //   print(progress);
    //   setState(() {
    //     lineProgress = progress;
    //   });
    // });
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
        title: widget.title.titleCase,
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
            Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PrimaryButton(
                          label: 'Chia sẻ', ctx: this, id: 'share_btn'),
                    ))),
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
