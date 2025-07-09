import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iba_member_app/assets/widgets/pdf_viewer_screen.dart';
import 'package:iba_member_app/controller/heritage_controller.dart';
import 'package:iba_member_app/core/data/models/heritage/heritage_grid.dart';
import 'package:iba_member_app/core/data/models/heritage/heritage_insert.dart';
import 'package:iba_member_app/features/heritage/screens/heritage_view_screen.dart';
import 'package:iba_member_app/service_locator.dart';

Timer? _debounce;

class HeritageSearchScreen extends StatefulWidget {
  const HeritageSearchScreen({super.key});

  @override
  State<HeritageSearchScreen> createState() => _HeritageSearchScreenState();
}

class _HeritageSearchScreenState extends State<HeritageSearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final controller = getIt<HeritageController>();

  final List<HeritageGrid> _heritage = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchHeritage();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoading &&
          _hasMore) {
        _fetchHeritage();
      }
    });

    _loadStatus();
  }

  Future<void> _fetchHeritage({bool reset = false}) async {
    if (reset) {
      setState(() {
        _heritage.clear();
        _currentPage = 1;
        _hasMore = true;
      });
    }

    setState(() => _isLoading = true);

    List<HeritageGrid> newHeritage;

    if (_searchQuery.isNotEmpty) {
      newHeritage = await controller.searchHeritages(_searchQuery);

      setState(() {
        _heritage.addAll(newHeritage);
        _isLoading = false;
        _hasMore = false;
      });
    } else {
      newHeritage = await controller.getDonates(
        skip: _currentPage,
        take: _pageSize,
      );

      setState(() {
        _heritage.addAll(newHeritage);
        _isLoading = false;
        _currentPage++;
        if (newHeritage.length < _pageSize) {
          _hasMore = false;
        }
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = value;
      _fetchHeritage(reset: true);
    });
  }

  late List<Map<String, String>> _statusOptions = [];

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

  late TextEditingController _nameController;
  late TextEditingController _statusController;
  final _formKey = GlobalKey<FormState>();

  void _insertHeritage() {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _statusController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Inserir Patrimônio',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _statusOptions.any((status) =>
                            status["value"] == _statusController.text)
                        ? _statusController.text
                        : null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Status",
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
                        _statusController.text = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira status';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          final name = _nameController.text;
                          final status = _statusController.text;

                          var insert = HeritageInsert(
                              name: name, idStatusHeritage: status);

                          try {
                            var id = await controller.insertHeritage(insert);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HeritageViewScreen(id: id),
                              ),
                            );
                          } catch (e) {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro ao inserir: $e')),
                            );
                          }

                          _fetchHeritage();
                          _nameController.dispose();
                          _statusController.dispose();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _nameController.dispose();
                        _statusController.dispose();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Patrimônios'),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'printBtn',
            mini: true,
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                var pdfBytes = await controller.getPdf();

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerScreen(
                      pdfBytes: pdfBytes,
                      titleScreen: 'Patrimônios PDF',
                    ),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao carregar PDF: $e')),
                );
              }
            },
            tooltip: 'Imprimir PDF',
            child: const Icon(Icons.picture_as_pdf),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addBtn',
            mini: true,
            onPressed: () {
              // showModalBottomSheet(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         ListTile(
              //           leading: const Icon(Icons.add),
              //           title: const Text('Inserir Item'),
              //           onTap: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => const HeritageViewScreen(id: ''),
              //               ),
              //             ).then((_) {
              //               Navigator.pop(context);
              //               _fetchHeritage();
              //             });
              //
              //           },
              //         ),
              //         ListTile(
              //           leading: const Icon(Icons.playlist_add),
              //           title: const Text('Inserir Múltiplos'),
              //           onTap: () {
              //             print('Inserir múltiplos');
              //           },
              //         ),
              //       ],
              //     );
              //   },
              // );

              _insertHeritage();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const HeritageViewScreen(id: ''),
              //   ),
              // ).then((_) {
              //   // Navigator.pop(context);
              //   _fetchHeritage();
              // });
            },
            tooltip: 'Adicionar',
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar item...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _heritage.length + 1,
              itemBuilder: (context, index) {
                if (index < _heritage.length) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HeritageViewScreen(id: _heritage[index].id),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _heritage[index].name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text('Código: ${_heritage[index].code}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Status: ${_heritage[index].status}'),
                            ],
                          ),
                          const Divider()
                        ],
                      ),
                    ),
                  );
                  ;
                } else if (_hasMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text('')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
