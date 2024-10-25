import 'package:flutter/material.dart';
import 'package:product_management/provider/todo/todo_notifier.dart';
import 'package:product_management/provider/todo/todo_state.dart';
import 'package:product_management/utils/utils.dart';
import 'package:product_management/widgets/common_dialog.dart';

class TodoImageSection extends StatelessWidget {
  const TodoImageSection(
      {super.key,
      required this.state,
      required this.todoNotifier,
      required this.context});

  final TodoState state;
  final TodoNotifier todoNotifier;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final imageData = state.imageData;
    final imageUrl = state.image;

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final image = await todoNotifier.imageData();
            if (image == null) {
              if (context.mounted) {
                showSnackBar(context, Messages.validateImgMsg,Colors.red);
              }
            } else {
              todoNotifier.setImageData(image);
            }
          },
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[500],
            backgroundImage: imageData != null
                ? MemoryImage(imageData)
                : (imageUrl != null && imageUrl.isNotEmpty)
                    ? NetworkImage(imageUrl)
                    : null,
            child: (imageData == null && (imageUrl == null || imageUrl.isEmpty))
                ? const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          Messages.selectImg,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

customSwitch(TodoNotifier todoNotifier, TodoState todoState) {
  return GestureDetector(
    onTap: () {
      todoNotifier.setIsPublish(!todoState.isPublish);
    },
    child: Container(
      width: 60, // Adjust size as needed
      height: 35, // Adjust size as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: todoState.isPublish ? Colors.green : Colors.grey,
      ),
      child: Stack(
        children: [
          Align(
            alignment: todoState.isPublish
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                todoState.isPublish ? Icons.public : Icons.lock,
                color: Colors.white,
                size: 24, // Adjust icon size as needed
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
