import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:product_management/data/entities/todo/todo.dart';
import 'package:product_management/presentation/todo_update/todo_update_page.dart';
import 'package:product_management/provider/todo/todo_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class TodoItem extends ConsumerStatefulWidget {
  const TodoItem({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  TodoItemState createState() => TodoItemState();
}

class TodoItemState extends ConsumerState<TodoItem> {
  @override
  Widget build(BuildContext context) {
    final todoNotifier = ref.watch(todoNotifierProvider(widget.todo).notifier);
    final user = auth.FirebaseAuth.instance.currentUser;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: CachedNetworkImage(
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: widget.todo.image!,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.amber,
              child: const Icon(
                Icons.error,
                size: 60,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.todo.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  widget.todo.isPublish
                      ? const Icon(
                          Icons.public,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.lock,
                          color: Colors.black54,
                        ),
                ],
              ),
              const Divider(
                thickness: 1,
                color: Colors.black45,
                height: 1,
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.todo.description,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              const Divider(
                thickness: 1,
                color: Colors.black45,
                height: 1,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.black45,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.todo.createdBy,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.date_range,
                    color: Colors.black45,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm')
                        .format(widget.todo.createdAt),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              if (widget.todo.location != null && widget.todo.location != '')
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.black45,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.todo.location!,
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Row(
          children: [
            TextButton.icon(
                onPressed: () {
                  if (!widget.todo.likedByUsers.contains(user!.uid)) {
                    todoNotifier.updateLikes(
                      widget.todo.id,
                      widget.todo.likesCount + 1,
                      [...widget.todo.likedByUsers, user.uid],
                    );
                  } else {
                    todoNotifier.updateLikes(
                      widget.todo.id,
                      widget.todo.likesCount - 1,
                      widget.todo.likedByUsers
                          .where((uid) => uid != user.uid)
                          .toList(),
                    );
                  }
                },
                icon: Icon(
                  !widget.todo.likedByUsers.contains(user?.uid)
                      ? CupertinoIcons.heart
                      : CupertinoIcons.heart_fill,
                  size: 30,
                  color: Colors.red,
                ),
                label: Text('${widget.todo.likesCount}')),
            if (user!.email == widget.todo.createdBy)
              TextButton.icon(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TodoUpdatePage(todo: widget.todo);
                      }));
                    }
                  },
                  icon: const Icon(
                    CupertinoIcons.pencil,
                    size: 30,
                    color: Colors.black,
                  ),
                  label: const Text('Edit')),
          ],
        ),
      ],
    );
  }
}
