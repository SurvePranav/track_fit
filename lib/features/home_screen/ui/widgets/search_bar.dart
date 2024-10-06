import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final VoidCallback onPressed;
  final TextEditingController textEditingController;
  const MySearchBar(
      {super.key,
      required this.textEditingController,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: Colors.white24,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Search Recipes...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => onPressed(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onPressed,
          ),
          const SizedBox(
            width: 3,
          ),
        ],
      ),
    );
  }
}
