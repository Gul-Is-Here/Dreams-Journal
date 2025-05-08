import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../controllers/dream_controller.dart';
import '../../models/dream_model.dart';

class AddEditDreamScreen extends StatefulWidget {
  final Dream? dream;

  const AddEditDreamScreen({super.key, this.dream});

  @override
  State<AddEditDreamScreen> createState() => _AddEditDreamScreenState();
}

class _AddEditDreamScreenState extends State<AddEditDreamScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late List<String> _tags;
  late String _mood;
  late DateTime _date;

  final List<String> _availableMoods = ['😊', '😢', '😨', '😴', '🤯', '😍', '👻'];

  @override
  void initState() {
    super.initState();
    final dream = widget.dream;
    _titleController = TextEditingController(text: dream?.title ?? '');
    _descriptionController = TextEditingController(text: dream?.description ?? '');
    _tags = dream?.tags.toList() ?? [];
    _mood = dream?.mood ?? '😊';
    _date = dream?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dream == null ? 'Add Dream' : 'Edit Dream'),
        actions: [
          if (widget.dream != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteDream,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildMoodSelector(),
              const SizedBox(height: 16),
              _buildTagInput(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveDream,
                child: const Text('Save Dream'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        const Text('Date: '),
        TextButton(
          onPressed: () async {
            final newDate = await showDatePicker(
              context: context,
              initialDate: _date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (newDate != null) {
              setState(() => _date = newDate);
            }
          },
          child: Text(DateFormat('MMM dd, yyyy').format(_date)),
        ),
      ],
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mood:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _availableMoods.map((mood) {
            return ChoiceChip(
              label: Text(mood, style: const TextStyle(fontSize: 24)),
              selected: _mood == mood,
              onSelected: (selected) {
                setState(() => _mood = mood);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTagInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tags:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tags.map((tag) {
            return Chip(
              label: Text(tag),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                setState(() => _tags.remove(tag));
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Add Tag',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty && !_tags.contains(value)) {
              setState(() => _tags.add(value));
            }
          },
        ),
      ],
    );
  }

  Future<void> _saveDream() async {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<DreamController>();
      final dream = Dream(
        id: widget.dream?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        tags: _tags,
        mood: _mood,
        date: _date,
      );

      await controller.saveDream(dream);

      Get.back(); // Close the add/edit screen
      Get.until((route) => route.isFirst); // Go back to home

      // Show success snackbar
      Get.snackbar(
        'Dream Saved',
        'Your dream has been recorded successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
  Future<void> _deleteDream() async {
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final controller = Get.find<DreamController>();
      await controller.deleteDream(widget.dream!.id);
      Get.back();
    }
  }
}