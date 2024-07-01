import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class FlutterImageCompressUtil {
  static Future<Uint8List?> angleCorrect(String imagePath,
      {int minWidth = 1920, int minHeight = 1080}) async {
    return await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: minWidth,
      minHeight: minHeight,
      rotate: 0,
      quality: 100,
      keepExif: false,
      autoCorrectionAngle: true,
      format: CompressFormat.jpeg,
    );
  }

  static Future<Uint8List?> compress(String imagePath,
      {int minWidth = 1920, int minHeight = 1080}) async {
    return await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: 100,
      format: CompressFormat.jpeg,
    );
  }
}
