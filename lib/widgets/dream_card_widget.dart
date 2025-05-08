import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/dream_controller.dart';
import '../models/dream_model.dart';
import '../screens/Add/Edit Dream Screen.dart';


class DreamCard extends StatelessWidget {
  final Dream dream;

  const DreamCard({super.key, required this.dream});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => Get.to(() => AddEditDreamScreen(dream: dream)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dream.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(dream.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                dream.description.length > 100
                    ? '${dream.description.substring(0, 100)}...'
                    : dream.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(dream.mood, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Wrap(
                    spacing: 4,
                    children: dream.tags
                        .map((tag) => Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                    ))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.share),
                  //     onPressed: () => _shareDream(context),
                  // ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _confirmDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _shareDream(BuildContext context) {
  //   final formattedDate = DateFormat('MMMM dd, yyyy').format(dream.date);
  //
  //   final String shareContent =
  //       '🌟 My Dream - ${dream.title} 🌟\n\n'
  //       '${dream.description}\n\n'
  //       '📅 Date: $formattedDate\n'
  //       '😊 Mood: ${dream.mood}\n'
  //       '🏷️ Tags: ${dream.tags.join(', ')}\n\n'
  //       '✨ Shared via Dream Journal App ✨';
  //
  //   SharePlus.instance.share(
  //      ShareContent.text(
  //       text: shareContent,
  //       subject: 'My Dream',
  //     ),
  //   );
  // }

  Future<void> _confirmDelete() async {
    final confirmed = await Get.dialog(
      AlertDialog(
        title: const Text('Delete Dream'),
        content: const Text('Are you sure you want to delete this dream?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final controller = Get.find<DreamController>();
      await controller.deleteDream(dream.id);

      Get.snackbar(
        'Dream Deleted',
        'Your dream has been removed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
}