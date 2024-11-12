import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/todo/todo.dart';
import 'package:product_management/presentation/todo_add/widgets/location_picker_dialog.dart';
import 'package:product_management/presentation/todo_add/widgets/todo_image.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/provider/todo/todo_notifier.dart';
import 'package:product_management/widgets/common_dialog.dart';
import 'package:product_management/widgets/custom_btn.dart';
import 'package:product_management/widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class TodoUpdatePage extends ConsumerWidget {
  TodoUpdatePage({super.key, required this.todo});

  final _formKey = GlobalKey<FormState>();
  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final todoState = ref.watch(todoNotifierProvider(todo));
    final todoNotifier = ref.watch(todoNotifierProvider(todo).notifier);
    String? selectedLocation;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.updateTodoPost),
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
                TodoImageSection(
                  state: todoState,
                  todoNotifier: todoNotifier,
                  context: context,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  label: 'Title',
                  initialValue: todoState.title,
                  maxLength: 25,
                  onChanged: todoNotifier.setTitle,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ' ${AppLocalizations.of(context)!.titleRequired}';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  label: AppLocalizations.of(context)!.description,
                  onChanged: todoNotifier.setDescription,
                  initialValue: todoState.description,
                  isRequired: true,
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.descriptionRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    todoState.isPublish
                        ? const Text(
                            "Publish",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )
                        : const Text(
                            "Private",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    customSwitch(todoNotifier, todoState),
                  ],
                ),

                const SizedBox(
                  height: 25,
                ),

                // Google Maps Location Picker Section

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final location = await showDialog<LatLng>(
                            context: context,
                            builder: (context) => const LocationPickerDialog(),
                          );

                          if (location != null) {
                            todoNotifier
                                .setLatitude(location.latitude.toString());
                            todoNotifier
                                .setLongitude(location.longitude.toString());
                            selectedLocation = await todoNotifier
                                .getAddressFromLatLng(location);
                            todoNotifier.setLocation(selectedLocation!);
                          }
                        },
                        label: todoState.location == null ||
                                todoState.location == ''
                            ? Text(
                                AppLocalizations.of(context)!
                                    .selectYourLocation,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Your location - ${todoState.location}',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                ),
                              ),
                        icon: Icon(
                          Icons.location_on_outlined,
                          size: 30,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        style: const ButtonStyle(
                            backgroundColor: WidgetStateColor.transparent),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  label: isLoading ? '' : AppLocalizations.of(context)!.update,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ref.read(loadingProvider.notifier).state = true;
                      try {
                        await todoNotifier.updateToDoPost();

                        if (context.mounted) {
                          showCustomDialogForm(
                            context: context,
                            title: AppLocalizations.of(context)!.success,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_outlined,
                                    color: Colors.amber, size: 100),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(context)!
                                      .successTodoUpdate,
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(AppLocalizations.of(context)!.successSpan),
                              ],
                            ),
                            onSave: () async {
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).pop(); // Pop the page
                            },
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      } finally {
                        ref.read(loadingProvider.notifier).state = false;
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
