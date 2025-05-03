// test/models/reading_plan_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bible_journey/models/reading_plan.dart'; // Adjust based on your package name

void main() {
  group('ReadingPlan', () {
    test('should instantiate with correct properties', () {
      final stream = Stream(
        name: "Test Stream",
        readings: [Reading(reference: "Gen.1:1-31")],
      );
      final plan = ReadingPlan(
        name: "Test Plan",
        streams: [stream],
      );

      expect(plan.name, equals("Test Plan"));
      expect(plan.streams, equals([stream]));
      expect(plan.streams.length, equals(1));
      expect(plan.streams.first.name, equals("Test Stream"));
    });

    test('should handle empty streams list', () {
      final plan = ReadingPlan(
        name: "Empty Plan",
        streams: [],
      );

      expect(plan.name, equals("Empty Plan"));
      expect(plan.streams, isEmpty);
    });
  });

  group('Stream', () {
    test('should instantiate with correct properties', () {
      final reading = Reading(reference: "Gen.1:1-31");
      final stream = Stream(
        name: "Test Stream",
        readings: [reading],
      );

      expect(stream.name, equals("Test Stream"));
      expect(stream.readings, equals([reading]));
      expect(stream.readings.length, equals(1));
      expect(stream.readings.first.reference, equals("Gen.1:1-31"));
    });

    test('should handle empty readings list', () {
      final stream = Stream(
        name: "Empty Stream",
        readings: [],
      );

      expect(stream.name, equals("Empty Stream"));
      expect(stream.readings, isEmpty);
    });
  });

  group('Reading', () {
    test('should instantiate with correct properties and default isCompleted', () {
      final reading = Reading(reference: "Gen.1:1-31");

      expect(reading.reference, equals("Gen.1:1-31"));
      expect(reading.isCompleted, isFalse);
    });

    test('should allow setting isCompleted', () {
      final reading = Reading(reference: "Gen.1:1-31", isCompleted: true);

      expect(reading.isCompleted, isTrue);

      reading.isCompleted = false;
      expect(reading.isCompleted, isFalse);
    });
  });

  group('UserReadingPlan', () {
    test('should instantiate with correct properties', () {
      final stream = Stream(
        name: "Test Stream",
        readings: [Reading(reference: "Gen.1:1-31")],
      );
      final userPlan = UserReadingPlan(
        name: "User Test Plan",
        streams: [stream],
      );

      expect(userPlan.name, equals("User Test Plan"));
      expect(userPlan.streams, equals([stream]));
      expect(userPlan.streams.length, equals(1));
      expect(userPlan.streams.first.name, equals("Test Stream"));
    });

    test('should add a stream from a ReadingPlan', () {
      final userPlan = UserReadingPlan(name: "Test Plan", streams: []);
      final readingPlan = placeholderReadingPlans[0]; // Chronological
      userPlan.addStreamFromPlan(readingPlan, 0); // Add Main Stream
  
      expect(userPlan.streams.length, equals(1));
      expect(userPlan.streams[0].name, equals("Main Stream"));
      expect(userPlan.streams[0].readings[0].isCompleted, isFalse);
    });

    test('should handle empty streams list', () {
      final userPlan = UserReadingPlan(
        name: "Empty User Plan",
        streams: [],
      );

      expect(userPlan.name, equals("Empty User Plan"));
      expect(userPlan.streams, isEmpty);
    });

    test('should remove a stream by name', () {
      final stream = Stream(
        name: "Test Stream",
        readings: [Reading(reference: "Gen.1:1-31")],
      );
      final userPlan = UserReadingPlan(name: "Test Plan", streams: [stream]);
      userPlan.removeStreamByName("Test Stream");
  
      expect(userPlan.streams, isEmpty);
    });
  });

  group('placeholderReadingPlans', () {
    test('should contain correct number of plans', () {
      expect(placeholderReadingPlans.length, equals(2));
    });

    test('should have Chronological plan with correct structure', () {
      final chronological = placeholderReadingPlans[0];
      expect(chronological.name, equals("Chronological"));
      expect(chronological.streams.length, equals(1));
      expect(chronological.streams[0].name, equals("Main Stream"));
      expect(chronological.streams[0].readings.length, equals(3));
      expect(chronological.streams[0].readings[0].reference, equals("Gen.1:1-31"));
      expect(chronological.streams[0].readings[1].reference, equals("Gen.2:1-25"));
      expect(chronological.streams[0].readings[2].reference, equals("Gen.3:1-24"));
    });

    test('should have M\'Cheyne plan with correct structure', () {
      final mCheyne = placeholderReadingPlans[1];
      expect(mCheyne.name, equals("M'Cheyne"));
      expect(mCheyne.streams.length, equals(4));
      expect(mCheyne.streams[0].name, equals("Family Reading 1"));
      expect(mCheyne.streams[0].readings.length, equals(2));
      expect(mCheyne.streams[0].readings[0].reference, equals("Gen.1:1-31"));
      expect(mCheyne.streams[1].name, equals("Family Reading 2"));
      expect(mCheyne.streams[2].name, equals("Private Reading 1"));
      expect(mCheyne.streams[3].name, equals("Private Reading 2"));
    });
  });
}
