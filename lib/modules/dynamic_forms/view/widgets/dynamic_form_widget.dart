
import 'package:flutter/material.dart';
import 'package:form_sync_project/modules/dynamic_forms/view/widgets/dynamic_form_fields.dart';

import 'package:get/get.dart';

import '../../../../services/hive/hive_helper.dart';
import '../../controllers/form_controller.dart';
import '../../models/form_field_model.dart';
import '../../models/form_model.dart';

class DynamicFormWidget extends StatelessWidget {
  final FormModel formModel;

  const DynamicFormWidget({super.key, required this.formModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(formModel.formName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
          ),
          Expanded(
            child: Form(
              child: ListView.builder(
                shrinkWrap: true, // Prevent excessive scrolling for short forms
                itemCount: formModel.fields.length,
                itemBuilder: (context, index) {
                  final field = formModel.fields[index];
                  return buildFormField(field, index);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.pink)),
                onPressed: () {
                  Get.find<FormController>().submitForm();
                },
                child: const Text("Submit response",
                style: TextStyle(fontSize: 18,color: Colors.white),
                )),
          ),
        
        ],
      ),
    );
  }

  Widget buildFormField(Field field, int index) {
    switch (field.componentType) {
      case "EditText":
        return EditTextWidget(
          field: field,
          index: index,
        );
      case "CheckBoxes":
        return CheckBoxesWidget(field: field, index: index);
      case "DropDown":
        return DropDownWidget(
          field: field,
          index: index,
        );
      case "RadioGroup":
        return RadioGroupWidget(
          field: field,
          index: index,
        );
      case "CaptureImages":
        return CaptureImagesWidget(field: field, index: index);
      default:
        return Text("Unsupported field type: ${field.componentType}");
    }
  }
}