import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.wordPair,
  });

  final WordPair wordPair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        );

    return Card(
        color: theme.colorScheme.primary,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
                "${wordPair.first} ${wordPair.second}",
                style: style,
                semanticsLabel: "${wordPair.first} ${wordPair.second}"
                ),
            
        ),
    );
  }
}

