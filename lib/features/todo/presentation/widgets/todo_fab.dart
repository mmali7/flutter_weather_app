import 'package:flutter/material.dart';

import '../pages/add_edit_todo_page.dart';

class TodoFAB extends StatelessWidget {
  const TodoFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddEditTodoPage(),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}