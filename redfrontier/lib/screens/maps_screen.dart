import 'package:flutter/material.dart';
import 'package:redfrontier/common/dialogs.dart';
import 'package:redfrontier/common/widgets.dart';
import 'package:redfrontier/extensions/miscextensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          initialUrl:
              'https://murray-lab.caltech.edu/CTX/V01/SceneView/MurrayLabCTXmosaic.html',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            // You can use webViewController to control the WebView
          },
          onWebResourceError: (WebResourceError error) {
            // Callback when there is an error loading a page
            CustomDialogs.showDefaultAlertDialog(
              context,
              contentTitle: 'MapLoad Error',
              contentText: 'Could not load Interactive Mars Map',
            );
          },
        ),
        IgnorePointer(
          child: Container(
            margin: EdgeInsets.only(top: 0),
            color: Colors.red.withAlpha(60),
          ),
        ),
      ],
    );
  }
}
