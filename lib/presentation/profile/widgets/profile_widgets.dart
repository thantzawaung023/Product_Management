import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/data/entities/user_provider_data/user_provider_data.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/utils/extensions/exception_msg.dart';
import 'package:product_management/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class BuildDetailCard extends ConsumerWidget {
  final User userData; // Required User data
  final UserProviderData? userProvider;
  const BuildDetailCard({
    super.key,
    required this.userData,
    this.userProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.userInfo,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            buildUserInfoRow(
              title: '${AppLocalizations.of(context)!.name} : ${userData.name}',
              titleColor: Theme.of(context).colorScheme.onSecondary,
              iconColor: Theme.of(context).colorScheme.secondary,
              icon: Icons.person,
              onPressed: () => showEditFieldDialog(
                context: context,
                label: AppLocalizations.of(context)!.editName,
                initialValue: userProvider?.userName ?? '',
                onSave: (value) async {
                  try {
                    final userNotifier = ref
                        .read(userViewModelNotifierProvider(userData).notifier);
                    userNotifier.setName(value);
                    if (userNotifier.mounted) {
                      await userNotifier.updateUsername();
                    }
                  } on Exception catch (e) {
                    if (!context.mounted) return;
                    showSnackBar(context, e.getMessage, Colors.red);
                  }
                },
              ),
            ),
            const Divider(),
            buildUserInfoRow(
              title: userData.address != null &&
                      userData.address!.name.isNotEmpty &&
                      userData.address!.location.isNotEmpty
                  ? '${AppLocalizations.of(context)!.address} : ${userData.address!.name}, ${userData.address!.location}'
                  : AppLocalizations.of(context)!.notAvailableAddress,
              titleColor: Theme.of(context).colorScheme.onSecondary,
              iconColor: Theme.of(context).colorScheme.secondary,
              icon: Icons.location_on,
              onPressed: () {
                // Open dialog to update address
                showEditAddressDialog(
                  context,
                  addressName: userData.address!.name,
                  addressLocation: userData.address!.location,
                  onSave: (name, location) async {
                    try {
                      final userNotifier = ref.read(
                          userViewModelNotifierProvider(userData).notifier);
                      userNotifier.setAddressName(name);
                      userNotifier.setAddressLocation(location);
                      if (userNotifier.mounted) {
                        await userNotifier.updateAddress();
                      }
                    } on Exception catch (e) {
                      if (!context.mounted) return;
                      showSnackBar(context, e.getMessage, Colors.red);
                    }
                  },
                );
              },
            ),
            const Divider(),
            buildUserInfoRow(
              title:
                  '${AppLocalizations.of(context)!.joined} : ${userData.createdAt}',
              titleColor: Theme.of(context).colorScheme.onSecondary,
              iconColor: Theme.of(context).colorScheme.secondary,
              icon: Icons.calendar_today,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildUserInfoRow({
  required String title,
  Color? titleColor = const Color(0xFF202021),
  required IconData icon,
  Color? iconColor = const Color(0xFF202021),
  required VoidCallback onPressed,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      IconButton(
        icon: Icon(
          icon,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    ],
  );
}

Widget buildProfileHeader({
  required BuildContext context,
  required User userData,
  UserProviderData? userProvider,
  required bool showOptions,
  required VoidCallback onEditPressed,
  required VoidCallback onUploadPressed,
  required VoidCallback onRemovePressed,
}) {
  return Center(
    child: Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary,
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
                            const Icon(Icons.error, size: 50),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    )
                  : userProvider?.photoUrl != null &&
                          userProvider!.photoUrl.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: userProvider.photoUrl,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, size: 50),
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEditPressed,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (showOptions)
          SizedBox(
            width: userData.profile != null && userData.profile!.isNotEmpty
                ? 240
                : 120,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onUploadPressed,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        AppLocalizations.of(context)!.uploadProfile,
                        style: const TextStyle(
                          color: Color(0xFFFBFDFD),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (userData.profile != null &&
                      userData.profile!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      height: 20,
                      width: 2,
                      color: const Color(0xFFFBFDFD),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onRemovePressed,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          AppLocalizations.of(context)!.removeProfile,
                          style: const TextStyle(
                            color: Color(0xFFFBFDFD),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
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

Future<void> showEditFieldDialog(
    {context,
    required String label,
    required String initialValue,
    required void Function(String) onSave}) {
  final fomrKey = GlobalKey<FormState>();
  String value = initialValue;

  return showCustomDialogForm(
      context: context,
      title: label,
      content: Form(
          key: fomrKey,
          child: CustomTextField(
            maxLength: 40,
            label: label,
            initialValue: initialValue,
            onChanged: (newValue) => value = newValue,
            isRequired: true,
            validator: (newValue) {
              if (newValue == null || newValue.isEmpty) {
                return '$label ${AppLocalizations.of(context)!.isRequired}';
              }
              return null;
            },
          )),
      onSave: () async {
        if (fomrKey.currentState?.validate() ?? false) {
          onSave(value);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      });
}

Future<void> showEditAddressDialog(
  BuildContext context, {
  required String addressName,
  required String addressLocation,
  required void Function(String, String) onSave,
}) {
  final formKey = GlobalKey<FormState>();
  String name = addressName;
  String location = addressLocation;

  return showCustomDialogForm(
    context: context,
    title: addressName.isEmpty && addressLocation.isEmpty
        ? AppLocalizations.of(context)!.addAddress
        : AppLocalizations.of(context)!.editAddress,
    content: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            maxLength: 40,
            label: AppLocalizations.of(context)!.addressName,
            initialValue: addressName,
            onChanged: (value) => name = value,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            maxLength: 40,
            label: AppLocalizations.of(context)!.addressLocation,
            initialValue: addressLocation,
            onChanged: (value) => location = value,
          ),
        ],
      ),
    ),
    onSave: () async {
      if (formKey.currentState?.validate() ?? false) {
        onSave(name, location);
        Navigator.of(context).pop();
      }
    },
  );
}
