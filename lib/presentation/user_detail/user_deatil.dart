import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/presentation/user_update/user_update_page.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class UserDetailPage extends HookConsumerWidget {
  const UserDetailPage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final userId = user.id;
    if (userId.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }
    final updateUser = useState<User>(user);

    // // Fetch the user data
    // final getUser = ref.watch(getUserProvider(userId));
    final getUser = ref.watch(getUserProvider(userId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations.userInfo),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserUpdatePage(user: updateUser.value),
                ),
              );
            },
          ),
        ],
      ),
      body: getUser.when(
        data: (userData) {
          updateUser.value = userData;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(userData),
                const SizedBox(height: 20),
                _buildDetailCard(context, userData),
              ],
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              'Error: ${error.toString()}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(User userData) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[400],
            child: userData.profile != null && userData.profile!.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userData.profile!,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 50,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
          ),
          const SizedBox(height: 10),
          Text(
            userData.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            userData.email,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, User userData) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(context, localizations.name, userData.name),
            _buildDetailRow(context, localizations.email, userData.email),
            _buildDetailRow(context, localizations.addressName,
                userData.address?.name ?? 'N/A'),
            _buildDetailRow(context, localizations.addressLocation,
                userData.address?.location ?? 'N/A'),
            _buildDetailRow(
                context, localizations.joined, userData.createdAt.timeZoneName),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }
}
