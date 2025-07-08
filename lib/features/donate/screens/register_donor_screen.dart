import 'package:flutter/material.dart';
import 'package:iba_member_app/core/data/address_service.dart';
import 'package:iba_member_app/core/data/models/donor/donor_insert.dart';
import 'package:iba_member_app/core/data/models/donor/donor_search_result.dart';
import 'package:iba_member_app/controller/donate_controller.dart';
import 'package:iba_member_app/service_locator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterDonorScreen extends StatefulWidget {
  final Function(DonorSearchResult) onRegister;

  RegisterDonorScreen({required this.onRegister});

  @override
  _RegisterDonorScreenState createState() => _RegisterDonorScreenState();
}

class _RegisterDonorScreenState extends State<RegisterDonorScreen> {
  final _formKey = GlobalKey<FormState>();
  final addressService = getIt<AddressService>();
  final controller = getIt<DonateController>();

  String name = '', cpf = '', zipCode = '', idAdress = '';

  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController _numberAddressController = TextEditingController();
  final TextEditingController _complementaryAddressController = TextEditingController();

  final maskFormatterCep = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  final maskFormatterCpf = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newDonor = await controller.insertDonor(DonorInsertRequest(
          idAddress: idAdress,
          name: name,
          cpf: cpf,
          streetAddress: streetController.text,
          complementaryAddress: _complementaryAddressController.text,
          stateAddress: stateController.text,
          numberAddress: _numberAddressController.text,
          districtAddress: districtController.text,
          zipCode: zipCode));
      widget.onRegister(newDonor);
    }
  }

  Future<void> _searchZipCode() async {
    String cep = zipCodeController.text.trim();
    if (cep.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite um Cep válido!")),
      );
      return;
    }
    try {
      var adss = await addressService.searchZipCode(cep);
      setState(() {
        idAdress = adss.id;
        stateController.text = adss.state;
        cityController.text = adss.city;
        districtController.text = adss.district;
        streetController.text = adss.street;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CEP não localizado!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Cadastro Doador",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? "Obrigatório" : null,
                  onSaved: (value) => name = value!,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  inputFormatters: [maskFormatterCpf],
                  decoration: const InputDecoration(
                    labelText: "CPF",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? "Obrigatório" : null,
                  onSaved: (value) => cpf = value!,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: zipCodeController,
                        inputFormatters: [maskFormatterCep],
                        decoration: const InputDecoration(
                          labelText: "Cep",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Obrigatório" : null,
                        onSaved: (value) => zipCode = value!,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          iconSize: 30,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          iconColor: Colors.black87,
                        ).copyWith(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        onPressed: _searchZipCode,
                        child: const Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: stateController,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cityController,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Cidade',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: districtController,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: streetController,
                  validator: (value) => value == null || value.isEmpty ? "Obrigatório" : null,
                  decoration: const InputDecoration(
                    labelText: 'Logradouro',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _numberAddressController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? "Obrigatório" : null,
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
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: _save,
              child: const Text(
                "Salvar",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
