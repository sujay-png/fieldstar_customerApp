import 'package:flutter/material.dart';

class EquipmentCard extends StatelessWidget {
  final String title;
  final String model;
  final String location;
  final String lastService;
  final VoidCallback? onTap;

  const EquipmentCard({
    super.key,
    required this.title,
    required this.model,
    required this.location,
    required this.lastService,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(model,
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_pin,
                    size: 13, color: Colors.pinkAccent),
                const SizedBox(width: 4),
                Text(location,
                    style:
                        const TextStyle(fontSize: 10, color: Colors.blueGrey)),
                const SizedBox(width: 16),
                Text('Last service: $lastService',
                    style:
                        const TextStyle(fontSize: 10, color: Colors.blueGrey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}