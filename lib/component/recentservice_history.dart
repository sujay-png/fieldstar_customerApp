import 'package:flutter/material.dart';

class RecentServiceHistoryCard extends StatelessWidget {
  final String equipmentName;
  final String ticketId;

  final String status;
  final VoidCallback? onTap;

  const RecentServiceHistoryCard({
    super.key,
    required this.equipmentName,
    required this.ticketId,

    this.status = "Completed",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipmentName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                 
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFA7F3D0),
                ),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Color(0xFF059669),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}