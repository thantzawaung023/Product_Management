import 'package:flutter/material.dart';
import 'package:product_management/provider/user/user_state.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/utils/utils.dart';
import 'package:product_management/widgets/common_dialog.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection(
      {super.key,
      required this.state,
      required this.viewModel,
      required this.context});

  final UserState state;
  final UserViewModel viewModel;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final imageData = state.imageData;
    final profileUrl = state.profile;

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final image = await viewModel.imageData();
            if (image == null) {
              if (context.mounted) {
                showSnackBar(context, Messages.validateImgMsg, Colors.red);
              }
            } else {
              viewModel.setImageData(image);
            }
          },
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[500],
            backgroundImage: imageData != null
                ? MemoryImage(imageData)
                : (profileUrl != null && profileUrl.isNotEmpty)
                    ? NetworkImage(profileUrl)
                    : null,
            child: (imageData == null &&
                    (profileUrl == null || profileUrl.isEmpty))
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
          Messages.selectProfileImg,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
