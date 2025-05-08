import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/dream_controller.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DreamController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dream Calendar'),
      ),
      body: Obx(() {
        return TableCalendar(
          firstDay: DateTime(2000),
          lastDay: DateTime.now(),
          focusedDay: controller.selectedDate.value ?? DateTime.now(),
          selectedDayPredicate: (day) {
            return isSameDay(controller.selectedDate.value, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            controller.selectedDate.value =
            isSameDay(controller.selectedDate.value, selectedDay)
                ? null
                : selectedDay;
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              final hasDream = controller.dreams.any((dream) =>
                  isSameDay(dream.date, date));

              if (hasDream) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        );
      }),
    );
  }
}