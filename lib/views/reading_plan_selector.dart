import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/user.dart';
import '../models/reading_plan.dart';
import '../providers/reading_plan_provider.dart';

class ReadingPlanSelector extends StatefulWidget {
  const ReadingPlanSelector({super.key});

  @override
  _ReadingPlanSelectorState createState() => _ReadingPlanSelectorState();
}

class _ReadingPlanSelectorState extends State<ReadingPlanSelector> {
  @override
  void initState() {
    super.initState();
    // Ensure globalUser is initialized
    if (globalUser == null) {
      globalUser = User();
      Hive.box<User>('userBox').put('currentUser', globalUser!);
    }
  }


  void copyReadingPlan(ReadingPlan plan, List<int> streamIndices) {
    final userPlan = UserReadingPlan.fromReadingPlan(plan, streamIndices);
    setState(() {
      globalUser!.readingPlan = userPlan;
      Hive.box<User>('userBox').put('currentUser', globalUser!);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Selected: ${userPlan.nameKey}")),
    );
  }

  void startEntirePlan(ReadingPlan plan) {
    final streamIndices = List<int>.generate(plan.streams.length, (i) => i);
    final userPlan = UserReadingPlan.fromReadingPlan(plan, streamIndices);
    setState(() {
      globalUser!.readingPlan = userPlan;
      Hive.box<User>('userBox').put('currentUser', globalUser!);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Started entire plan: ${userPlan.nameKey}")),
    );
  }

  void addStreamToPlan(ReadingPlan plan, int streamIndex) async {
    setState(() {
      if (globalUser!.readingPlan == null) {
        globalUser!.readingPlan = UserReadingPlan(
          nameKey: plan.nameKey,
          descriptionKey: plan.descriptionKey,
          streams: [],
        );
      }
    });
    await globalUser!.readingPlan!.addStreamFromPlan(plan.id, streamIndex);
    setState(() {
      Hive.box<User>('userBox').put('currentUser', globalUser!);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Added stream: ${AppLocalizations.of(context).translate(plan.streams[streamIndex].nameKey)}")),
    );
  }

  void removeStreamFromPlan(String streamId) {
    if (globalUser!.readingPlan != null) {
      setState(() {
        globalUser!.readingPlan!.removeStreamById(streamId);
        Hive.box<User>('userBox').put('currentUser', globalUser!);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Removed stream: $streamId")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10ner = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10ner.translate("readingPlanTitle"))),
      body: FutureBuilder<List<ReadingPlan>>(
        future: Provider.of<ReadingPlanProvider>(context).getLoadedReadingPlans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final plans = snapshot.data ?? [];
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, planIndex) {
                    final plan = plans[planIndex];
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(l10ner.translate(plan.nameKey)),
                            subtitle: Text(l10ner.translate(plan.descriptionKey)),
                            trailing: ElevatedButton(
                              onPressed: () => startEntirePlan(plan),
                              child: Text(l10ner.translate('startReadingPlan')),
                            ),
                          ),
                          ExpansionTile(
                            title: Text(l10ner.translate('availableStreams')),
                            children: [
                          ...plan.streams.asMap().entries.map((entry) {
                            final streamIndex = entry.key;
                            final stream = entry.value;
                            return ListTile(
                              title: Text(l10ner.translate(stream.nameKey)),
                              subtitle: Text(l10ner.translate(stream.descriptionKey)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () => addStreamToPlan(plan, streamIndex),
                                    tooltip: "Add Stream",
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () => removeStreamFromPlan(stream.id),
                                    tooltip: "Remove Stream",
                                  ),
                                ],
                              ),
                              onTap: () {
                                copyReadingPlan(plan, [streamIndex]);
                              },
                            );
                          }),
                        ],
                      ),
					  ]
                    )
					);
                  },
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<User>('userBox').listenable(),
                  builder: (context, Box<User> box, _) {
                    final userPlan = globalUser?.readingPlan;
                    if (userPlan == null) {
                      return Center(child: Text(l10ner.translate("noPlanSelected")));
                    }
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Current Plan: ${AppLocalizations.of(context).translate(userPlan.nameKey)}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        ...userPlan.streams.map((stream) => ExpansionTile(
                              title: Text(l10ner.translate(stream.nameKey)),
                              subtitle: Text(l10ner.translate(stream.descriptionKey)),
                              children: stream.readings.map((reading) {
                                return CheckboxListTile(
                                  title: Text(reading.reference),
                                  value: reading.isCompleted,
                                  onChanged: (value) {
                                    setState(() {
                                      reading.isCompleted = value ?? false;
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
          );
        },
      ),
    );
  }
}
