import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo/todo_bloc.dart';
import '../widgets/todo_app_bar.dart';
import '../widgets/todo_list.dart';
import '../widgets/todo_fab.dart';
import '../widgets/todo_filter_chips.dart';
import '../widgets/todo_search_bar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TodoAppBar(),
      body: Column(
        children: [
          const TodoSearchBar(),
          const TodoFilterChips(),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const LoadingWidget(),
                  loading: () => const LoadingWidget(),
                  loaded: (todos, filteredTodos, filter, searchQuery) {
                    if (filteredTodos.isEmpty) {
                      return EmptyStateWidget(
                        filter: filter,
                        hasSearchQuery: searchQuery.isNotEmpty,
                      );
                    }
                    return TodoList(todos: filteredTodos);
                  },
                  error: (message) => TodoErrorWidget(message: message),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: const TodoFAB(),
    );
  }
}