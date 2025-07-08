import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iba_member_app/core/data/models/donate/donate_insert_signature.dart';
import 'package:iba_member_app/controller/donate_controller.dart';
import 'package:iba_member_app/service_locator.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  final String idDonate;

  SignatureScreen({required this.idDonate});

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final controller = getIt<DonateController>();

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSignature() {
    _controller.clear();
  }

  Future<void> _saveSignature() async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, assine antes de salvar!")),
      );
      return;
    }

    Uint8List? signatureBytes = await _controller.toPngBytes();
    if (signatureBytes != null) {
      String base64Signature = base64Encode(signatureBytes);
      await controller.insertDonateSignature(DonateInsertSignature(idDonate: widget.idDonate, signature: base64Signature));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Assinatura realizada com sucesso!")),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/default', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Assinatura Doador")),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: Signature(controller: _controller, height: 500),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed: _clearSignature,
                    child: Text("Limpar"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed: _saveSignature,
                    child: Text("Salvar"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}