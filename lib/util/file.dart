part of 'enter.dart';

class FileOperation {
  static Future<File?> selectFile(FileType type, List<String>? allowedExtensions) async {
    if ((await Permission.manageExternalStorage.request()).isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
      );
      if (result != null) {
        return File(result.files.single.path!);
      }
    }
    return null;
  }

  static Future<String?> saveImage(Uint8List imageBytes) async {
    if (false == (await Permission.manageExternalStorage.request()).isGranted) {
      return null;
    }

    try {
      Directory tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/example.png');
      await file.writeAsBytes(imageBytes);

      String targetPath = '/storage/emulated/0/Pictures/${Current.packageInfo.appName}';
      if (await Directory(targetPath).exists()) {
      } else {
        try {
          await Directory(targetPath).create(recursive: true);
        } catch (e) {
          return null;
        }
      }
      targetPath += '/${DateTime.now().millisecondsSinceEpoch}.png';
      await file.copy(targetPath);
      return targetPath;
    } catch (e) {
      return null;
    }
  }
}
