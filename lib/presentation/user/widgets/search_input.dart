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
      // Listener function to update the clear button visibility
      void listener() {
        showClearButton.value = textController.text.isNotEmpty;
      }

      // Add the listener
      textController.addListener(listener);

      // Return a cleanup function to remove the listener
      return () {
        textController.removeListener(listener);
      };
    }, [textController]); // Add textController as a dependency

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          onChanged(value); // Pass the changed value
        },
        decoration: InputDecoration(
          hintText: Messages.searchUser, // Fallback for null
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: showClearButton.value
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    textController.clear();
                    onChanged(''); // Notify about the clear action
                  },
                )
              : null,
        ),
      ),
    );
  }
}
