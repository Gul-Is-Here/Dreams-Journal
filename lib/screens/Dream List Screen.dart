import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/dream_controller.dart';
import '../widgets/dream_card_widget.dart';

class DreamListScreen extends StatelessWidget {
  const DreamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DreamController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dreams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => Get.changeThemeMode(
              Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.dreams.isEmpty) {
          return const Center(
            child: Text('No dreams recorded yet. Tap + to add one!'),
          );
        }

        return ListView.builder(
          itemCount: controller.filteredDreams.length,
          itemBuilder: (context, index) {
            final dream = controller.filteredDreams[index];
            return DreamCard(dream: dream);
          },
        );
      }),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final controller = Get.find<DreamController>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Dreams'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: controller.selectedTag.value,
                items: controller.allTags.map((tag) {
                  return DropdownMenuItem(
                    value: tag,
                    child: Text(tag),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedTag.value = value!;
                },
                decoration: const InputDecoration(labelText: 'Filter by Tag'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  controller.selectedDate.value = null;
                  controller.selectedTag.value = 'All';
                  Get.back();
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}