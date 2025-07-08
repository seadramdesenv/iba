class DonateGrid {
  DonateGrid({
    this.id = '',
    this.donor = '',
    this.dateTimeRegister = '',
    this.quantytiItems = 0,
  });

  late String id;
  late String donor;
  late String dateTimeRegister;
  late int quantytiItems;

  factory DonateGrid.fromJson(Map<String, dynamic> json) {
    return DonateGrid(
      id: json['id'] ?? '',
      donor: json['donor'] ?? '',
      dateTimeRegister: json['dateTimeRegister'] ?? '',
      quantytiItems: json['quantytiItems'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'donor': donor,
      'dateTimeRegister': dateTimeRegister,
      'quantytiItems': quantytiItems,
    };
  }
}