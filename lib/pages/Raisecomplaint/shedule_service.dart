import 'dart:io';
import 'dart:math';

import 'package:field_star_customer_app/model/raise_complaint_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleServicePage extends StatefulWidget {
  final String tickedID;
  final String categoryName;
  final String equipmentName;
  final String problemDescription;
  final File? imageFile;
  final String? audioPath;
  final String? priorityStatus;

  const ScheduleServicePage({
    super.key,
    required this.tickedID,
    required this.categoryName,
    required this.equipmentName,
    required this.problemDescription,
    this.imageFile,
    this.audioPath,
    this.priorityStatus,
  });

  @override
  State<ScheduleServicePage> createState() => _ScheduleServicePageState();
}

class _ScheduleServicePageState extends State<ScheduleServicePage> {
  DateTime? selectedDate;
  String serviceType = 'Emergency';

//=========================generate random tickect id====================================
  String generateTicketId() {
    final random = Random();
    return 'FS${100000 + random.nextInt(900000)}';
  }

//========================generate otp===================================
  String generateOtp() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }
//========================submit complaint================================
  Future<void> _submitFullcomplaint(
    RaiseComplaintModel complaint, {
    File? imageFile,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    String? imageUrl;
    if (imageFile != null) {
      try {
        final path =
            '${complaint.tickectid}/${DateTime.now().millisecondsSinceEpoch}';
       
        await Supabase.instance.client.storage
            .from('images')
            .upload(path, imageFile);

        imageUrl = Supabase.instance.client.storage
            .from('images')
            .getPublicUrl(path);        
      } catch (e) {
       
        rethrow; 
      }
    } 

    await Supabase.instance.client.from('Raise_complaint').insert({
      'Category_name': complaint.categoryName,
      'service_required': complaint.serviceRequired,
      'problem': complaint.problem,
      'priority_level': complaint.priorityLevel,
      'Date': complaint.date?.toIso8601String(),
      'tickectid': complaint.tickectid,
      'otp': complaint.otp,
      'image_url': imageUrl,
      'audio_url': complaint.audioUrl,
      'customer_id': user.id,
      'complaint_status': 'pending',
      'tech_status': 'Pending',
    });
  }

  Future<void> _onSubmitComplaint() async {
    final ticketId = generateTicketId();
    final otp = generateOtp();

    try {
      final complaint = RaiseComplaintModel(
        categoryName: widget.categoryName,
        serviceRequired: widget.equipmentName,
        problem: widget.problemDescription,
        priorityLevel: widget.priorityStatus,
        date: DateTime.now(),
        tickectid: ticketId,
        otp: otp,
        imageUrl: null,
        audioUrl: null,
      );

      await _submitFullcomplaint(
        complaint,
        imageFile: widget.imageFile, 
      );

      if (mounted) {
        context.push(
          '/servicecompleted',
          extra: {'tickectid': ticketId, 'otp': otp},
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Submission failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        leading: const BackButton(color: Colors.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Raise Complaint',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Step 4 of 4',
              style: TextStyle(color: Colors.blueGrey, fontSize: 11),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: ColoredBox(
            color: Colors.deepOrange,
            child: SizedBox(height: 3, width: double.infinity),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Schedule Service Visit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'When would you like our technician to visit?',
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 24),
                  
                  serviceCard(
                    type: 'Emergency',
                    title: 'Emergency Service',
                    subtitle: 'Technician arrives within 2 hours',
                    icon: Icons.warning_amber_rounded,
                    color: Colors.deepOrange,
                  ),

                  const SizedBox(height: 14),

                  serviceCard(
                    type: 'Later',
                    title: 'Schedule for Later',
                    subtitle: selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Choose preferred date & time',
                    icon: Icons.calendar_month,
                    color: Colors.blueGrey,
                    onTap: _selectDate,
                  ),

                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 14),
                        summaryRow('Equipment:', widget.equipmentName),
                        summaryRow('Priority:', widget.priorityStatus ?? '-'),
                        summaryRow('Service Type:', 'Emergency'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _onSubmitComplaint();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text('Submit Complaint'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //====================Helper function date picker===================
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2021, 7, 25),
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  Widget serviceCard({
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final selected = serviceType == type;

    return InkWell(
      onTap: () {
        setState(() => serviceType = type);
        onTap?.call(); // ✅ call if provided
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xfffff7ed) : Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selected ? Colors.deepOrange : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: selected
                  ? Colors.deepOrange
                  : Colors.grey.shade200,
              child: Icon(icon, color: selected ? Colors.white : color),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class summaryRow extends StatelessWidget {
  final String title, value;

  const summaryRow(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
