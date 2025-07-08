import 'package:flutter/material.dart';
import 'package:iba_member_app/core/data/member_service.dart';
import 'package:iba_member_app/core/data/models/Member.dart';
import 'package:iba_member_app/features/member/view/member_detail_page.dart';
import 'package:iba_member_app/features/member/widgets/member_item_widget.dart';
import 'package:iba_member_app/service_locator.dart';

import 'dart:async';

Timer? _debounce;

class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final api = getIt<MemberApi>();

  final List<Member> _members = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchMembers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoading && _hasMore) {
        _fetchMembers();
      }
    });
  }

  Future<void> _fetchMembers({bool reset = false}) async {
    if (reset) {
      setState(() {
        _members.clear();
        _currentPage = 1;
        _hasMore = true;
      });
    }

    setState(() => _isLoading = true);

    List<Member> newMembers;

    if (_searchQuery.isNotEmpty) {
      newMembers = await api.searchMember(_searchQuery);

      setState(() {
        _members.addAll(newMembers);
        _isLoading = false;
        _hasMore = false;
      });
    } else {
      newMembers = await api.getMember(
        skip: _currentPage,
        take: _pageSize,
      );

      setState(() {
        _members.addAll(newMembers);
        _isLoading = false;
        _currentPage++;
        if (newMembers.length < _pageSize) {
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
      _fetchMembers(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Membros')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newMember = Member();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberDetailPage(member: newMember),
            ),
          ).then((_) {
            _fetchMembers();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar membro...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _members.length + 1,
              itemBuilder: (context, index) {
                if (index < _members.length) {
                  return MemberItemWidget(
                    member: _members[index],
                    fetchMembers: () {
                      _fetchMembers(reset: true);
                    },
                  );
                } else if (_hasMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text('Fim da lista')),
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
