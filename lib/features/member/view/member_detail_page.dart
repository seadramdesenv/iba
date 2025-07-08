import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iba_member_app/controller/member_controller.dart';
import 'package:iba_member_app/core/data/models/Member.dart';
import 'package:iba_member_app/features/member/widgets/member_detail_form.dart';
import 'package:iba_member_app/service_locator.dart';
import 'package:image_picker/image_picker.dart';

class MemberDetailPage extends StatefulWidget {
  const MemberDetailPage({super.key, required this.member});

  final Member member;

  @override
  State<MemberDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MemberDetailPage> {
  final controller = getIt.registerSingleton(MemberController());
  late Member _member;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _member = widget.member;
    // _loadPage();
  }

  // Future<void> _loadPage() async {
  //   if (widget.member.id != '') {
  //     var member = await controller.getMember(widget.member.id);
  //     setState(() {
  //       _member = member;
  //     });
  //   } else {
  //     setState(() {
  //       _member = widget.member;
  //     });
  //   }
  // }

  @override
  void dispose() {
    getIt.unregister(instance: controller);
    super.dispose();
  }

  Future<void> _onFormSubmit(Member updatedMember) async {
    updatedMember.photo = _member.photo;
    updatedMember.id = _member.id;
    setState(() {
      _member = updatedMember;
    });

    if (updatedMember.id == "") {
      try {
        await controller.InsertMember(updatedMember);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Membro inserido com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao inserir membro: $e')),
        );
      }
    } else {
      try {
        await controller.updateMember(updatedMember);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Membro alterado com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao inserir membro: $e')),
        );
      }
    }

    Navigator.of(context).pop();
    setState(() {});
  }

  void _onPhotoUpdated(String photo) {
    setState(() {
      _member.photo = photo;
    });
  }

  Future<void> _selectImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Câmera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Galeria'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      _onPhotoUpdated(base64Encode(imageBytes));
      setState(() {
        widget.member.photo = base64Encode(imageBytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Text(widget.member.id == '' ? 'Inserir Membro' : 'Detalhes do Membro'),
      ),
      backgroundColor: Color.alphaBlend(Colors.black12, Theme.of(context).scaffoldBackgroundColor),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.amberAccent,
                      width: 2.0,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.memory(
                      base64Decode(widget.member.photo),
                      fit: BoxFit.cover,
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 25,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.amberAccent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 30,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _selectImage();
                        // ação para trocar a foto
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MemberDetailForm(member: _member, onFormSubmit: _onFormSubmit),
          ],
        ),
      ),
    );
  }
}
