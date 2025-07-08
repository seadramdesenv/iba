class DonorSearchResult{
  final String id;
  final String name;
  final String cpf;

  DonorSearchResult({
    required this.id,
    required this.name,
    required this.cpf
  });

  factory DonorSearchResult.fromJson(Map<String, dynamic> json) {
    return DonorSearchResult(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      cpf: json['cpf'] ?? ""
    );
  }
}