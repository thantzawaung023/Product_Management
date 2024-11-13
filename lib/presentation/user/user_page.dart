import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/presentation/user/widgets/list_tile.dart';
import 'package:product_management/presentation/user/widgets/search_input.dart';
import 'package:product_management/presentation/user_create/user_create_page.dart';
import 'package:product_management/provider/user_list/user_list_view_model.dart';
import 'package:product_management/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  bool _isSelectionMode = false; // Track selection mode
  final Set<String> _selectedItems = {}; // Store selected user IDs

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final userListViewModel = ref.watch(userListViewModelNotifierProvider);
    final userListViewModelNotifier =
        ref.read(userListViewModelNotifierProvider.notifier);

    deleteUser() async {
      try {
        await userListViewModelNotifier.deleteUsers(_selectedItems);
        setState(() {
          _isSelectionMode = false;
          _selectedItems.clear();
        });
        if (context.mounted) {
          showSnackBar(context, 'User deleted successfully', Colors.green);
        }
      } catch (e) {
        if (context.mounted) {
          showSnackBar(context, 'Failed to delete user: $e', Colors.red);
        }
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          localization.userList,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: UserSearchInput(onChanged: (query) {
            userListViewModelNotifier.searchUsers(query);
          }),
        ),
        actions: const [
          // if (_isSelectionMode) // Show delete icon only in selection mode
        ],
      ),
      body: Column(
        children: [
          if (userListViewModel.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (userListViewModel.errorMsg.isNotEmpty)
            Center(
              child: Text(
                'Error: ${userListViewModel.errorMsg}',
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: userListViewModel.userList.length,
                itemBuilder: (context, index) {
                  final user = userListViewModel.userList[index];
                  return UserListTile(
                    user: user,
                    selectedItems: _selectedItems,
                    isSelectionMode: _isSelectionMode,
                    onItemSelect: (String userId, bool isSelected) {
                      setState(() {
                        if (isSelected) {
                          _selectedItems.add(userId);
                        } else {
                          _selectedItems.remove(userId);
                        }
                        if (_selectedItems.isEmpty) {
                          _isSelectionMode =
                              false; // Exit selection mode when no items are selected
                        } else {
                          _isSelectionMode =
                              true; // Enter selection mode when at least one item is selected
                        }
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? FloatingActionButton(
              onPressed: _selectedItems.isNotEmpty
                  ? () async {
                      // Show confirmation dialog
                      final shouldDelete = await showConfirmDialog(
                        context: context,
                        message: localization.confirmDelete,
                      );
                      if (shouldDelete) {
                        deleteUser(); // deleteUser for async handling
                      }
                    }
                  : null,
              child: const Icon(Icons.delete_outline))
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserCreatePage()));
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
