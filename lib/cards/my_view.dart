import 'package:flutter/material.dart';

class ViewData extends StatelessWidget {
  final String service;
  final int condition;
  final int duration;
  final DateTime startDate;
  final DateTime endDate;

  ViewData({
    required this.service,
    required this.condition,
    required this.duration,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text('Service: $service'),
            subtitle: Text('Condition: $condition'),
          ),
          ListTile(
            title: Text('Duration: $duration'),
            subtitle: Text('Start Date: $startDate'),
          ),
        ],
      ),
    );
  }
}
