class HeritageGrid {
  HeritageGrid({
    this.id = '',
    this.code = '',
    this.name = '',
    this.status = '',
    this.active = '',
  });

  String id;
  String code;
  String name;
  String status;
  String active;

  factory HeritageGrid.fromJson(Map<String, dynamic> json) {
    return HeritageGrid(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      active: json['active'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'status': status,
      'active': active,
    };
  }
}