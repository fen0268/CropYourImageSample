import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imageProvider = NotifierProvider<ImageDataNotifier, File?>(
  ImageDataNotifier.new,
);

final imageDataProvider = FutureProvider<Uint8List?>((ref) async {
  final image = ref.watch(imageProvider);
  final assetData = await File(image!.path).readAsBytes();
  return assetData.buffer.asUint8List();
});

class ImageDataNotifier extends Notifier<File?> {
  @override
  File? build() {
    return null;
  }

  Future<void> pickImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final file = File(xFile.path);

    state = File(file.path);
  }

  Future<void> toImage(Uint8List imageData) async {
    final tempDir = Directory.systemTemp;
    final file = File('${tempDir.path}/image.png');
    file.writeAsBytesSync(imageData);
    state = File(file.path);
  }
}
