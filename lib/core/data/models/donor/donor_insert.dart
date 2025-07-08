class DonorInsertRequest{
  final String idAddress;
  final String name;
  final String cpf;
  final String streetAddress;
  final String complementaryAddress;
  final String stateAddress;
  final String districtAddress;
  final String numberAddress;
  final String zipCode;

  DonorInsertRequest({
    required this.idAddress,
    required this.name,
    required this.cpf,
    required this.streetAddress,
    required this.complementaryAddress,
    required this.stateAddress,
    required this.numberAddress,
    required this.districtAddress,
    required this.zipCode
  });

  // factory DonorSearchResult.fromJson(Map<String, dynamic> json) {
  //   return DonorSearchResult(
  //       id: json['id'] ?? "",
  //       name: json['name'] ?? "",
  //       cpf: json['cpf'] ?? ""
  //   );
  // }
  Map<String, dynamic> toJson() {
    return {
      'idAddress': idAddress,
      'name': name,
      'cpf': cpf,
      'streetAddress': streetAddress,
      'complementaryAddress': complementaryAddress,
      'stateAddress': stateAddress,
      'numberAddress': numberAddress,
      'districtAddress': districtAddress,
      'zipCode': zipCode,
    };
  }
}