import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/presentation/home/home_page.dart';
import 'package:product_management/presentation/profile/user_profile.dart';
import 'package:product_management/presentation/setting/setting_page.dart';
import 'package:product_management/presentation/todo_list/todo_list_page.dart';
import 'package:product_management/presentation/user/user_page.dart';
import 'package:product_management/provider/user/user_view_model.dart';

class AppNavigator extends ConsumerStatefulWidget {
  const AppNavigator({super.key, required this.userId, this.index = 0});

  final String userId;
  final int index; // No need for a default value assignment here

  @override
  AppNavigatorState createState() => AppNavigatorState();
}

class AppNavigatorState extends ConsumerState<AppNavigator> {
  int _selectedIndex = 0;
  late final PageController _pageController;

  // List of pages to show based on the selected index
  List<Widget>? _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the user asynchronously
    final userAsyncValue = ref.watch(userProviderFuture(widget.userId));

    return userAsyncValue.when(
      data: (user) {
        // Initialize the pages when data is available
        _pages ??= <Widget>[
          HomePage(user: user!),
          const UserPage(),
          const TodoListPage(),
          UserProfilePage(userId: widget.userId),
          SettingPage(userId: widget.userId),
        ];

        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index; // Update selected index when swiping
              });
            },
            children: _pages!,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor:
                _selectedIndex == 0 ? Colors.amber : Colors.deepOrange,
            shape: const CircleBorder(),
            onPressed: () => _onItemTapped(0),
            child: Icon(
              Icons.home,
              size: 30,
              color: _selectedIndex == 0 ? Colors.deepPurple : Colors.grey,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildBottomNavItem(Icons.group, 'User', 1),
                    _buildBottomNavItem(Icons.card_giftcard, 'Todo Post', 2),
                  ],
                ),
                Row(
                  children: [
                    _buildBottomNavItem(Icons.person, 'Profile', 3),
                    _buildBottomNavItem(Icons.settings, 'Setting', 4),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator()), // Loading indicator
      error: (error, stack) =>
          Center(child: Text('Error: $error')), // Error handling
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Navigate to the selected page
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return MaterialButton(
      minWidth: 40,
      onPressed: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.deepPurple : Colors.grey[600],
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.deepPurple : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
