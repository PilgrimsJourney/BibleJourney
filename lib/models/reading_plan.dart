// lib/models/reading_plan.dart
class ReadingPlan {
  final String name;
  final List<Stream> streams;

  ReadingPlan({
    required this.name,
    required this.streams,
  });
}

class Stream {
  final String name;
  final List<Reading> readings;

  Stream({
    required this.name,
    required this.readings,
  });
}

class Reading {
  final String reference;
  bool isCompleted;

  Reading({
    required this.reference,
    this.isCompleted = false,
  });
}

class UserReadingPlan {
  final String name;
  List<Stream> streams; // Removed 'final' to allow modification

  UserReadingPlan({
    required this.name,
    required this.streams,
  });

  factory UserReadingPlan.fromReadingPlan(ReadingPlan plan, List<int> streamIndices) {
    final selectedStreams = streamIndices
        .where((index) => index >= 0 && index < plan.streams.length)
        .map((index) => Stream(
              name: plan.streams[index].name,
              readings: plan.streams[index].readings
                  .map((reading) => Reading(
                        reference: reading.reference,
                        isCompleted: reading.isCompleted,
                      ))
                  .toList(),
            ))
        .toList();
    return UserReadingPlan(
      name: plan.name,
      streams: selectedStreams,
    );
  }

  void addStreamFromPlan(ReadingPlan plan, int streamIndex) {
    if (streamIndex >= 0 && streamIndex < plan.streams.length) {
      final newStream = Stream(
        name: plan.streams[streamIndex].name,
        readings: plan.streams[streamIndex].readings
            .map((reading) => Reading(
                  reference: reading.reference,
                  isCompleted: false, // New stream starts uncompleted
                ))
            .toList(),
      );
      streams.add(newStream);
    }
  }

  void removeStreamByName(String name) {  // Using name for now, might need to switch to an ID or joint plan & stream name
    streams.removeWhere((stream) => stream.name == name);
  }
}

List<ReadingPlan> placeholderReadingPlans = [
  ReadingPlan(
    name: "Chronological",
    streams: [
      Stream(
        name: "Main Stream",
        readings: [
          Reading(reference: "Gen.1:1-31"),
          Reading(reference: "Gen.2:1-25"),
          Reading(reference: "Gen.3:1-24"),
        ],
      ),
    ],
  ),
  ReadingPlan(
    name: "M'Cheyne",
    streams: [
      Stream(
        name: "Family Reading 1",
        readings: [
          Reading(reference: "Gen.1:1-31"),
          Reading(reference: "Gen.2:1-25"),
        ],
      ),
      Stream(
        name: "Family Reading 2",
        readings: [
          Reading(reference: "Matt.1:1-25"),
          Reading(reference: "Matt.2:1-23"),
        ],
      ),
      Stream(
        name: "Private Reading 1",
        readings: [
          Reading(reference: "Exod.1:1-22"),
          Reading(reference: "Exod.2:1-25"),
        ],
      ),
      Stream(
        name: "Private Reading 2",
        readings: [
          Reading(reference: "Ps.1:1-6"),
          Reading(reference: "Ps.2:1-12"),
        ],
      ),
    ],
  ),
];
