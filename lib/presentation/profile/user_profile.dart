import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/data/entities/user_provider_data/user_provider_data.dart';
import 'package:product_management/presentation/login/login_page.dart';
import 'package:product_management/presentation/profile/widgets/profile_widgets.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/utils/constants/messages.dart';
import 'package:product_management/utils/extensions/exception_msg.dart';
import 'package:product_management/utils/storage/provider_setting.dart';
import 'package:product_management/widgets/common_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:collection/collection.dart';

class UserProfilePage extends HookConsumerWidget {
  const UserProfilePage({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProviderStream(userId));
    final currentUser = auth.FirebaseAuth.instance.currentUser;
    final providerData = currentUser?.providerData;
    final showOptions = useState(false);
    final providerId = useState<String?>('');

    // Fetch the providerId when the widget builds
    useEffect(() {
      Future<void> fetchProviderId() async {
        providerId.value = await CurrentProviderSetting().get();
      }

      fetchProviderId();
      return null;
    }, []);

    void toggleOptions() {
      showOptions.value = !showOptions.value;
    }

    Future<void> uploadProfile(User user) async {
      ref.watch(loadingProvider.notifier).update((state) => true);
      final userNotifier =
          ref.watch(userViewModelNotifierProvider(user).notifier);
      final image = await userNotifier.imageData();

      if (image == null && context.mounted) {
        showSnackBar(context, Messages.validateImgMsg);
        ref.read(loadingProvider.notifier).update((state) => false);
        return;
      }

      try {
        userNotifier.setImageData(image!);
        await userNotifier.uploadProfile(oldProfileUrl: user.profile ?? '');
        if (context.mounted) {
          showSnackBar(context, 'Profile image uploaded successfully!');
        }
      } on Exception catch (e) {
        if (context.mounted) {
          showSnackBar(context, e.getMessage);
        }
      } finally {
        ref.read(loadingProvider.notifier).update((state) => false);
        showOptions.value = false;
      }
    }

    Future<void> removeImage(User user) async {
      ref.watch(loadingProvider.notifier).update((state) => true);
      final userNotifier =
          ref.watch(userViewModelNotifierProvider(user).notifier);
      try {
        await userNotifier.deleteProfile();
        ref.watch(loadingProvider.notifier).update((state) => false);
        showOptions.value = false;
        if (context.mounted) {
          showSnackBar(context, 'Profile image removed successfully!');
        }
      } on Exception catch (e) {
        ref.watch(loadingProvider.notifier).update((state) => false);
        if (context.mounted) {
          showSnackBar(context, e.getMessage);
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.grey.shade400,
        actions: const [],
      ),
      body: userAsyncValue.when(
        data: (user) {
          if (user == null || currentUser == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.watch(loadingProvider.notifier).update((state) => false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            });
            return const SizedBox.shrink();
          }

          UserProviderData? userProvider;
          if (providerData != null && providerId.value!.isNotEmpty) {
            final userInfo = providerData.firstWhere(
              (provider) => provider.providerId == providerId.value,
            );
            final providerDataUid = userInfo.uid;
            if (providerDataUid != null && user.providerData != null) {
              userProvider = user.providerData!.firstWhere(
                (provider) => provider.uid == providerDataUid,
                orElse: () => const UserProviderData(),
              );
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileHeader(
                  context: context,
                  userData: user,
                  userProvider: userProvider,
                  showOptions: showOptions.value,
                  onEditPressed: toggleOptions,
                  onUploadPressed: () => uploadProfile(user),
                  onRemovePressed: () => removeImage(user),
                ),
                const SizedBox(height: 20),
                BuildDetailCard(userData: user, userProvider: userProvider),
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
}
