import 'package:dio/dio.dart';
import '../../modules/dynamic_forms/models/form_model.dart';
import 'api_end_points.dart';

class ApiService {
  static final Dio _dio = Dio();

  static Future<FormModel> getFormModel() async {
    print("getFormModel called");
    final response = await _dio.get(ApiEndpoints.getForm);
        print("getFormModel response" + response.data.toString());

    if (response.statusCode == 200) {
      print("Success");
      print(response.statusCode);
      return FormModel.fromJson(response.data);
    } else {
      throw Exception("Failed to get form data");
    }
  }

  static Future<void> submitResponse(Map<String, dynamic> data) async {
      try {
    
        final response = await _dio.post(
        ApiEndpoints.submitFormData,
          data: data,
        );
        print("Submit response rec " + response.data.toString());
        if (response.statusCode == 200) {
          print("Form data submitted successfully!");

        return Future.value(true);
        } else {
     
        }
      } catch (error) {
      
      }
  }
}