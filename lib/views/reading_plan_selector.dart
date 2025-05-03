// lib/views/reading_plan_selector.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../adapters/user_storage_adapter.dart';
import '../models/reading_plan.dart';
import '../models/user.dart';

class ReadingPlanSelector extends StatefulWidget {
  const ReadingPlanSelector({super.key});

  @override
  _ReadingPlanSelectorState createState() => _ReadingPlanSelectorState();
}

class _ReadingPlanSelectorState extends State<ReadingPlanSelector> {
  @override
  void initState() {
    super.initState();
    // Ensure globalUser is initialized (set in main.dart)
    if (globalUser == null) {
      globalUser = User();
      Hive.box<User>('userBox').put('currentUser', globalUser!); // Fallback
    }
  }

  void copyReadingPlan(int planIndex, List<int> streamIndices) {
    final selectedPlan = placeholderReadingPlans[planIndex];
    final userPlan = UserReadingPlan.fromReadingPlan(selectedPlan, streamIndices);
    setState(() {
      globalUser!.readingPlan = userPlan; // Triggers notifyListeners
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Selected: ${userPlan.name}")),
    );
  }

  void addStreamToPlan(int planIndex, int streamIndex) {
    final selectedPlan = placeholderReadingPlans[planIndex];
    setState(() {
      if (globalUser!.readingPlan == null) {
        globalUser!.readingPlan = UserReadingPlan(name: selectedPlan.name, streams: []);
      }
      globalUser!.readingPlan!.addStreamFromPlan(selectedPlan, streamIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Added stream: ${selectedPlan.streams[streamIndex].name}")),
    );
  }

  void removeStreamFromPlan(String streamName) {
    if (globalUser!.readingPlan != null) {
      setState(() {
        globalUser!.readingPlan!.removeStreamByName(streamName);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Removed stream: $streamName")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Reading Plan")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => copyReadingPlan(0, [0]),
            child: const Text("Start Chronological"),
          ),
          ElevatedButton(
            onPressed: () => copyReadingPlan(1, [0, 2]),
            child: const Text("Start M'Cheyne (Family 1, Private 1)"),
          ),
          ElevatedButton(
            onPressed: () => addStreamToPlan(1, 3),
            child: const Text("Add M'Cheyne Private Reading 2"),
          ),
          ElevatedButton(
            onPressed: () => removeStreamFromPlan("Private Reading 2"),
            child: const Text("Remove Private Reading 2"),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<User>('userBox').listenable(),
              builder: (context, Box<User> box, _) {
                final userPlan = globalUser?.readingPlan;
                if (userPlan == null) {
                  return const Text("No plan selected");
                }
                return ListView(
                  children: [
                    Text("Plan: ${userPlan.name}", style: const TextStyle(fontSize: 18)),
                    ...userPlan.streams.map((stream) => ExpansionTile(
                          title: Text(stream.name),
                          children: stream.readings.map((reading) {
                            return CheckboxListTile(
                              title: Text(reading.reference),
                              value: reading.isCompleted,
                              onChanged: (value) {
                                setState(() {
                                  reading.isCompleted = value ?? false;
                                  // Manual save for internal changes
                                  Hive.box<User>('userBox').put('currentUser', globalUser!);
                                });
                              },
                            );
                          }).toList(),
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
