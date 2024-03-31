import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_sync_project/utils/text_styles.dart';
import 'package:get/get.dart';

import '../../controllers/form_controller.dart';
import '../../models/form_field_model.dart';

class CaptureImagesWidget extends StatelessWidget {
  final Field field;
  final int index;

  const CaptureImagesWidget({super.key, required this.field, required this.index});

  @override
  Widget build(BuildContext context) {
    final noOfImagesToCapture = field.metaInfo.noOfImagesToCapture ?? 1;
    var controller = Get.find<FormController>();
    Map currentList = controller.formData.containsKey(index)
        ? controller.formData[index]
        : {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
              Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 20),
          child: Text(field.metaInfo.label,
          style: CustomTextStyle.headings,
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          children: List.generate(noOfImagesToCapture, (imageIndex) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
              controller.handlePickImage(index: index,imageIndex: imageIndex);
                },
                child: currentList.containsKey(imageIndex)
                    ? renderImage(currentList, imageIndex)
                    : renderImageUploadCTA(),
              ),
            );
          }),
        ),
      ],
    );
  }

  Container renderImageUploadCTA() {
    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.camera_alt)),
                    );
  }

  Image renderImage(Map<dynamic, dynamic> currentList, int imageIndex) {
    return Image.file(
                      File(currentList[imageIndex]),
                      fit: BoxFit.cover,
                    );
  }
}
