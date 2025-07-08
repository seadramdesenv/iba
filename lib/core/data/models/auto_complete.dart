class AutoCompleteApi {
  AutoCompleteApi({
    this.label = '',
    this.value = ''
  });

  late String value;
  late String label;

  factory AutoCompleteApi.fromJson(Map<String, dynamic> json) => AutoCompleteApi(
    label: json['label'] ?? '',
    value: json['value'] ?? '',
  );
}