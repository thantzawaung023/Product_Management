import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/presentation/profile/widgets/showGoogleMapDialog.dart';
import 'package:product_management/presentation/user_update/widgets/profile_image.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/utils/utils.dart';
import 'package:product_management/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class UserUpdatePage extends ConsumerWidget {
  UserUpdatePage({super.key, required this.user});

  final _formKey = GlobalKey<FormState>();
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final userViewModelState = ref.watch(userViewModelNotifierProvider(user));
    final userViewModelNotifier =
        ref.watch(userViewModelNotifierProvider(user).notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localization.updateUser),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ProfileImageSection(
                  state: userViewModelState,
                  viewModel: userViewModelNotifier,
                  context: context,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: localization.name,
                  initialValue: userViewModelState.name,
                  onChanged: userViewModelNotifier.setName,
                  isRequired: true,
                  validator: (value) => Validators.validateRequiredField(
                    value: value,
                    labelText: localization.name,
                    context: context,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: localization.addressName,
                  initialValue: userViewModelState.address?.name ?? '',
                  onChanged: userViewModelNotifier.setAddressName,
                  isRequired: true,
                  validator: (value) => Validators.validateAddressName(
                    value: value,
                    labelText: localization.addressName,
                    context: context,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: localization.addressLocation,
                  initialValue: userViewModelState.address?.location ?? '',
                  onChanged: userViewModelNotifier.setAddressLocation,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  isRequired: true,
                  helperText: 'Eg - 37.45889, -122.27254',
                  validator: (value) => Validators.validateAddressLocation(
                    value: value,
                    labelText: localization.addressLocation,
                    context: context,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton.icon(
                  onPressed: () async {
                    await showDialog<LatLng>(
                      context: context,
                      builder: (context) => GoogleMapPickerDialog(
                          userNotifier: userViewModelNotifier),
                    );
                  },
                  label: Text(
                    AppLocalizations.of(context)!.chooseFromGoogeMap,
                    style: TextStyle(
                      color: Colors.red.withOpacity(0.5),
                    ),
                  ),
                  icon: Icon(
                    Icons.location_searching_outlined,
                    color: Colors.red.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: localization.save,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ref
                          .watch(loadingProvider.notifier)
                          .update((state) => true);
                      try {
                        await userViewModelNotifier.updateUser();
                        if (context.mounted) {
                          showSnackBar(context, localization.successUserUpdate,
                              Colors.green);
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
