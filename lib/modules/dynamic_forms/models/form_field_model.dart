import 'meta_info_model.dart';

class Field {
  final String componentType;
  final MetaInfo metaInfo;

  Field({required this.componentType, required this.metaInfo});

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        componentType: json['component_type'],
        metaInfo: MetaInfo.fromJson(json['meta_info']),
      );
}