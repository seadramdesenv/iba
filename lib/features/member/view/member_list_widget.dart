import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iba_member_app/core/data/member_service.dart';
import 'package:iba_member_app/core/data/models/Member.dart';
import 'package:iba_member_app/features/member/view/member_detail_page.dart';
import 'package:iba_member_app/features/member/widgets/member_item_widget.dart';
import 'package:iba_member_app/service_locator.dart';
import 'dart:async';

enum SortType { nameAsc, nameDesc, dateAsc, dateDesc }

Timer? _debounce;

class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final api = getIt<MemberApi>();

  List<Member> _members = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;
  String _searchQuery = '';

  SortType _currentSort = SortType.nameAsc;

  @override
  void initState() {
    super.initState();
    _fetchMembers(isRefresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoading &&
          _hasMore &&
          _searchQuery.isEmpty) {
        _fetchMembers();
      }
    });
  }

  void _sortMembers() {
    _members.sort((a, b) {
      switch (_currentSort) {
        case SortType.nameAsc:
          return a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
        case SortType.nameDesc:
          return b.fullName.toLowerCase().compareTo(a.fullName.toLowerCase());
        case SortType.dateAsc:
          return a.memberSince.compareTo(b.memberSince);
        case SortType.dateDesc:
          return b.memberSince.compareTo(a.memberSince);
      }
    });
  }

  Future<void> _fetchMembers({bool isRefresh = false}) async {
    if (_isLoading) return;
    if (mounted) setState(() => _isLoading = true);

    if (isRefresh) {
      _currentPage = 1;
      _members.clear();
      _hasMore = true;
    }

    try {
      if (_searchQuery.isEmpty) {
        final newMembers =
            await api.getMember(skip: _currentPage, take: _pageSize);
        if (mounted) {
          setState(() {
            _members.addAll(newMembers);
            if (newMembers.length < _pageSize) {
              _hasMore = false;
            }
            _currentPage++;
            _sortMembers();
          });
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty && _searchQuery.isNotEmpty) {
      _searchQuery = '';
      _searchController.clear();
      await _fetchMembers(isRefresh: true);
      return;
    }

    // Se a query não mudou, não faz nada
    if (query == _searchQuery) return;

    _searchQuery = query;
    if (mounted) setState(() => _isLoading = true);

    try {
      final searchResults = await api.searchMember(query);
      if (mounted) {
        setState(() {
          _members = searchResults;
          _hasMore = false;
          _sortMembers();
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
      _performSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membros',
            style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<SortType>(
            onSelected: (sortType) {
              setState(() {
                _currentSort = sortType;
                _sortMembers();
              });
            },
            icon:
                Icon(Icons.sort, color: Theme.of(context).colorScheme.primary),
            tooltip: "Ordenar",
            itemBuilder: (context) => <PopupMenuEntry<SortType>>[
              const PopupMenuItem(
                  value: SortType.nameAsc, child: Text('Nome (A-Z)')),
              const PopupMenuItem(
                  value: SortType.nameDesc, child: Text('Nome (Z-A)')),
              const PopupMenuItem(
                  value: SortType.dateDesc,
                  child: Text('Membros mais Recentes')),
              const PopupMenuItem(
                  value: SortType.dateAsc, child: Text('Membros mais Antigos')),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newMember = Member();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MemberDetailPage(member: newMember)),
          ).then((_) => _fetchMembers(isRefresh: true));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar membro...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade800,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchMembers(isRefresh: true),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _members.length + (_isLoading ? 1 : 0),
                padding: const EdgeInsets.only(top: 0, bottom: 80),
                itemBuilder: (context, index) {
                  if (index < _members.length) {
                    return MemberItemWidget(
                      member: _members[index],
                      fetchMembers: () => _fetchMembers(isRefresh: true),
                    );
                  } else if (_isLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (_members.isEmpty && !_isLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: Text("Nenhum membro encontrado")),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
