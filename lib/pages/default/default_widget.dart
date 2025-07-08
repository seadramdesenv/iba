import 'package:flutter/material.dart';
import 'package:iba_member_app/features/member/view/member_list_widget.dart';
import 'package:iba_member_app/pages/profile/profile_widget.dart';
import '../home/home_widget.dart';

class DefaultWidget extends StatefulWidget {
  const DefaultWidget({super.key});

  @override
  State<DefaultWidget> createState() => _DefaultWidgetState();

}

class _DefaultWidgetState extends State<DefaultWidget> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    MemberListPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Membro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
