import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/form_controller.dart';
import '../../models/form_field_model.dart';

class DropDownWidget extends StatelessWidget {
  final Field field;
  final int index;

  const DropDownWidget({super.key, required this.field, required this.index});

  @override
  Widget build(BuildContext context) {
    var controller =  Get.find<FormController>();
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: field.metaInfo.label),
      value: controller.formData[index] as String,
      items: field.metaInfo.options!
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
      onChanged: (value) {
        Get.find<FormController>().updateField(index, value);
      },
    );
  }
}