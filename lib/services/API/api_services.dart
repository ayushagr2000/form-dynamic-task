import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../modules/dynamic_forms/models/form_model.dart';
import 'api_end_points.dart';


class ApiService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  static void setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("--> ${options.method} ${options.path}");
        print("Headers: ${options.headers}");
        print("Body: ${options.data}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("<-- ${response.statusCode} ${response.requestOptions.path}");
        print("Response: ${response.data}");
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        print("<-- Error --> ${e.message}");
        return handler.next(e);
      },
    ));
  }

  static Future<Either<ErrorModel, FormModel>> getFormModel() async {
    try {
      final response = await _dio.get(ApiEndpoints.getForm);
     

      if (response.statusCode == 200) {
        return Right(FormModel.fromJson(response.data));
      } else {
        return Left(ErrorModel("Failed to get form data"));
      }
    } catch (e) {
      return Left(ErrorModel("Failed to get form data"));
    }
  }

  static Future<Either<ErrorModel, Unit>> submitResponse(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiEndpoints.submitFormData, data: data);
      if (response.statusCode == 201) {
        print("Form data submitted successfully!");
        return const Right(unit);
      } else {
        return Left(ErrorModel("Failed to submit form data"));
      }
    } catch (e) {
      print("Error in submitResponse: $e");
      return Left(ErrorModel("Failed to submit form data"));
    }
  }
}


class ErrorModel {
  final String message;

  ErrorModel(this.message);
}