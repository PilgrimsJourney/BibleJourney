import 'package:flutter/material.dart';
import '../../models/reading_plan.dart';
import '../../models/user.dart';

class ReadingCard extends StatelessWidget {
  const ReadingCard({
    super.key,
    required this.reading,
  });

  final Reading reading;

  void _toggleCompletion() {
    if (globalUser?.value != null) {
      reading.isCompleted = !reading.isCompleted;
      globalUser?.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = reading.isCompleted;
    
    return GestureDetector(
      onTap: _toggleCompletion,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: isCompleted 
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.primary,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  reading.reference,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: isCompleted 
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: isCompleted
                    ? Padding(
                        key: const ValueKey('completed'),
                        padding: const EdgeInsets.only(top: 16),
                        child: Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                          size: 32,
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('not_completed')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

