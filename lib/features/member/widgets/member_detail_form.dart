import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:iba_member_app/core/data/address_service.dart';
import 'package:iba_member_app/core/data/marital_status_service.dart';
import 'package:iba_member_app/core/data/models/Member.dart';
import 'package:iba_member_app/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MemberDetailForm extends StatefulWidget {
  const MemberDetailForm({super.key, required this.member, required this.onFormSubmit});

  final Member member;
  final Function(Member) onFormSubmit;

  @override
  State<MemberDetailForm> createState() => _MemberDetailFormState();
}

class _MemberDetailFormState extends State<MemberDetailForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late DateTime _birthdayDate;
  late DateTime _sinceDate;
  late bool _active;
  late TextEditingController _birthdayDateController;
  late TextEditingController _memberSinceDateController;
  late TextEditingController _numberPhoneController;
  late TextEditingController _emailController;
  late TextEditingController _streetController;
  late TextEditingController _numberAddressController;
  late TextEditingController _complementaryAddressController;
  late TextEditingController _zipCodeController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;
  late TextEditingController _sexController;
  late TextEditingController _maritalStatusController;
  late TextEditingController _idAddressStatusController;

  final maritalService = getIt<MaritalStatusService>();
  final addressService = getIt<AddressService>();

  late List<Map<String, String>> _statusOptions = [];

  Future<void> _loadMaritalStatus() async {
    final data = await maritalService.autoCompleteApi();

    setState(() {
      _statusOptions = data
          .map((item) => {
                "value": item.value,
                "label": item.label,
              })
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMaritalStatus();

    _fullNameController = TextEditingController(text: widget.member.fullName);
    _birthdayDate = widget.member.birthdayDate;
    _sinceDate = widget.member.memberSince;
    _active = widget.member.active;
    _numberPhoneController = TextEditingController(text: widget.member.numberPhone);
    _emailController = TextEditingController(text: widget.member.email);
    _streetController = TextEditingController(text: widget.member.streetAddress);
    _numberAddressController = TextEditingController(text: widget.member.numberAddress);
    _complementaryAddressController = TextEditingController(text: widget.member.complementaryAddress);
    _zipCodeController = TextEditingController(text: widget.member.zipCode);
    _cityController = TextEditingController(text: widget.member.cityAddress);
    _stateController = TextEditingController(text: widget.member.stateAddress);
    _districtController = TextEditingController(text: widget.member.districtAddress);
    _sexController = TextEditingController(text: widget.member.sex);
    _maritalStatusController = TextEditingController(text: widget.member.idMaritalStatus);
    _idAddressStatusController = TextEditingController(text: widget.member.idAddress);
    _cityController = TextEditingController(text: widget.member.cityAddress);
    _districtController = TextEditingController(text: widget.member.districtAddress);
    _stateController = TextEditingController(text: widget.member.stateAddress);
    _streetController = TextEditingController(text: widget.member.streetAddress);
    _complementaryAddressController = TextEditingController(text: widget.member.complementaryAddress);

    _birthdayDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_birthdayDate),
    );

    _memberSinceDateController = TextEditingController(
      text: DateFormat('MM/yyyy').format(_sinceDate),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthdayDateController.dispose();
    _memberSinceDateController.dispose();
    _numberPhoneController.dispose();
    _sexController.dispose();
    _maritalStatusController.dispose();
    _idAddressStatusController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _streetController.dispose();
    _emailController.dispose();
    _complementaryAddressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var member = Member(
        fullName: _fullNameController.text,
        birthdayDate: _birthdayDate,
        photo: '',
        active: _active,
        numberPhone: _numberPhoneController.text,
        sex: _sexController.text,
        idMaritalStatus: _maritalStatusController.text,
        idAddress: _idAddressStatusController.text,
        cityAddress: _cityController.text,
        districtAddress: _districtController.text,
        stateAddress: _stateController.text,
        streetAddress: _streetController.text,
        email: _emailController.text,
        numberAddress: _numberAddressController.text,
        complementaryAddress: _complementaryAddressController.text,
        memberSince: _sinceDate,
      );

      widget.onFormSubmit(member);
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      titleText: "Selecione Data",
      confirmText: "Confirmar",
      cancelText: "Cancelar",
      initialDate: _birthdayDate,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.pt_br,
      backgroundColor: Theme.of(context).colorScheme.background,
      textColor: Theme.of(context).colorScheme.secondary,
      looping: true,
    );

    if (datePicked != null && datePicked != _birthdayDate) {
      setState(() {
        _birthdayDate = datePicked;
        _birthdayDateController.text = DateFormat('dd/MM/yyyy').format(datePicked);
      });
    }
  }

  Future<void> _selectSinceDate(BuildContext context) async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      titleText: "Selecione Data",
      confirmText: "Confirmar",
      cancelText: "Cancelar",
      initialDate: _birthdayDate,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      dateFormat: "MMMM-yyyy",
      locale: DateTimePickerLocale.pt_br,
      backgroundColor: Theme.of(context).colorScheme.background,
      textColor: Theme.of(context).colorScheme.secondary,
      looping: true,
    );

    if (datePicked != null && datePicked != _birthdayDate) {
      setState(() {
        _sinceDate = datePicked;
        _memberSinceDateController.text = DateFormat('MM/yyyy').format(datePicked);
      });
    }
  }

  final maskFormatter = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final maskFormatterCep = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  Future<void> _searchZipCode() async {
    String zipCode = _zipCodeController.text.trim();
    if (!zipCode.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite um ZIP Code válido!")),
      );
      return;
    }
    try {
      var adss = await addressService.searchZipCode(_zipCodeController.text.trim());
      setState(() {
        _idAddressStatusController.text = adss.id;
        _cityController.text = adss.city;
        _districtController.text = adss.district;
        _stateController.text = adss.state;
        _streetController.text = adss.street;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cep nāo localizado!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectBirthDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthdayDateController,
                    decoration: const InputDecoration(
                      labelText: 'Data de Nascimento',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectSinceDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _memberSinceDateController,
                    decoration: const InputDecoration(
                      labelText: 'Membro desde',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_view_month),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberPhoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [maskFormatter],
                decoration: const InputDecoration(
                  labelText: 'Telefone Celular',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe seu telefone';
                  } else if (value.length < 15) {
                    return 'Número incompleto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 14, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Gênero", style: TextStyle(fontSize: 16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: const Text("Masculino"),
                          selected: _sexController.text == "m",
                          selectedColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            side: BorderSide(
                              color: _sexController.text == "m" ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _sexController.text = "m";
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text("Feminino"),
                          selected: _sexController.text == "f",
                          selectedColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            side: BorderSide(
                              color: _sexController.text == "f" ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _sexController.text = "f";
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _statusOptions.any((status) => status["value"] == _maritalStatusController.text) ? _maritalStatusController.text : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Estado Civil",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
                hint: const Text("Selecione"),
                items: _statusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status["value"],
                    child: Text(status["label"]!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _maritalStatusController.text = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _zipCodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [maskFormatterCep],
                      decoration: const InputDecoration(
                        labelText: 'CEP',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _searchZipCode,
                      style: ElevatedButton.styleFrom(
                        iconSize: 30,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        iconColor: Colors.black87,
                      ).copyWith(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      child: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stateController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _districtController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Logradouro',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberAddressController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Numero',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _complementaryAddressController,
                decoration: const InputDecoration(
                  labelText: 'Complemento',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Ativo'),
                value: _active,
                onChanged: (value) {
                  setState(() {
                    _active = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Salvar'),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
