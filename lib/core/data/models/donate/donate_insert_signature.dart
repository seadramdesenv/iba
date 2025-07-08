class DonateInsertSignature {
  final String idDonate;
  final String signature;

  DonateInsertSignature({
    required this.idDonate,
    required this.signature,
  });

  Map<String, dynamic> toJson() {
    return {
      'idDonate': idDonate,
      'signature': signature,
    };
  }
}
