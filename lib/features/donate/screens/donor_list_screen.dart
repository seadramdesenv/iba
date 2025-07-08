import 'package:flutter/material.dart';
import 'package:iba_member_app/core/data/models/donor/donor_search_result.dart';
import 'package:iba_member_app/controller/donate_controller.dart';
import 'package:iba_member_app/features/donate/screens/donation_screen.dart';
import 'package:iba_member_app/service_locator.dart';
import 'register_donor_screen.dart';

class DonorListScreen extends StatefulWidget {
  @override
  _DonorListScreenState createState() => _DonorListScreenState();
}

class _DonorListScreenState extends State<DonorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final controller = getIt<DonateController>();
  List<DonorSearchResult> donors = [];

  void _fetchDonors() async {
    if (_searchController.text.length < 3) return;

    var result = await controller.searchDonor(_searchController.text);

    setState(() => donors = result);
  }

  void _selectDonor(DonorSearchResult donor) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DonationScreen(donorId: donor.id)),
    );
  }

  void _showRegistrationModal() {
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
          ),
          child: SingleChildScrollView(
            child: RegisterDonorScreen(
              onRegister: (newDonor) {
                Navigator.pop(context);
                _selectDonor(newDonor);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecione Doador")),
      body: Column(
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adiciona margem nas laterais
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _fetchDonors,
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: donors.length,
              itemBuilder: (context, index) {
                final donor = donors[index];
                return ListTile(
                  title: Text(donor.name),
                  onTap: () => _selectDonor(donor),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showRegistrationModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
