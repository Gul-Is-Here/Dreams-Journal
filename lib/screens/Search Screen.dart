import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/dream_controller.dart';
import '../widgets/dream_card_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DreamController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Dreams'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.searchQuery.value = value,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.searchQuery.value.isEmpty) {
                return const Center(
                  child: Text('Enter search terms to find dreams'),
                );
              }

              if (controller.filteredDreams.isEmpty) {
                return const Center(
                  child: Text('No dreams found'),
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
          ),
        ],
      ),
    );
  }
}