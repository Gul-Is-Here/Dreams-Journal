import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dream_model.dart';

class DreamController extends GetxController {
  final RxList<Dream> dreams = <Dream>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedTag = 'All'.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);


  @override
  void onInit() {
    super.onInit();
    loadDreams();
  }

  Future<void> loadDreams() async {
    final prefs = Get.find<SharedPreferences>();
    final dreamsJson = prefs.getStringList('dreams') ?? [];
    dreams.assignAll(dreamsJson.map((json) => Dream.fromJson(jsonDecode(json))));
    }

  Future<void> saveDream(Dream dream) async {
    if (dream.id.isEmpty) {
      dream = dream.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
    }

    final index = dreams.indexWhere((d) => d.id == dream.id);
    if (index >= 0) {
      dreams[index] = dream;
    } else {
      dreams.add(dream);
    }

    await _saveToPrefs();
  }

  Future<void> deleteDream(String id) async {
    dreams.removeWhere((dream) => dream.id == id);
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = Get.find<SharedPreferences>();
    await prefs.setStringList(
      'dreams',
      dreams.map((dream) => jsonEncode(dream.toJson())).toList(),
    );
  }

  List<Dream> get filteredDreams {
    var result = dreams.toList();

    if (searchQuery.value.isNotEmpty) {
      result = result.where((dream) =>
      dream.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          dream.description.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    if (selectedTag.value != 'All') {
      result = result.where((dream) => dream.tags.contains(selectedTag.value)).toList();
    }

    if (selectedDate.value != null) {
      result = result.where((dream) =>
      dream.date.year == selectedDate.value!.year &&
          dream.date.month == selectedDate.value!.month &&
          dream.date.day == selectedDate.value!.day)
          .toList();
    }

    return result..sort((a, b) => b.date.compareTo(a.date));
  }

  List<String> get allTags {
    final allTags = dreams.expand((dream) => dream.tags).toSet().toList();
    allTags.insert(0, 'All');
    return allTags;
  }
}