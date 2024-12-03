import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class OcPdfPage extends StatefulWidget {
  const OcPdfPage({super.key, required this.file});
  final String file;
  static const String route = '/oc-pdf=page';

  @override
  State<OcPdfPage> createState() => _OcPdfPageState();
}

class _OcPdfPageState extends State<OcPdfPage> {
  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: widget.file,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: true,
      pageSnap: true,
      fitPolicy: FitPolicy.BOTH,
      preventLinkNavigation: false,
    );
  }
}
