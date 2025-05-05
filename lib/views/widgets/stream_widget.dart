import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/reading_plan.dart';
import 'reading_card.dart';

class StreamWidget extends StatelessWidget {
  const StreamWidget({
    super.key,
    required this.stream,
  });

  final Stream stream;

  int _findFirstUncompletedIndex() {
    return stream.readings.indexWhere((reading) => !reading.isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    // Find the first uncompleted reading index, default to 0 if all are completed
    final initialPage = _findFirstUncompletedIndex();
    final startIndex = initialPage != -1 ? initialPage : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //   child: Text(
        //     Intl.message(stream.nameKey),
        //     style: Theme.of(context).textTheme.titleLarge?.copyWith(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 200, // Fixed height for the card container
          child: PageView.builder(
            itemCount: stream.readings.length,
            controller: PageController(
              viewportFraction: 0.9, // Shows a bit of next/previous cards
              initialPage: startIndex, // Start at first uncompleted reading
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ReadingCard(reading: stream.readings[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
