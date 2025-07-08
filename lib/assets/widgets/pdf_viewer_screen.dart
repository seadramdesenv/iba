import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uuid/uuid.dart';

class PdfViewerScreen extends StatelessWidget {
  final Uint8List pdfBytes;
  final String titleScreen;

  const PdfViewerScreen({
    Key? key,
    required this.pdfBytes,
    this.titleScreen = '',
  }) : super(key: key);

  Future<void> sharePdf(Uint8List pdfBytes, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName.pdf');
    await file.writeAsBytes(pdfBytes);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titleScreen)),
      body: SfPdfViewer.memory(pdfBytes),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          sharePdf(pdfBytes, const Uuid().v4());
        },
        child: const Icon(Icons.share),
      ),
    );
  }
}
