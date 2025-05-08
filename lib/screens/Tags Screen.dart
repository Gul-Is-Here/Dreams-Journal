import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/dream_controller.dart';
import '../controllers/main_screen.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DreamController>();
    final mainController = Get.find<MainScreenController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dream Tags'),
      ),
      body: Obx(() {
        if (controller.allTags.length <= 1) {
          return const Center(
            child: Text('No tags yet. Add tags to your dreams!'),
          );
        }

        return ListView.builder(
          itemCount: controller.allTags.length,
          itemBuilder: (context, index) {
            final tag = controller.allTags[index];
            if (tag == 'All') return const SizedBox();

            final count = controller.dreams
                .where((dream) => dream.tags.contains(tag))
                .length;

            return ListTile(
              title: Text(tag),
              trailing: Text('$count'),
              onTap: () {
                controller.selectedTag.value = tag;
                mainController.currentTab.value = 0;
              },
            );
          },
        );
      }),
    );
  }
}