
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/form_controller.dart';
import '../widgets/dynamic_form_widget.dart';
import 'logging.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(
      init: Get.put(FormController()),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text("Dynamic Form"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PendingRequestsList()));
                },
                child: const Text("Logs"))
          ],
        ),
        body: controller.formModel == null
            ? const Center(child: CircularProgressIndicator())
            : DynamicFormWidget(formModel: controller.formModel!),
      ),
    );
  }
}

