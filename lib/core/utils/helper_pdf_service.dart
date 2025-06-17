import 'dart:io';
import 'dart:developer';
import 'package:pdf/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:open_file_plus/open_file_plus.dart';


class HelperPdfService {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    try {
      final bytes = await pdf.save();

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');
      log("file: $file");
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      log("Failed to save document: $e");
      return Future.error("Failed to save document: $e");
    }
  }

  static Future openFile(File file) async {
  try {
    final uri = Uri.file(file.path);
    log("openFile: $uri");
    final success = await launchUrl(uri);
    if (!success) {
      throw Exception("Could not open file");
    }
  } catch (e) {
    log("Failed openFile: $e");
  }
}
}
