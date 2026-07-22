import 'dart:typed_data';

class FileUploadModel {
  final String name;
  final int size;
  final String? path;
  final Uint8List? bytes;
  final String format;

  FileUploadModel({
    required this.name,
    required this.size,
    this.path,
    this.bytes,
    required this.format,
  });
  
  bool get isWeb => bytes != null;
}
