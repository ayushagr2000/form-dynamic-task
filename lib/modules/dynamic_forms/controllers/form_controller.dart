
import 'package:flutter/material.dart';
import 'package:form_sync_project/services/API/api_end_points.dart';
import 'package:form_sync_project/services/hive/hive_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/API/api_services.dart';
import '../../../services/connectivity/connectivity_controller.dart';
import '../models/form_model.dart';

class FormController extends GetxController {
  FormModel? _formModel;
  FormModel? get formModel => _formModel;

  @override
  onInit()
{
  super.onInit();
  fetchForm();
}
  Future<void> fetchForm() async {
    try {
      final data = await ApiService.getFormModel();
      _formModel = data;
      for (int i =0; i< _formModel!.fields.length; i++) {

        var feild =  _formModel!.fields[i];
if(feild.componentType == "DropDown" && (feild.metaInfo.options?.isNotEmpty ?? false)){
  _formData[i] = feild.metaInfo.options![0];
}
      }
      update(); // Trigger UI update after successful data fetch
    } catch (error) {
      // Handle API call error (e.g., show a snackbar)
      print(error);
    }
  }



  final Map<int, dynamic> _formData = {};
  Map<int, dynamic> get formData => _formData;

    String _errorMessage = '';
  String get errorMessage => _errorMessage;

 void updateField(int index, dynamic value) {
    _formData[index] = value;

    update();
  }

  bool validateForm() {
    if (formModel == null) return false;

List<String> missingElements = [];
    for (int i=0;i< formModel!.fields.length;i++) {

      final field = formModel!.fields[i];
      if (field.metaInfo.mandatory && !_formData.containsKey(i)) {
        _errorMessage = "Missing input for mandatory field: ${field.metaInfo.label}";
  
        missingElements.add(field.metaInfo.label);
     
              print(_errorMessage);
     
      }
  
 
 
    }

    if(missingElements.isNotEmpty){
    print(missingElements);
       Get.snackbar('Please fill all details',"Missing: $missingElements",snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.blueGrey);
        return false;
      }
    return true;
  }

  Future<void> submitForm() async {

    if (validateForm()) {
      Map<String, dynamic> body = prepareData();

final connectivityController = Get.find<ConnectivityController>();

   
      if (connectivityController.isConnected) {
   


      print("About to send " + body.toString());


 ApiService.submitResponse(body);
      } else {
        // Offline - Store in Hive
        await HiveHelper.addPendingRequest(
          ApiEndpoints.submitFormData, // Adjust URL
          body, // Replace with actual form data
        );
        // Show a message indicating offline storage
        Get.snackbar("Offline", "Form data saved offline for submission later.", snackPosition: SnackPosition.BOTTOM);
      }



    } else {
      print("Validation failed");
    }
  }

  Map<String, dynamic> prepareData(){
      final List<Map<String, dynamic>> data = [];

       for (int i=0;i< formModel!.fields.length;i++) {
        if(formData.containsKey(i)){
       final field = formModel!.fields[i];
      
      if(field.componentType == 'CaptureImages'){
        List<String> finalImages = [];
        var images = formData[i];
        images.forEach((key, value) {
finalImages.add(value);
        });

        data.add({formModel!.fields[i].metaInfo.label: finalImages});
      }else{
            data.add({formModel!.fields[i].metaInfo.label: formData[i]}); 
      }
      
      
      }
    
        }
      return {"data": data };
  }


}


Future<XFile?> uploadImages() async{
  
   final ImagePicker picker = ImagePicker();
  XFile? file = await picker.pickImage(source: ImageSource.gallery);

  if(file !=null){
      print("Operation image: Image picked");
      return file;

  }
  return null;

}

// uploadImagesToAWS(String path) async {
//   // print("Operation imagee: Ready to upload Path: " + path );
//    var pathUrl;
//   try {
//       pathUrl =  await AwsS3.uploadFile(
//   accessKey: "AKIARUYJYFCSRJUWGKQY",
//   secretKey: "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",
//   file: File(path),
//   bucket: "assignments-list",
//   region: "ap-south-1",
//   metadata: {"test": "ayush"} // optional
// );
//   } catch (e) {
// // print("Operation image: error " +e.toString());

//   }
  

// print("Operation image: upload await over");
// print("Operation image: PAth url is" + pathUrl.toString());
// print(pathUrl);
// }
