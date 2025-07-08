import 'package:flutter/material.dart';
import 'package:iba_member_app/core/data/models/donate/donate_insert.dart';
import 'package:iba_member_app/core/data/models/donate/donate_item_insert.dart';
import 'package:iba_member_app/core/data/status_heritage_service.dart';
import 'package:iba_member_app/controller/donate_controller.dart';
import 'package:iba_member_app/service_locator.dart';
import 'signature_screen.dart';

class DonationScreen extends StatefulWidget {
  final String donorId;

  DonationScreen({required this.donorId});

  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  List<DonateItemInsert> items = [];
  List<Map<String, String>> _statusOptions = [];
  final controller = getIt<DonateController>();

  final statusHeritageService = getIt<StatusHeritageService>();
  String? idStatus;
  String description = '';
  int quantity = 1;

  Future<void> _loadMaritalStatus() async {
    final data = await statusHeritageService.autoCompleteApi();
    setState(() {
      _statusOptions = data.map((item) => {"value": item.value, "label": item.label}).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMaritalStatus();
  }

  void _addItem() {
    setState(() {
      items.add(DonateItemInsert(idDonate: '', idStatusHeritage: idStatus!, description: description, quantity: quantity));
    });
  }

  void _openAddItemModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.5,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Descrição",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? "Obrigatório" : null,
                  onChanged: (value) => setState(() => description = value), // Atualiza imediatamente
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Quantidade",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? "Obrigatório" : null,
                  onChanged: (value) => setState(() => quantity = int.tryParse(value) ?? 0), // Atualiza imediatamente
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: idStatus,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Status",
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  ),
                  hint: const Text("Select"),
                  items: _statusOptions.map((status) {
                    return DropdownMenuItem<String>(
                      value: status["value"],
                      child: Text(status["label"]!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      idStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      _addItem();
                      Navigator.pop(context);
                    },
                    child: const Text("Salvar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _nextStep() async {
    var idDonate = await controller.insertDonate(DonateInsert(IdDonor: widget.donorId));

    await Future.wait(items.map((item) async {
      item.idDonate = idDonate;
      await controller.insertItemDonate(item);
    }));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignatureScreen(idDonate: idDonate)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doações")),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddItemModal,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: Key(item.description),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        items.removeAt(index); // Remove o item
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text("Quantidade: ${item.quantity}"),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: const Text("Assinar"),
              ),
            ),
            const SizedBox(height: 4)
          ],
        ),
      ),
    );
  }
}
