import 'package:flutter/material.dart';
import '../../models/reading_plan.dart';
import '../../models/user.dart';
import 'widgets/stream_widget.dart';

class ReadingView extends StatelessWidget {
  const ReadingView({super.key});

  @override
  Widget build(BuildContext context) {
    if (globalUser == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ValueListenableBuilder<User?>(
      valueListenable: globalUser!,
      builder: (context, user, child) {
        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final readingPlan = user.readingPlan;

        if (readingPlan == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Reading Plan Selected',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a reading plan to get started',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: Text(readingPlan.name),
              centerTitle: true,
              floating: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final stream = readingPlan.streams[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: StreamWidget(stream: stream),
                    );
                  },
                  childCount: readingPlan.streams.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
