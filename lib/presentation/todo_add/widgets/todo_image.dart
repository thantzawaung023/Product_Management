import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product_management/provider/todo/todo_notifier.dart';
import 'package:product_management/provider/todo/todo_state.dart';
import 'package:product_management/widgets/common_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
                showSnackBar(context,
                    AppLocalizations.of(context)!.validateImgMsg, Colors.red);
              }
            } else {
              todoNotifier.setImageData(image);
            }
          },
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[500],
            backgroundImage: imageData != null ? MemoryImage(imageData) : null,
            child: imageData == null
                ? (imageUrl != null && imageUrl.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(), // Show loader
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error), // Handle error
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 60,
                          backgroundImage: imageProvider, // Use fetched image
                        ),
                      )
                    : const Icon(
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
          AppLocalizations.of(context)!.selectImage,
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
