import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/form_controller.dart';
import '../../models/form_field_model.dart';

class EditTextWidget extends StatelessWidget {
  final Field field;
  final int index;

  const EditTextWidget({super.key, required this.field, required this.index});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FormController>();
    String current = controller.formData.containsKey(index)
        ? controller.formData[index]
        : "";
    return TextFormField(
      initialValue: current,
      decoration: InputDecoration(labelText: field.metaInfo.label),
      keyboardType: _getKeyboardType(),
      onChanged: (val) {
        controller.updateField(index, val);
      },
    );
  }

  TextInputType _getKeyboardType() {
    return field.metaInfo.componentInputType == "INTEGER"
        ? TextInputType.number
        : TextInputType.text;
  }
}
