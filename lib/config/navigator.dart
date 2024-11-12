import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/presentation/home/home_page.dart';
import 'package:product_management/presentation/profile/user_profile.dart';
import 'package:product_management/presentation/setting/setting_page.dart';
import 'package:product_management/presentation/todo_list/todo_list_page.dart';
import 'package:product_management/presentation/user/user_page.dart';
import 'package:product_management/presentation/user/widgets/list_tile.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/provider/user_list/user_list_view_model.dart';
import 'package:product_management/widgets/custom_btn.dart';
import 'package:product_management/widgets/map_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class AppNavigator extends ConsumerStatefulWidget {
  const AppNavigator({super.key, required this.userId, this.index = 0});

  final String userId;
  final int index;

  @override
  AppNavigatorState createState() => AppNavigatorState();
}

class AppNavigatorState extends ConsumerState<AppNavigator> {
  late int _selectedIndex;
  late final PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Set<User> _selectedUsers = {};

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final userAsyncValue = ref.watch(userProviderFuture(widget.userId));
    final userListStream = ref.watch(getuserListWithAddressStream);

    return userAsyncValue.when(
      data: (user) {
        List<Widget> _pages = [
          HomePage(user: user!),
          const UserPage(),
          const TodoListPage(),
          UserProfilePage(userId: widget.userId),
          SettingPage(userId: widget.userId),
        ];

        return Scaffold(
          key: _scaffoldKey,
          drawer: _selectedIndex == 0 || _selectedIndex == 1
              ? Drawer(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: DrawerHeader(
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.usersLocation,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                localizations.canSelectAndView,
                                style: TextStyle(),
                              )
                            ],
                          ),
                        ),
                      ),
                      userListStream.when(
                        data: (userList) {
                          if (userList == null || userList.isEmpty) {
                            return Center(
                              child: Text(
                                localizations.noUserAvailable,
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }
                          return Expanded(
                            child: ListView.builder(
                              itemCount: userList.length,
                              itemBuilder: (context, index) {
                                final user = userList[index];
                                return UserTile(
                                  user: user!,
                                  selectedUsers: _selectedUsers,
                                  onItemSelect: (user, isSelected) {
                                    if (isSelected) {
                                      setState(() {
                                        _selectedUsers.add(user);
                                      });
                                    } else {
                                      setState(() {
                                        _selectedUsers.remove(user);
                                      });
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        },
                        loading: () {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        error: (error, stackTrace) {
                          logger.e(error);
                          return Center(
                            child: Text(
                              'Error: ${error.toString()}',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 16),
                            ),
                          );
                        },
                      ),
                      if (_selectedUsers.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomButton(
                            label: localizations.viewLocationOnMap,
                            onPressed: () async => _navigateToMapScreen(),
                          ),
                        ),
                    ],
                  ),
                )
              : null,
          body: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: _onItemTapped,
                children: _pages,
              ),
              if (_selectedIndex == 0)
                Positioned(
                  top: 60,
                  left: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.sort,
                      size: 40,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                ),
            ],
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
                    _buildBottomNavItem(Icons.group, 'User List', 1),
                    _buildBottomNavItem(Icons.card_giftcard, 'todo Post', 2),
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return MaterialButton(
      minWidth: 40,
      onPressed: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.deepPurple : Colors.grey[600]),
          Text(label,
              style: TextStyle(
                  color: isSelected ? Colors.deepPurple : Colors.grey[600])),
        ],
      ),
    );
  }

  void _navigateToMapScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapScreen(users: _selectedUsers.toList()),
      ),
    );
  }
}
