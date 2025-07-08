class AddressApi {
  final String id;
  final String district;
  final String city;
  final String state;
  final String street;

  AddressApi({
    required this.id,
    required this.district,
    required this.city,
    required this.state,
    required this.street,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district': district,
      'city': city,
      'state': state,
      'street': street,
    };
  }

  factory AddressApi.fromJson(Map<String, dynamic> json) {
    return AddressApi(
      id: json['id'] ?? "",
      district: json['district'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      street: json['street'] ?? "",
    );
  }
}
