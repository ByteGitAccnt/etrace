import 'dart:io';
import 'dart:typed_data';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class PdfService {
  PdfService._();

  /// Saves the PDF into the app's documents directory.
  static Future<File> saveReport(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File("${directory.path}/$fileName");

    await file.writeAsBytes(bytes, flush: true);

    return file;
  }

  /// Opens the saved PDF using the default PDF viewer.
  static Future<void> openReport(File file) async {
    final result = await OpenFilex.open(file.path);

    if (result.type != ResultType.done) {
      throw Exception(result.message);
    }
  }

  static Future<void> saveAndOpenReport(
    Uint8List bytes,
    String fileName,
  ) async {
    final file = await saveReport(bytes, fileName);
    await openReport(file);
  }
}
