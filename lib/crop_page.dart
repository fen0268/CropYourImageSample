import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CropPage extends StatefulWidget {
  const CropPage({super.key, required this.imageData});

  final Uint8List imageData;

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Your Image'),
      ),
      body: CropSample(
        imageData: widget.imageData,
      ),
    );
  }
}

/// 切り取りクラス
class CropSample extends StatefulWidget {
  const CropSample({super.key, required this.imageData});

  final Uint8List imageData;

  @override
  CropSampleState createState() => CropSampleState();
}

class CropSampleState extends State<CropSample> {
  /// コントローラー
  final _cropController = CropController();

  var _isThumbnail = false;
  var _isCropping = false;

  // 切り抜きデータ
  Uint8List? _croppedData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Visibility(
          visible: !_isCropping,
          replacement: const CircularProgressIndicator(),
          child: Column(
            children: [
              Expanded(
                child: Visibility(
                  visible: _croppedData == null,
                  replacement: Center(
                    child: _croppedData == null
                        ? const SizedBox.shrink()
                        : Image.memory(_croppedData!),
                  ),
                  child: Stack(
                    children: [
                      Crop(
                        willUpdateScale: (newScale) => newScale < 5,
                        controller: _cropController,
                        image: widget.imageData,
                        onCropped: (croppedData) {
                          setState(() {
                            _croppedData = croppedData;
                            _isCropping = false;
                          });
                        },
                        initialSize: 0.5,
                        maskColor: _isThumbnail ? Colors.white : null,
                        cornerDotBuilder: (size, edgeAlignment) =>
                            const SizedBox.shrink(),
                        interactive: true,
                        fixCropRect: true,
                        radius: 20,
                        initialRectBuilder: (viewportRect, imageRect) {
                          return Rect.fromLTRB(
                            viewportRect.left + 24,
                            viewportRect.top + 24,
                            viewportRect.right - 24,
                            viewportRect.bottom - 24,
                          );
                        },
                      ),
                      IgnorePointer(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: GestureDetector(
                          onTapDown: (_) => setState(() => _isThumbnail = true),
                          onTapUp: (_) => setState(() => _isThumbnail = false),
                          child: CircleAvatar(
                            backgroundColor: _isThumbnail
                                ? Colors.blue.shade50
                                : Colors.blue,
                            child: const Center(
                              child: Icon(Icons.crop_free_rounded),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_croppedData == null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.crop_7_5),
                            onPressed: () {
                              _cropController.aspectRatio = 16 / 4;
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.crop_16_9),
                            onPressed: () {
                              _cropController.aspectRatio = 16 / 9;
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.crop_5_4),
                            onPressed: () {
                              _cropController.aspectRatio = 4 / 3;
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.crop_square),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.circle),
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isCropping = true;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text('CROP IT!'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
