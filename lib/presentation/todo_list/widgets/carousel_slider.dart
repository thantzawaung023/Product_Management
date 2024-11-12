import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/todo/todo.dart';
import 'package:product_management/presentation/todo_list/widgets/todo_item.dart';
import 'package:product_management/presentation/todo_list/widgets/todo_shimmer.dart';
import 'package:product_management/provider/todo_list/todo_list_notifier.dart';
import 'package:product_management/widgets/common_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CustomCarouselSlider extends ConsumerStatefulWidget {
  const CustomCarouselSlider({super.key});

  @override
  CustomCarouselSliderState createState() => CustomCarouselSliderState();
}

class CustomCarouselSliderState extends ConsumerState<CustomCarouselSlider> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final todoListState =
        ref.watch(getTopTodoProvider); // Watching the provider

    // Handle loading and error states
    if (todoListState.isLoading) {
      return const Center(
        child: ShimmerCarousel(),
      );
    }

    if (todoListState.hasError) {
      return Center(
        child: Text('Error: ${todoListState.error}'),
      );
    }

    // Get the list of top todos (ensure it's not empty)
    final todoList = todoListState.value;
    if (todoList == null || todoList.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.todoNotAvailable),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            initialPage: _currentPage,
            onPageChanged: (value, _) {
              setState(() {
                _currentPage = value;
              });
            },
          ),
          items: todoList.map((todo) {
            return Builder(
              builder: (BuildContext context) {
                final imageUrl = todo!.image ?? '';
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 7.0, vertical: 12),
                  decoration: BoxDecoration(
                    image: imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(imageUrl),
                            fit: BoxFit.cover, // Ensure the image fits nicely
                          )
                        : null, // If no image URL, you can apply a fallback style
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.title, // Display todo title
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            todo.description, // Display todo description
                            style: const TextStyle(fontSize: 14.0),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Text(
                          todo.createdBy,
                          style: const TextStyle(
                            fontSize: 11.0,
                            color: Colors
                                .white70, // Slightly lighter color for contrast
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              },
            );
          }).toList(),
        ),
        buildCarouselIndicator(_currentPage, todoList.length, context),
      ],
    );
  }
}

buildCarouselIndicator(currentPage, itemCount, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (int i = 0; i < itemCount; i++)
        Container(
          margin: const EdgeInsets.all(5),
          width: i == currentPage ? 7 : 5,
          height: i == currentPage ? 7 : 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == currentPage
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey,
          ),
        ),
    ],
  );
}

class ToDoList extends ConsumerWidget {
  const ToDoList({super.key, this.todo});
  final Todo? todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListState = ref.watch(todoListNotifierProvider);
    final todoListNotifier = ref.watch(todoListNotifierProvider.notifier);
    final user = auth.FirebaseAuth.instance.currentUser;

    if (todoListState.isLoading) {
      return const ShimmerTodoItem(); // Loading for inner component
    }

    if (todoListState.errorMsg.isNotEmpty) {
      return Center(child: Text('${todoListState.errorMsg}'));
    }

    if (todoListState.todoList.isEmpty) {
      return Center(
          child: Text(AppLocalizations.of(context)!.todoNotAvailable));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 350, // You can adjust this value based on your design
      ),
      itemCount: todoListState.todoList.length,
      itemBuilder: (_, index) {
        final todo = todoListState.todoList[index];
        return Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor,
          ),
          child: InkWell(
            onTap: () {},
            onLongPress: () async {
              final shouldDelete = await showConfirmDialog(
                context: context,
                message: AppLocalizations.of(context)!.confirmDelete,
              );
              if (shouldDelete) {
                if (user!.email != todo.createdBy && context.mounted) {
                  showSnackBar(context,
                      AppLocalizations.of(context)!.cannotDelete, Colors.red);
                  return;
                }

                try {
                  todoListNotifier.deleteTodo(todo.id);
                  if (context.mounted) {
                    showSnackBar(
                        context,
                        AppLocalizations.of(context)!.successDelete,
                        Colors.green);
                  }
                } on Exception catch (e) {
                  if (context.mounted) {
                    showSnackBar(
                        context,
                        '${AppLocalizations.of(context)!.failDelete}: $e',
                        Colors.red);
                  }
                }
              }
            },
            child: TodoItem(todo: todo),
          ),
        );
      },
    );
  }
}
