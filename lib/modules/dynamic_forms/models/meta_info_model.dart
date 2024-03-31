class MetaInfo {
  final String label;
  final String? componentInputType;
  final bool mandatory;
  final List<String>? options;
  final int? noOfImagesToCapture;
  final String? savingFolder;

  MetaInfo({
     required this.label,
     this.componentInputType,
    required this.mandatory,
    this.options,
    this.noOfImagesToCapture,
    this.savingFolder,
  });

  factory MetaInfo.fromJson(Map<String, dynamic> json) {
    return MetaInfo(
        label: json['label'],
        componentInputType: json['component_input_type'],
        mandatory: json['mandatory'] == 'yes',
        options: json['options']?.cast<String>(),
        noOfImagesToCapture: json['no_of_images_to_capture'],
        savingFolder: json['saving_folder'],
      );
  }
}