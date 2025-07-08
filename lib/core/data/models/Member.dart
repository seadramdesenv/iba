class Member {
  Member(
      {this.id = '',
      this.fullName = '',
      DateTime? birthdayDate,
      DateTime? dateTimeRegister,
      DateTime? memberSince,
      this.photo = '',
      this.active = true,
      this.idMaritalStatus = '',
      this.idAddress = '',
      this.sex = 'M',
      this.numberPhone = '',
      this.email = '',
      this.streetAddress = '',
      this.numberAddress = '',
      this.complementaryAddress = '',
      this.zipCode = '',
      this.cityAddress = '',
      this.districtAddress = '',
      this.stateAddress = ''})
      : birthdayDate = birthdayDate ?? DateTime(2000, 1, 1),
        dateTimeRegister = dateTimeRegister ?? DateTime.now(),
        memberSince = memberSince ?? DateTime.now();

  late String id;
  late String fullName;
  late DateTime birthdayDate;
  late DateTime dateTimeRegister;
  late DateTime memberSince;
  late String photo;
  late bool active;
  late String idMaritalStatus;
  late String idAddress;
  late String sex;
  late String numberPhone;
  late String email;
  late String streetAddress;
  late String numberAddress;
  late String complementaryAddress;
  late String zipCode;
  late String cityAddress;
  late String districtAddress;
  late String stateAddress;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'] ?? '',
        fullName: json['fullName'] ?? '',
        birthdayDate: json['birthdayDate'] != null ? DateTime.parse(json['birthdayDate']) : DateTime(2000, 1, 1),
        dateTimeRegister: json['dateTimeRegister'] != null ? DateTime.parse(json['dateTimeRegister']) : DateTime.now(),
        memberSince: json['memberSince'] != null ? DateTime.parse(json['memberSince']) : DateTime.now(),
        photo: json['photo'] ?? '',
        active: json['active'] ?? true,
        idMaritalStatus: json['idMaritalStatus'] ?? '',
        idAddress: json['idAddress'] ?? '',
        sex: json['sex'] ?? '',
        numberPhone: json['numberPhone'] ?? '',
        email: json['email'] ?? '',
        streetAddress: json['streetAddress'] ?? '',
        numberAddress: json['numberAddress'] ?? '',
        complementaryAddress: json['complementaryAddress'] ?? '',
        cityAddress: json['cityAddress'] ?? '',
        districtAddress: json['districtAddress'] ?? '',
        stateAddress: json['stateAddress'] ?? '',
        zipCode: json['zipCode'] ?? '',
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'birthdayDate': birthdayDate.toIso8601String(),
      'dateTimeRegister': dateTimeRegister.toIso8601String(),
      'memberSince': memberSince.toIso8601String(),
      'photo': photo,
      'active': active,
      'idMaritalStatus': idMaritalStatus,
      'idAddress': idAddress,
      'sex': sex,
      'numberPhone': numberPhone,
      'email': email,
      'streetAddress': streetAddress,
      'numberAddress': numberAddress,
      'complementaryAddress': complementaryAddress,
      'cityAddress': cityAddress,
      'districtAddress': districtAddress,
      'stateAddress': stateAddress,
      'zipCode': zipCode,
    };
  }
}
