import 'package:flutter/material.dart';
import 'package:product_management/presentation/profile/user_profile.dart';
import 'package:product_management/presentation/setting/setting_page.dart';
import 'package:product_management/presentation/todo_list/todo_list_page.dart';
import 'package:product_management/presentation/user/user_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userId});
  final String userId;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages to show based on the selected index
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const UserPage(), // UserPage has a const constructor
      const TodoListPage(),
      UserProfilePage(
          userId: widget.userId), // No const here, userId is dynamic
      SettingPage(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1),
      body:
       Center(
        child: _pages.elementAt(_selectedIndex), // Display selected page
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.task)),
            label: 'TodoList',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.grey.shade400,
        indicatorColor: Colors.grey[500],
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
