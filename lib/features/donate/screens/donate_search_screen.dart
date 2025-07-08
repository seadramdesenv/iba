import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iba_member_app/core/data/models/donate/donate_grid.dart';
import 'package:iba_member_app/controller/donate_controller.dart';
import 'package:iba_member_app/features/donate/screens/donor_list_screen.dart';
import 'package:iba_member_app/service_locator.dart';

Timer? _debounce;

class DonateSearchScreen extends StatefulWidget {
  const DonateSearchScreen({super.key});

  @override
  State<DonateSearchScreen> createState() => _DonateSearchScreenState();
}

class _DonateSearchScreenState extends State<DonateSearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final controller = getIt<DonateController>();

  final List<DonateGrid> _donates = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchDonates();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoading && _hasMore) {
        _fetchDonates();
      }
    });
  }

  Future<void> _fetchDonates({bool reset = false}) async {
    if (reset) {
      setState(() {
        _donates.clear();
        _currentPage = 1;
        _hasMore = true;
      });
    }

    setState(() => _isLoading = true);

    List<DonateGrid> newMembers;

    newMembers = await controller.getDonates(
      skip: _currentPage,
      take: _pageSize,
    );

    setState(() {
      _donates.addAll(newMembers);
      _isLoading = false;
      _currentPage++;
      if (newMembers.length < _pageSize) {
        _hasMore = false;
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = value;
      _fetchDonates(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista Doações"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DonorListScreen(),
            ),
          ).then((_) {
            _fetchDonates();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _donates.length + 1,
              itemBuilder: (context, index) {
                if (index < _donates.length) {
                  return GestureDetector(
                    onTap: () {
                      print('opa');
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
                                'Doador: ${_donates[index].donor}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(_donates[index].dateTimeRegister),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Quantidade: ${_donates[index].quantytiItems}'),
                            ],
                          ),
                          const Divider()
                        ],
                      ),
                    ),
                  );
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
