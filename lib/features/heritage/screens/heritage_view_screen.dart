import 'package:flutter/material.dart';
import 'package:iba_member_app/controller/heritage_controller.dart';
import 'package:iba_member_app/service_locator.dart';

class HeritageViewScreen extends StatefulWidget {
  final String? id;

  const HeritageViewScreen({Key? key, this.id}) : super(key: key);

  @override
  State<HeritageViewScreen> createState() => _HeritageViewScreenState();
}

class _HeritageViewScreenState extends State<HeritageViewScreen> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _statusController;
  late bool _active;

  late List<Map<String, String>> _statusOptions = [];
  final controller = getIt<HeritageController>();

  Future<void> _loadStatus() async {
    final data = await controller.autoCompleteStatusApi();

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
    _loadStatus();
    // if (widget.id == '') {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _showPrintDialogOrNavigate();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patrimônio"),
      ),
      body: Center(
        child: widget.id != ''
            ? Text('Mostrando dados do patrimônio com ID: ${widget.id}')
            : const Text('Nenhum ID fornecido'),
      ),
    );
  }
}