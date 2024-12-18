import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PathUtil {
  static String? _userImagesPath;

  static const String _imageDir = 'images/';

  const PathUtil._();

  static Future<void> initialize() async {
    final directory = await getApplicationCacheDirectory();
    _userImagesPath = p.join(directory.path, _imageDir);
  }

  static String get userImagesPath {
    assert(_userImagesPath != null, 'PathUtil.initialize() must be called before using userImagesPath');
    return _userImagesPath!;
  }

}