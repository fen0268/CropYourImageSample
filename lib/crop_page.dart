import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider/image_data_provider.dart';
import 'util/edit_enum.dart';
import 'widget/crop_button_widget.dart';
import 'widget/crop_edit_widget.dart';

class CropPage extends ConsumerStatefulWidget {
  const CropPage({super.key, required this.imageData});

  final Uint8List imageData;

  @override
  ConsumerState<CropPage> createState() => _CropPageState();
}

class _CropPageState extends ConsumerState<CropPage> {
  // 背景黒か白か
  var _isBaseColor = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        
        Navigator.of(context).pop();
      },
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crop Your Image'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isBaseColor = !_isBaseColor;
                });
              },
              icon: const Icon(Icons.abc),
            ),
          ],
        ),
        body: CropSample(
          imageData: widget.imageData,
          isBaseColor: _isBaseColor,
        ),
      ),
    );
  }
}

/// 切り取りクラス
class CropSample extends ConsumerStatefulWidget {
  const CropSample(
      {super.key, required this.imageData, required this.isBaseColor});

  final Uint8List imageData;
  final bool isBaseColor;

  @override
  ConsumerState<CropSample> createState() => CropSampleState();
}

class CropSampleState extends ConsumerState<CropSample> {
  /// コントローラー
  final _cropController = CropController();

  var _isThumbnail = false;
  var _isCropping = false;

  var _angle = 0.0;

  // 切り抜きデータ
  Uint8List? _croppedData;

  // enum
  CropEdit edit = CropEdit.crop;

  // 丸か否か
  bool _isCircle = false;

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
                      //
                      //
                      Crop(
                        baseColor:
                            widget.isBaseColor ? Colors.black : Colors.white,
                        willUpdateScale: (newScale) => newScale < 5,
                        controller: _cropController,
                        image: widget.imageData,
                        initialSize: 0.5,

                        // 切り抜き画像の背景色
                        maskColor: _isThumbnail ? Colors.black : null,
                        cornerDotBuilder: (size, edgeAlignment) =>
                            const SizedBox.shrink(),
                        interactive: true,
                        fixCropRect: true,

                        // 切り抜き画像の角丸
                        // TODO 自由に値を変更させる
                        radius: 0,
                        initialRectBuilder: (viewportRect, imageRect) {
                          return Rect.fromLTRB(
                            viewportRect.left + 24,
                            viewportRect.top + 24,
                            viewportRect.right - 24,
                            viewportRect.bottom - 24,
                          );
                        },
                        // 回転
                        angle: _angle,
                        onCropped: (croppedData) {
                          setState(() {
                            ref
                                .read(imageProvider.notifier)
                                .toImage(croppedData);
                            _isCropping = false;
                            debugPrint('Cropped: ${croppedData.length}');
                          });
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
                    ],
                  ),
                ),
              ),
              CropEditWidget(
                edit: edit,
                onDragging: (index, lowerValue, upperValue) {
                  _angle = lowerValue;
                  setState(() {});
                },
                editChildren: [
                  TextButton(
                    onPressed: () {
                      if (_isCircle) {
                        _isCircle = !_isCircle;
                        _cropController
                          ..withCircleUi = false
                          ..aspectRatio = 1 / 1;
                      }
                      _cropController.aspectRatio = 1 / 1;
                    },
                    child: const Text('1:1'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_isCircle) {
                        _isCircle = !_isCircle;
                        _cropController
                          ..withCircleUi = false
                          ..aspectRatio = 3 / 2;
                      }
                      _cropController.aspectRatio = 3 / 2;
                    },
                    child: const Text('3:2'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_isCircle) {
                        _isCircle = !_isCircle;
                        _cropController
                          ..withCircleUi = false
                          ..aspectRatio = 4 / 3;
                      }
                      _cropController.aspectRatio = 4 / 3;
                    },
                    child: const Text('4:3'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_isCircle) {
                        _isCircle = !_isCircle;
                        _cropController
                          ..withCircleUi = false
                          ..aspectRatio = 16 / 9;
                      }
                      _cropController.aspectRatio = 16 / 9;
                    },
                    child: const Text('16:9'),
                  ),
                  IconButton(
                      icon: const Icon(Icons.circle),
                      onPressed: () {
                        _isCircle = !_isCircle;
                        _cropController.withCircleUi = true;
                      }),
                ],
              ),
              Container(
                width: double.infinity,
                height: 90,
                color: const Color.fromARGB(255, 52, 49, 67),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 切り抜きの型
                    CropButton(
                      onTap: () {
                        setState(() {
                          edit = CropEdit.crop;
                        });
                      },
                      icon: Icons.crop,
                      text: '切り抜き',
                      color:
                          CropEdit.crop == edit ? Colors.orange : Colors.white,
                    ),
                    // 回転
                    CropButton(
                      onTap: () {
                        setState(() {
                          edit = CropEdit.rotate;
                        });
                      },
                      icon: Icons.crop_rotate,
                      text: '回転',
                      color: CropEdit.rotate == edit
                          ? Colors.orange
                          : Colors.white,
                    ),
                    // 切り抜きの見た目を確認
                    CropButton(
                      onTapDown: (_) => setState(() {
                        edit = CropEdit.thumbnail;
                        _cropController.crop();
                        _isThumbnail = true;
                      }),
                      onTapUp: (_) => setState(() {
                        edit = CropEdit.thumbnail;
                        _isThumbnail = false;
                      }),
                      icon: Icons.crop_free_rounded,
                      text: '見た目',
                      color: CropEdit.thumbnail == edit
                          ? Colors.orange
                          : Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
