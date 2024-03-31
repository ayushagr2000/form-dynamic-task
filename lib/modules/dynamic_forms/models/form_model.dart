
import 'form_field_model.dart';

class FormModel {
  final String formName;
  final List<Field> fields;

  FormModel({required this.formName, required this.fields});

  factory FormModel.fromJson(Map<String, dynamic> json) => FormModel(
        formName: json['form_name'],
        fields: (json['fields'] as List)
            .map((field) => Field.fromJson(field))
            .toList(),
      );
}