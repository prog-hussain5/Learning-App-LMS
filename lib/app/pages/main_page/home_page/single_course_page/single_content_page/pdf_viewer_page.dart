import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';

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
  bool _hasError = false;  // ponytail: missing/failed pdf -> message instead of a blank page

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    _secureScreen();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ponytail: guard route args so a malformed push shows an error, not a crash/blank
      try {
        final args = ModalRoute.of(context)!.settings.arguments as List;
        path = args.isNotEmpty ? args[0] as String? : null;
        title = args.length > 1 ? args[1] as String? : null;
      } catch (_) {
        path = null;
      }
      if ((path ?? '').trim().isEmpty) {
        path = null;
        _hasError = true;
      }
      if (mounted) setState(() {});
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
        body: _hasError
            ? _errorState()
            : path != null
                ? SfPdfViewer.network(
                    path!,
                    key: _pdfViewerKey,
                    controller: pdfViewerController,
                    // ponytail: surface load failures (404 / expired / no access)
                    onDocumentLoadFailed: (details) {
                      if (mounted) setState(() => _hasError = true);
                    },
                  )
                : Center(child: loading()),
      ),
    );
  }

  // ponytail: explicit failure state for a pdf that can't be shown
  Widget _errorState() {
    return Center(
      child: Padding(
        padding: padding(),
        child: Text(
          appText.serverExceptionError,
          style: style14Regular().copyWith(color: greyA5),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    pdfViewerController.dispose();
    super.dispose();
  }
}
