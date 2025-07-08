class DonateItemInsert {
  late String idDonate; // Agora pode ser atribuído depois
  final String idStatusHeritage;
  final String description;
  final int quantity;

  DonateItemInsert({
    required this.idDonate,
    required this.idStatusHeritage,
    required this.description,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'idDonate': idDonate,
      'idStatusHeritage': idStatusHeritage,
      'description': description,
      'quantity': quantity,
    };
  }

  factory DonateItemInsert.fromJson(Map<String, dynamic> json) {
    return DonateItemInsert(
      idDonate: json['idDonate'] ?? "",
      idStatusHeritage: json['idStatusHeritage'] ?? "",
      description: json['description'] ?? "",
      quantity: json['quantity'] ?? 1,
    );
  }
}