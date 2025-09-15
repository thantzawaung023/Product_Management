import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/presentation/todo_list/widgets/todo_shimmer.dart';
import 'package:product_management/provider/todo_list/todo_list_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MyTodoCarouselSlider extends ConsumerStatefulWidget {
  const MyTodoCarouselSlider({super.key});

  @override
  CustomCarouselSliderState createState() => CustomCarouselSliderState();
}

class CustomCarouselSliderState extends ConsumerState<MyTodoCarouselSlider> {
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
      ],
    );
  }
}
