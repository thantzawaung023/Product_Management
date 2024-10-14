import 'package:flutter/material.dart';
import 'package:product_management/presentation/profile/user_profile.dart';
import 'package:product_management/presentation/setting/setting_page.dart';
import 'package:product_management/presentation/user/user_page.dart';
import 'package:product_management/widgets/logout_button.dart';

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
      const Text('Notification'),
      UserProfilePage(
          userId: widget.userId), // No const here, userId is dynamic
      SettingPage(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: _pages.elementAt(_selectedIndex), // Display selected page
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Logout',
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
