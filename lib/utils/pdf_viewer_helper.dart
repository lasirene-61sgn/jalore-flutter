import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../services/widget/custom_msg.dart';

class PdfViewerHelper {
  static Future<void> openOrDownloadPdf(BuildContext context, String urlString) async {
    final navigator = Navigator.of(context);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Downloading PDF..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      final response = await http.get(Uri.parse(urlString));
      
      // Pop loading dialog safely
      navigator.pop();

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final fileName = urlString.split('/').last;
        final file = File('${tempDir.path}/$fileName');
        
        await file.writeAsBytes(bytes);
        
        final result = await OpenFilex.open(file.path);
        
        if (result.type != ResultType.done) {
          Toaster.showError("Could not open PDF: ${result.message}");
        } else {
          Toaster.showSuccess("PDF opened successfully");
        }
      } else {
        Toaster.showError("Failed to download PDF (Status: ${response.statusCode})");
      }
    } catch (e) {
      // Pop loading dialog safely if error occurs
      try {
        navigator.pop();
      } catch (_) {}
      Toaster.showError("Error downloading PDF: $e");
    }
  }
}
