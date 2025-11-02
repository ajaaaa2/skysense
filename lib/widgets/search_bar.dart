
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const CustomSearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search city...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  widget.onSearch(_controller.text);
                  _controller.clear();
                }
              },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              widget.onSearch(value);
              _controller.clear();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}