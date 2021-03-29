import 'dart:io';
// import 'dart:async';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:recase/recase.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key key, @required this.title, @required this.link})
      : super(key: key);
  final String title;
  final String link;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading = true;
  // FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();
  // double lineProgress = 0.0;

  @override
  void initState() {
    super.initState();

    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

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
            // WebView(
            //   initialUrl: widget.link,
            //   //initialUrl: 'https://www.youtube.com/',
            //   javascriptMode: JavascriptMode.unrestricted,
            //   onPageFinished: (finish) {
            //     setState(() {
            //       isLoading = false;
            //     });
            //   },
            // ),
            isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    // value: progress == 1.0 ? 0 : progress,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
                  )
                : SizedBox(),
            PDF().cachedFromUrl(
              widget.link,
              placeholder: (progress) => Center(child: Text('$progress %')),
              errorWidget: (error) => Center(child: Text(error.toString())),
            )
          ],
        ),
      ),
    );
  }

  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.grey[300],
      // value: progress == 1.0 ? 0 : progress,
      valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
    );
  }
}
