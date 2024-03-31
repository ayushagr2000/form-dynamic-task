import 'package:flutter/material.dart';
import 'package:form_sync_project/services/API/api_end_points.dart';
import 'package:form_sync_project/services/hive/hive_helper.dart';
import 'package:form_sync_project/utils/camera_utils.dart';
import 'package:get/get.dart';

import '../../../services/API/api_services.dart';
import '../../../services/connectivity/connectivity_controller.dart';
import '../models/form_model.dart';

class FormController extends GetxController {
  FormModel? _formModel;
  FormModel? get formModel => _formModel;

  @override
  onInit() {
    super.onInit();
    fetchDynamicFormFields();
  }

  Future<void> fetchDynamicFormFields() async {
    try {
      final data = await ApiService.getFormModel();
      data.fold((l) {
        Get.snackbar('Oops', l.message);
      }, (data) {
        _formModel = data;
        initalDataSet();

        update();
      });
    } catch (error) {
      print(error);
    }
  }

  void initalDataSet() {
    _formData = {};
    for (int i = 0; i < _formModel!.fields.length; i++) {
      var feild = _formModel!.fields[i];
      if (feild.componentType == "DropDown" &&
          (feild.metaInfo.options?.isNotEmpty ?? false)) {
        _formData[i] = feild.metaInfo.options![0];
      }
    }
    update();
  }

  Map<int, dynamic> _formData = {};
  Map<int, dynamic> get formData => _formData;

  void updateField(int index, dynamic value) {
    _formData[index] = value;
    update();
  }

  bool validateForm() {
    if (formModel == null) return false;

    List<String> missingElements = [];
    for (int i = 0; i < formModel!.fields.length; i++) {
      final field = formModel!.fields[i];
      if (field.metaInfo.mandatory && !_formData.containsKey(i)) {
        missingElements.add(field.metaInfo.label);
      }
    }

    if (missingElements.isNotEmpty) {
      Get.snackbar('Please fill all details', "Missing: $missingElements",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blueGrey);
      return false;
    }
    return true;
  }

  void updateCheckBoxValue(
      {required int index,
      required bool? newState,
      required String optionValue}) {
    var exisitingLists = [];
    if (formData.containsKey(index)) {
      exisitingLists = formData[index];
    }
    if (newState ?? false) {
      exisitingLists.add(optionValue);
    } else {
      exisitingLists.remove(optionValue);
    }
    updateField(index, exisitingLists);
  }

  Future<void> submitForm() async {
    if (validateForm()) {
      final connectivityController = Get.find<ConnectivityController>();
      print(connectivityController.isConnected);
      connectivityController.checkConnectivity().then((res) {
        print(res);
      });

      if (connectivityController.isConnected) {
        await sendToServer();
      } else {
        await saveInHive();
      }
      initalDataSet();
    }
  }

  Future<void> sendToServer() async {
    var body = convertFormDataBodyToFormat();
    await ApiService.submitResponse(body).then((value) {
      value.fold((l) {
        Get.snackbar("Opps! Error", l.message,
            snackPosition: SnackPosition.BOTTOM);
      }, (r) {
        Get.snackbar("Done", "Submitted!", snackPosition: SnackPosition.BOTTOM);
      });
    });
  }

  Future<void> saveInHive() async {
    var body = convertFormDataBodyToFormat();
    await HiveHelper.addPendingRequest(ApiEndpoints.submitFormData, body);
    Get.snackbar("Offline", "Form data saved offline for submission later.",
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> handlePickImage(
      {required int index, required int imageIndex}) async {
    var pickedImage = await CameraUtils.pickImage();
    if (pickedImage != null) {
      Map existing = {};
      if (formData.containsKey(index)) {
        existing = formData[index];
      }
      existing[imageIndex] = pickedImage.path;
      updateField(index, existing);
    }
  }

  Map<String, dynamic> convertFormDataBodyToFormat() {
    final List<Map<String, dynamic>> data = [];

    for (int i = 0; i < formModel!.fields.length; i++) {
      if (formData.containsKey(i)) {
        final field = formModel!.fields[i];

        if (field.componentType == 'CaptureImages') {
          List<String> finalImages = [];
          var images = formData[i];
          images.forEach((key, value) {
            finalImages.add(value);
          });

          data.add({formModel!.fields[i].metaInfo.label: finalImages});
        } else {
          data.add({formModel!.fields[i].metaInfo.label: formData[i]});
        }
      }
    }
    return {"data": data};
  }
}
