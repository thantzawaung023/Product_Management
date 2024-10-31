import 'package:flutter/material.dart'; // Adjust import path as necessary
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/data/entities/todo/todo.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/provider/todo_list/todo_list_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:intl/intl.dart'; // For dynamic date

class HomePage extends ConsumerWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myTodoList = ref.watch(getMyTodoProvider);
    final recentLikeList = ref.watch(getRecentLikesProvider);
    final myList = myTodoList.value;
    final recentList = recentLikeList.value;
    final dayOfWeek = DateFormat('EEEE').format(DateTime.now());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        color: Colors.indigo,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.sort,
                              size: 40,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil<void>(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AppNavigator(userId: user.id, index: 3),
                                ),
                                (route) => false,
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: user.profile != null &&
                                      user.profile!.isNotEmpty
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: user.profile!,
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dashboard,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Today is $dayOfWeek',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white54,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        AppLocalizations.of(context)!.myTodoPost,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Check if myList is null or empty
                      if (myList == null || myList.isEmpty)
                        SizedBox(
                          height: 120,
                          child: Center(
                            child: Text(
                                AppLocalizations.of(context)!.todoNotAvailable),
                          ),
                        )
                      else
                        SizedBox(
                          height: 120, // Adjust height as needed
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: myList.length,
                            itemBuilder: (context, index) {
                              final todo = myList[index];
                              final imageUrl = todo!.image ?? '';
                              return MyCustomList(
                                  imageUrl: imageUrl, todo: todo);
                            },
                          ),
                        ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.recentLikes,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (recentList == null || recentList.isEmpty)
                        SizedBox(
                          height: 120,
                          child: Center(
                            child: Text(
                                AppLocalizations.of(context)!.todoNotAvailable),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: recentList.length,
                            itemBuilder: (context, index) {
                              final like = recentList[index];
                              return CustomList(like: like!);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomList extends StatelessWidget {
  const MyCustomList({
    super.key,
    required this.imageUrl,
    required this.todo,
  });

  final String imageUrl;
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                width: 120,
                height: 100, // Fixed width for image
                fit: BoxFit.cover,
                imageUrl: imageUrl, // Use imageUrl from like
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.amber,
                  child: const Icon(
                    Icons.error,
                    size: 25,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title, // Display todo title
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ), // Replace with your card widget
    );
  }
}

class CustomList extends StatelessWidget {
  const CustomList({
    super.key,
    required this.like,
  });

  final Todo like;

  @override
  Widget build(BuildContext context) {
    final imageUrl = like.image ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          horizontalTitleGap: 7,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              height: 55,
              width: 55, // Fixed width for image
              fit: BoxFit.cover,
              imageUrl: imageUrl, // Use imageUrl from like
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.amber,
                child: const Icon(
                  Icons.error,
                  size: 25,
                ),
              ),
            ),
          ),
          title: Text(
            like.title,
            style: const TextStyle(fontSize: 21),
          ), // Replace with the appropriate field from your like
          subtitle: Text(
            like.description,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
