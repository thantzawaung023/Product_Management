import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/todo/todo.dart';
import 'package:product_management/presentation/todo_add/widgets/todo_image.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/provider/todo/todo_notifier.dart';
import 'package:product_management/widgets/common_dialog.dart';
import 'package:product_management/widgets/custom_btn.dart';
import 'package:product_management/widgets/custom_text_field.dart';

class TodoListAddPage extends ConsumerWidget {
  TodoListAddPage({super.key, this.todo});

  final _formKey = GlobalKey<FormState>();
  final Todo? todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final todoState = ref.watch(todoNotifierProvider(todo));
    final todoNotifier = ref.watch(todoNotifierProvider(todo).notifier);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Add TODO Post'),
        backgroundColor: Colors.grey.shade400,
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
                  onChanged: todoNotifier.setTitle,
                  isRequired: true,
                  maxLength: 25,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  label: 'Description',
                  onChanged: todoNotifier.setDescription,
                  isRequired: true,
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required.';
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
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    customSwitch(todoNotifier, todoState),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                  label: isLoading ? '' : 'Save',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ref.read(loadingProvider.notifier).state = true;
                      try {
                        await todoNotifier.createToDoPost();

                        if (context.mounted) {
                          showCustomDialogForm(
                            context: context,
                            title: 'Success',
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified_outlined,
                                    color: Colors.amber, size: 100),
                                SizedBox(height: 16),
                                Text(
                                  'New Todo Post is successfully Created!',
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text('Be Enjoy!'),
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
