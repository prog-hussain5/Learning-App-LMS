import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';

import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';

class PdfViewerPage extends StatefulWidget {
  static const String pageName = '/pdf-viewer';
  const PdfViewerPage({super.key});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? title;
  String? path;

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    _secureScreen();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      path = (ModalRoute.of(context)!.settings.arguments as List)[0];
      title = (ModalRoute.of(context)!.settings.arguments as List)[1];
      setState(() {});
    });
  }

  Future<void> _secureScreen() async {
    if (Platform.isAndroid) {
      await FlutterWindowManagerPlus.addFlags(
        FlutterWindowManagerPlus.FLAG_SECURE,
      );
    }
    // iOS: placeholder
  }

  @override
  Widget build(BuildContext context) {
    return directionality(
      child: Scaffold(
        appBar: appbar(title: title ?? ''),
        body: path != null
            ? SfPdfViewer.network(
                path!,
                key: _pdfViewerKey,
                controller: pdfViewerController,
              )
            : const SizedBox(),
      ),
    );
  }

  @override
  void dispose() {
    pdfViewerController.dispose();
    super.dispose();
  }
}
