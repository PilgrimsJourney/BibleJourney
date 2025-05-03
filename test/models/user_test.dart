import 'package:flutter_test/flutter_test.dart';
import 'package:bible_journey/models/user.dart'; // Adjust based on your package name
import 'package:bible_journey/models/reading_plan.dart'; // Adjust based on your package name

void main() {
    group('User', () {
        test('should instantiate with correct properties', () {
            final user = User();

            expect(user.language, equals("en"));
            expect(user.readingPlan, isNull);
        });

        test('properties are mutable', () {
            final plan1 = UserReadingPlan(
              name: "Test Plan 1",
              streams: [],
            );
            final plan2 = UserReadingPlan(
              name: "Test Plan 2",
              streams: [],
            );
            final user = User(
                language: "fr",
                readingPlan: plan1
            );

            expect(user.language, equals("fr"));
            expect(user.readingPlan, equals(plan1));

            user.language = "es";
            user.readingPlan = plan2;

            expect(user.language, equals("es"));
            expect(user.readingPlan, equals(plan2));
        });
    });
}

