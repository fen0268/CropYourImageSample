import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'crop_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Your Image'),
      ),
      body: const ImageSelect(),
    );
  }
}

class ImageSelect extends StatefulWidget {
  const ImageSelect({super.key});

  @override
  State<ImageSelect> createState() => _ImageSelectState();
}

class _ImageSelectState extends State<ImageSelect> {
  File? image;
  Uint8List? imageData;

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final file = File(xFile.path);
    image = File(file.path);
    if (image != null) {
      final assetData = await File(image!.path).readAsBytes();
      imageData = assetData.buffer.asUint8List();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null)
            Image.file(
              image!,
              width: 200,
              height: 200,
            ),
          ElevatedButton(
            onPressed: () {
              pickImage();
            },
            child: const Text('画像を選択'),
          ),
          image != null
              ? ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return CropPage(
                          imageData: imageData!,
                        );
                      },
                    ));
                  },
                  child: const Text('画像をトリミング'),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
