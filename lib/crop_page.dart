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
  var _isBaseColor = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
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
class CropSample extends StatefulWidget {
  const CropSample(
      {super.key, required this.imageData, required this.isBaseColor});

  final Uint8List imageData;
  final bool isBaseColor;

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
                        onCropped: (croppedData) {
                          setState(() {
                            _croppedData = croppedData;
                            _isCropping = false;
                          });
                        },
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

enum CropEdit {
  crop,
  rotate,
  thumbnail,
}

class CropEditWidget extends StatelessWidget {
  const CropEditWidget({
    super.key,
    required this.edit,
    required this.editChildren,
  });

  final CropEdit edit;
  final List<Widget> editChildren;

  @override
  Widget build(BuildContext context) {
    if (edit == CropEdit.crop) {
      return Container(
        color: Colors.grey,
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: editChildren,
          ),
        ),
      );
    } else if (edit == CropEdit.rotate) {
      return Container(
        width: double.infinity,
        height: 70,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      );
    } else {
      return const SizedBox(
        height: 70,
      );
    }
  }
}

class CropButton extends StatelessWidget {
  const CropButton({
    super.key,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    required this.icon,
    required this.text,
    required this.color,
  });

  final Function()? onTap;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
          ),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
