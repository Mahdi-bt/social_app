import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatelessWidget {
  final String url;
  PdfView({Key? key, required this.url}) : super(key: key);
  PdfViewerController? pdfViewerController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SfPdfViewer.network(
        url,
        controller: pdfViewerController,
      ),
    );
  }
}
