import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/dream_controller.dart';
import '../controllers/main_screen.dart';
import '../nav_bar.dart';
import 'Add/Edit Dream Screen.dart';
import 'Calendar Screen.dart';
import 'Dream List Screen.dart';
import 'Search Screen.dart';
import 'Tags Screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.put(MainScreenController());
    final dreamController = Get.put(DreamController());

    return Scaffold(
      body: Obx(() {
        switch (mainController.currentTab.value) {
          case 0:
            return const DreamListScreen();
          case 1:
            return const CalendarScreen();
          case 2:
            return const SearchScreen();
          case 3:
            return const TagsScreen();
          default:
            return const DreamListScreen();
        }
      }),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: mainController.currentTab.value,
        onTap: (index) => mainController.currentTab.value = index,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddEditDreamScreen()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}