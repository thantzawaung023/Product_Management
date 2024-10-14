import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../utils/utils.dart';

class UserSearchInput extends HookWidget {
  final Function(String) onChanged;

  const UserSearchInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final showClearButton = useState(false);

    useEffect(() {
      textController.addListener(() {
        showClearButton.value = textController.text.isNotEmpty;
      });
      return () => textController.dispose();
    }, []);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: textController,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: Messages.searchUser,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: showClearButton.value
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    textController.clear();
                    onChanged('');
                  },
                )
              : null,
        ),
      ),
    );
  }
}
