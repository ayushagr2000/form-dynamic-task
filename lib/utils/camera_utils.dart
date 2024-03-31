import 'package:image_picker/image_picker.dart';

class CameraUtils {
  static final CameraUtils _instance = CameraUtils._internal();
  static final ImagePicker _picker = ImagePicker();

  factory CameraUtils() {
    return _instance;
  }

  CameraUtils._internal();

  static Future<XFile?> pickImage({ImageSource source = ImageSource.camera}) async {
    XFile? file = await _picker.pickImage(source: source);
    return file;
  }

}