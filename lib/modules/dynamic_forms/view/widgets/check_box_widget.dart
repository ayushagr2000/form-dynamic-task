
import 'package:flutter/material.dart';
import 'package:form_sync_project/utils/text_styles.dart';
import 'package:get/get.dart';

import '../../controllers/form_controller.dart';
import '../../models/form_field_model.dart';

class CheckBoxesWidget extends StatelessWidget {
  final Field field;
  final int index;

  const CheckBoxesWidget({super.key, required this.field, required this.index});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FormController>();
    List currentList = controller.formData.containsKey(index)
        ? controller.formData[index]
        : [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 20),
          child: Text(field.metaInfo.label,
          style: CustomTextStyle.headings,
          ),
        ),
        ...field.metaInfo.options!
            .map((option) => CheckboxListTile(
                  title: Text(option),
                  value: currentList.contains(option),
                  onChanged: (val) {
                    controller.updateCheckBoxValue(index: index, newState: val,optionValue: option);
                  },
                ))
            .toList(),
      ],
    );
  }
}