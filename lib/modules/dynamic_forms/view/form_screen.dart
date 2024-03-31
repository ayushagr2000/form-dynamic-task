import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_sync_project/modules/dynamic_forms/models/form_field_model.dart';
import 'package:form_sync_project/services/hive/hive_helper.dart';
import 'package:get/get.dart';

import '../controllers/form_controller.dart';
import '../models/form_model.dart';

class FormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   

    return GetBuilder<FormController>(
      init: Get.put(FormController()), // Initialize controller on screen open
      builder: (controller) => Scaffold(
        appBar: AppBar(title: Text("Dynamic Form")),
        body: controller.formModel ==null? const Center(
          child: CircularProgressIndicator()
        ):DynamicFormWidget(formModel:  controller.formModel!),
      ),
    );
  }

}


class DynamicFormWidget extends StatelessWidget {
  final FormModel formModel;

  const DynamicFormWidget({required this.formModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
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
          ElevatedButton(onPressed: (){
            Get.find<FormController>().submitForm();
          }, child: Text("Submit")),
           ElevatedButton(onPressed: (){
           HiveHelper.getPendingRequests();
          }, child: Text("print pending")),
        ],
      ),
    );
  }

  Widget buildFormField(Field field, int index) {
    switch (field.componentType) {
      case "EditText":
        return EditTextWidget(field: field, index: index,);
      case "CheckBoxes":
        return CheckBoxesWidget(field: field, index: index);
      case "DropDown":
        return DropDownWidget(field: field, index: index,);
      case "RadioGroup":
        return RadioGroupWidget(field: field, index: index,);
      case "CaptureImages":
        return CaptureImagesWidget(field: field, index: index);
      default:
        return Text("Unsupported field type: ${field.componentType}");
    }
  }
}

class EditTextWidget extends StatelessWidget {
  final Field field;
  final int index;

  const EditTextWidget({required this.field, required this.index});

  @override
  Widget build(BuildContext context) {
      var controller = Get.find<FormController>();
    String current = controller.formData.containsKey(index) ? controller.formData[index] : "";
    return TextFormField(
      initialValue: current,
      decoration: InputDecoration(labelText: field.metaInfo.label),
      keyboardType: field.metaInfo.componentInputType  == "INTEGER" ? TextInputType.number : TextInputType.text,
      onChanged: (val){
    Get.find<FormController>().updateField(index, val);

      },
    );
  }
}

class CheckBoxesWidget extends StatelessWidget {
  final Field field;
  final int index;

  const CheckBoxesWidget({required this.field, required this.index});

  @override
  Widget build(BuildContext context) {
       var controller = Get.find<FormController>();
    List currentList = controller.formData.containsKey(index) ? controller.formData[index] : [];
    return Column(
      children: [
        Text(field.metaInfo.label),
        ...field.metaInfo.options!.map((option) => CheckboxListTile(
              title: Text(option),
                  value: currentList.contains(option),
              onChanged: (val)  {
             
var exisitingLists = [];
                if(controller.formData.containsKey(index)){

exisitingLists = controller.formData[index];
                }
if(val ?? false){
exisitingLists.add(option);
}else{
  exisitingLists.remove(option);
}
            
              controller.updateField(index, exisitingLists);
                
              },
            )).toList(),
      ],
    );
  }
}

class DropDownWidget extends StatelessWidget {
  final Field field;
  final int index;

  const DropDownWidget({required this.field, required this.index});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: field.metaInfo.label),
      value: Get.find<FormController>().formData[index] as String ,
      items: field.metaInfo.options!.map((option) => DropdownMenuItem(
            value:  option,
            child: Text(option),
          )).toList(),
      onChanged: (value) {
        Get.find<FormController>().updateField(index, value);
      },
    );
  }
}

class RadioGroupWidget extends StatelessWidget {
  final Field field;
  final int index;

  const RadioGroupWidget({required this.field, required this.index});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FormController>();
    return Column(
      children: [
        Text(field.metaInfo.label),
        ...field.metaInfo.options!.map((option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: controller.formData[index] ,
              onChanged: (value) {
                Get.find<FormController>().updateField(index, value);
              },
            )).toList(),
      ],
    );
  }
}

class CaptureImagesWidget extends StatelessWidget {
  final Field field;
  final int index;

   CaptureImagesWidget({required this.field, required this.index});

  final List<String?> _capturedImagePaths = [];

  @override
  Widget build(BuildContext context) {
    final noOfImagesToCapture =  3;
       var controller = Get.find<FormController>();
    Map currentList = controller.formData.containsKey(index) ? controller.formData[index] : {}; 

    return Column(
      children: [
        Text(field.metaInfo.label),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling
          crossAxisCount: 3,
     
          children: List.generate(noOfImagesToCapture, (imageIndex) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  // final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                 var pickedImage = await uploadImages();
                  if (pickedImage != null) {
                    Map existing = {};
                    if(controller.formData.containsKey(index)){
                      existing = controller.formData[index];
                    }
                    existing[imageIndex] = pickedImage.path;
                        
                    controller.updateField(index, existing);
                
                  }
                },
                child:
                 currentList.containsKey(imageIndex) 
                    ? Image.file(File(currentList[imageIndex]),fit: BoxFit.cover,) // Display captured image
                    : 
                    Container(
                        color: Colors.grey[200], // Placeholder for empty image slot
                        child: const Center(child: Icon(Icons.camera_alt)),
                      ),
              ),
            );
          }),
        ),
      ],
    );
  }
}