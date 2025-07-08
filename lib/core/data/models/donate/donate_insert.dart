class DonateInsert {
  final String IdDonor;

  DonateInsert({
    required this.IdDonor,
  });

  Map<String, dynamic> toJson() {
    return {
      'IdDonor': IdDonor,
    };
  }

  factory DonateInsert.fromJson(Map<String, dynamic> json) {
    return DonateInsert(
        IdDonor: json['IdDonor'] ?? ""
    );
  }
}
