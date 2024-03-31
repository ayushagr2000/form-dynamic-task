import 'package:flutter/material.dart';
import 'package:form_sync_project/modules/dynamic_forms/models/form_field_model.dart';
import 'package:form_sync_project/utils/text_styles.dart';
import 'package:get/get.dart';

import '../../controllers/form_controller.dart';

class RadioGroupWidget extends StatelessWidget {
  final Field field;
  final int index;

  const RadioGroupWidget({super.key, required this.field, required this.index});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FormController>();
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
            .map((option) => RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: controller.formData[index],
                  onChanged: (value) {
                    Get.find<FormController>().updateField(index, value);
                  },
                ))
            .toList(),
      ],
    );
  }
}
