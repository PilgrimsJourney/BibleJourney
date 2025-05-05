import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/foundation.dart';

class ReadingPlan {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final List<Stream> streams;

  ReadingPlan({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.streams,
  });

  static Future<List<String>> listPlanIds() async {
    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = jsonDecode(manifest);
      final planIds = manifestMap.keys
          .where((path) => path.startsWith('assets/data/reading_plans/'))
          .map((path) => path
              .replaceFirst('assets/data/reading_plans/', '')
              .replaceFirst(RegExp(r'\.json$'), ''))
          .toList();
      return planIds.isEmpty ? [] : planIds;
    } catch (e) {
      print('Error loading AssetManifest.json: $e');
      return [];
    }
  }

  static Future<ReadingPlan> loadPlan(String id) async {
    final jsonString = await rootBundle.loadString('assets/data/reading_plans/$id.json');
    final json = jsonDecode(jsonString);
    return ReadingPlan.fromJson(json);
  }

  factory ReadingPlan.fromJson(Map<String, dynamic> json) {
    return ReadingPlan(
      id: json['id'],
      nameKey: json['name_key'],
      descriptionKey: json['description_key'],
      streams: (json['streams'] as List<dynamic>)
          .map((s) => Stream.fromJson(s))
          .toList(),
    );
  }
}

class Stream {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final List<Reading> readings;

  Stream({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.readings,
  });

  factory Stream.fromJson(Map<String, dynamic> json) {
    return Stream(
      id: json['id'],
      nameKey: json['name_key'],
      descriptionKey: json['description_key'] ?? '',
      readings: (json['readings'] as List<dynamic>)
          .map((r) => Reading.fromJson(r))
          .toList(),
    );
  }
}

class Reading {
  final String reference;
  bool isCompleted;

  Reading({required this.reference, this.isCompleted = false});

  factory Reading.fromJson(String reference) {
    return Reading(reference: reference);
  }
}

class UserReadingPlan {
  final String nameKey;
  final String descriptionKey; // Added to match ReadingPlan
  List<Stream> streams;

  UserReadingPlan({
    required this.nameKey,
    required this.descriptionKey,
    required this.streams,
  });

  factory UserReadingPlan.fromReadingPlan(ReadingPlan plan, List<int> streamIndices) {
    final selectedStreams = streamIndices
        .where((index) => index >= 0 && index < plan.streams.length)
        .map((index) => Stream(
              id: plan.streams[index].id,
              nameKey: plan.streams[index].nameKey,
              descriptionKey: plan.streams[index].descriptionKey,
              readings: plan.streams[index].readings
                  .map((r) => Reading(
                        reference: r.reference,
                        isCompleted: false,
                      ))
                  .toList(),
            ))
        .toList();
    return UserReadingPlan(
      nameKey: plan.nameKey,
      descriptionKey: plan.descriptionKey,
      streams: selectedStreams,
    );
  }

  Future<void> addStreamFromPlan(String planId, int streamIndex) async {
    final plan = await ReadingPlan.loadPlan(planId);
    if (streamIndex >= 0 && streamIndex < plan.streams.length) {
      final newStream = Stream(
        id: plan.streams[streamIndex].id,
        nameKey: plan.streams[streamIndex].nameKey,
        descriptionKey: plan.streams[streamIndex].descriptionKey,
        readings: plan.streams[streamIndex].readings
            .map((r) => Reading(reference: r.reference, isCompleted: false))
            .toList(),
      );
      streams.add(newStream);
    }
  }

  void removeStreamById(String streamId) {
    streams.removeWhere((stream) => stream.id == streamId);
  }
}
