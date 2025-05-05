import 'package:flutter/material.dart';
import '../models/reading_plan.dart';

class ReadingPlanProvider with ChangeNotifier {
  List<ReadingPlan>? _loadedReadingPlans;
  final Map<String, ReadingPlan> _planCache = {};

  Future<List<ReadingPlan>> getLoadedReadingPlans() async {
    if (_loadedReadingPlans == null) {
      final planIds = await ReadingPlan.listPlanIds();
      _loadedReadingPlans = [];
      for (final id in planIds) {
        final plan = await ReadingPlan.loadPlan(id);
        _loadedReadingPlans!.add(plan);
        _planCache[id] = plan;
      }
    }
    return _loadedReadingPlans!;
  }

  Future<ReadingPlan> getPlan(String id) async {
    if (!_planCache.containsKey(id)) {
      _planCache[id] = await ReadingPlan.loadPlan(id);
    }
    return _planCache[id]!;
  }

  void clearCache() {
    _loadedReadingPlans = null;
    _planCache.clear();
    notifyListeners();
  }
}
