import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final Future<void> Function() onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: _isLoading ? null : _handleTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: _isLoading
              ?  CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                )
              : Text(
                  widget.label,
                  style:  TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _handleTap() async {
    if (!mounted) return; // Check if the widget is still in the tree
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onPressed(); // Execute the async function
    } finally {
      if (mounted) {
        // Check again before calling setState
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}


