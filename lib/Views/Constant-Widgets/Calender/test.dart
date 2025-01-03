import 'package:flutter/material.dart';

import 'Calender.dart'; // Import the custom widget




class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({super.key});

  @override
  _DateSelectionScreenState createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime selectedDate = DateTime.now();

  void _handleDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Picker Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Date: ${selectedDate.toString()}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            DatePickerWidget(
              initialDate: selectedDate,
              onDateSelected: _handleDateSelected,
            ),
          ],
        ),
      ),
    );
  }
}