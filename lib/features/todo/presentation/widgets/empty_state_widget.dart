import 'package:flutter/material.dart';

import '../bloc/todo/todo_bloc.dart';

class EmptyStateWidget extends StatelessWidget {
  final TodoFilter filter;
  final bool hasSearchQuery;

  const EmptyStateWidget({
    super.key,
    required this.filter,
    required this.hasSearchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    String title;
    String subtitle;
    IconData icon;
    
    if (hasSearchQuery) {
      title = 'No results found';
      subtitle = 'Try adjusting your search terms';
      icon = Icons.search_off;
    } else {
      switch (filter) {
        case TodoFilter.all:
          title = 'No todos yet';
          subtitle = 'Tap the + button to create your first todo';
          icon = Icons.task_alt;
          break;
        case TodoFilter.active:
          title = 'No active todos';
          subtitle = 'All your todos are completed!';
          icon = Icons.check_circle;
          break;
        case TodoFilter.completed:
          title = 'No completed todos';
          subtitle = 'Complete some todos to see them here';
          icon = Icons.radio_button_unchecked;
          break;
        case TodoFilter.overdue:
          title = 'No overdue todos';
          subtitle = 'Great! You\'re on top of your tasks';
          icon = Icons.schedule;
          break;
        case TodoFilter.dueToday:
          title = 'Nothing due today';
          subtitle = 'Enjoy your free time!';
          icon = Icons.today;
          break;
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}