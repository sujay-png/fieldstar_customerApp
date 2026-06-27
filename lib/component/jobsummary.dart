import 'package:flutter/material.dart';

class JobSummaryCard extends StatelessWidget {
  final String ticketId;
  final String status;
  final String equipment;
  final String issue;
  final String technician;
  final String? eta;
  final VoidCallback? onTap;
  final String? complaintstatus;

  const JobSummaryCard({
    super.key,
    required this.ticketId, 
    required this.status,
    required this.equipment,
    required this.issue,
    required this.technician,
     this.eta,
    this.onTap,
     this.complaintstatus,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      
      onTap: onTap,
      child: Container(
     
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ticketId,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              equipment,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              issue,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            Divider(
              color: Colors.grey.shade300,
              height: 1,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xffE0E7FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.build_outlined,
                    size: 14,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  technician,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),

                const Spacer(),

               Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    complaintstatus?? 'pending',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}