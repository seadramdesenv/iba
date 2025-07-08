class HeritageInsert {
  HeritageInsert({
    this.name = '',
    this.idStatusHeritage = '',
  });

  String name;
  String idStatusHeritage;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'idStatusHeritage': idStatusHeritage,
    };
  }
}
