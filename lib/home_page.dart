import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'crop_page.dart';
import 'provider/image_data_provider.dart';

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

class ImageSelect extends ConsumerStatefulWidget {
  const ImageSelect({super.key});

  @override
  ConsumerState<ImageSelect> createState() => _ImageSelectState();
}

class _ImageSelectState extends ConsumerState<ImageSelect> {
  @override
  Widget build(BuildContext context) {
    final image = ref.watch(imageProvider);
    // final imageData = ref.read(imageProvider.notifier).imageData;
    final imageData = ref.watch(imageDataProvider).asData?.value;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null)
            Image.file(
              image,
              width: 200,
              height: 200,
            ),
          ElevatedButton(
            onPressed: () {
              ref.read(imageProvider.notifier).pickImage();
            },
            child: const Text('画像を選択'),
          ),
          image != null
              ? ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        if (imageData != null) {
                          return CropPage(imageData: imageData);
                        }
                        return const SizedBox();
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
