import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/presentation/user_detail/user_deatil.dart';

class UserListTile extends StatelessWidget {
  final User user;
  final Set<String> selectedItems;
  final bool isSelectionMode;
  final Function(String, bool) onItemSelect; // Callback to manage selection

  const UserListTile({
    super.key,
    required this.user,
    required this.selectedItems,
    required this.isSelectionMode,
    required this.onItemSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedItems.contains(user.id);
    return Container(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
      margin: const EdgeInsets.only(bottom: 0, left: 10, right: 10, top: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: ListTile(
        title: Text(user.name.toString()),
        subtitle: Text(
          user.email,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserDetailPage(user: user),
              ),
            );
          },
          icon: const Icon(Icons.arrow_forward_ios),
        ),
        leading: isSelectionMode
            ? Checkbox(
                activeColor: Colors.amber,
                value: isSelected,
                onChanged: (bool? value) {
                  onItemSelect(user.id, value ?? false);
                },
              )
            : CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: user.profile != null && user.profile!.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user.profile!,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 30,
                            backgroundImage: imageProvider,
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      )
                    : const Icon(Icons.person),
              ),
        onLongPress: () {
          // Trigger selection mode from the parent by handling the long press.
          onItemSelect(user.id, !isSelected);
        },
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final User user;
  final Set<User> selectedUsers;
  final Function(User, bool) onItemSelect; // Callback to manage selection

  const UserTile({
    super.key,
    required this.user,
    required this.selectedUsers,
    required this.onItemSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedUsers.contains(user);
    return Container(
      padding: const EdgeInsets.only(left: 3, bottom: 5, top: 5),
      margin: const EdgeInsets.only(bottom: 0, left: 3, right: 3, top: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        title: Text(
          user.name.toString(),
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
        subtitle: Text(
          user.email,
          style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
        ),
        leading: Checkbox(
          activeColor: Colors.indigo,
          value: isSelected,
          onChanged: (bool? value) {
            onItemSelect(user, value ?? false);
          },
        ),
      ),
    );
  }
}
