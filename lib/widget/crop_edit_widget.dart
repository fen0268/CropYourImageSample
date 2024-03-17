import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import '../util/edit_enum.dart';

class CropEditWidget extends StatelessWidget {
  const CropEditWidget({
    super.key,
    required this.edit,
    required this.editChildren,
    this.onDragging,
  });

  final CropEdit edit;
  final List<Widget> editChildren;
  final Function(int, dynamic, dynamic)? onDragging;

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
        color: Colors.grey,
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: FlutterSlider(
            trackBar: FlutterSliderTrackBar(
              inactiveTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black12,
                border: Border.all(width: 3, color: Colors.blue),
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.blue.withOpacity(0.5)),
            ),
            min: 0,
            max: 360,
            values: const [0, 45, 90],
            onDragging: onDragging,
          ),
        ),
      );
    } else {
      return const SizedBox(
        height: 70,
      );
    }
  }
}
