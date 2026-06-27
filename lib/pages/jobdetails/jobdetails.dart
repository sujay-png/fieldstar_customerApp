import 'package:field_star_customer_app/model/raise_complaint_model.dart';
import 'package:field_star_customer_app/model/tech_model.dart';
import 'package:field_star_customer_app/model/timeline.dart';
import 'package:field_star_customer_app/service/techdetais_db.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Jobdetails extends StatefulWidget {
  final RaiseComplaintModel complaint;
  const Jobdetails({super.key, required this.complaint});

  @override
  State<Jobdetails> createState() => _JobdetailsState();
}

class _JobdetailsState extends State<Jobdetails> {
  TechModel? _techDetails;
  final techdb = TechdetaisDb();

  @override
  void initState() {
    super.initState();
    _loadTech();
  }

  Future<void> _loadTech() async {
    final tech = await techdb.fetchTechDetails(widget.complaint.tickectid);
    setState(() => _techDetails = tech);
  }

  @override
  Widget build(BuildContext context) {
    final complaint = widget.complaint; // ← use directly, no fetch needed
    final status = complaint.techstatus ?? 'Pending';

    Color statusColor;
    Color statusBgColor;
    switch (status) {
      case 'Completed':
        statusColor = Colors.green;
        statusBgColor = Colors.green.shade100;
        break;
      case 'In Progress':
        statusColor = Colors.deepPurple;
        statusBgColor = Colors.deepPurple.shade100;
        break;
      case 'Assigned':
        statusColor = Colors.blue;
        statusBgColor = Colors.blue.shade100;
        break;
      default:
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.shade100;
    }

    return Scaffold(
        backgroundColor: Colors.white70,

      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => context.go('/Home'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Track Complaint',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _techDetails != null
                      ? 'Technician ID: ${_techDetails!.techId}'
                      : 'Fetching technician...',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Technician card ───────────────────────────────────────
            _techDetails == null
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Technician not assigned'),
                  ))
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.deepOrange,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Icon(Icons.person, size: 25, color: Colors.deepOrange),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _techDetails!.fullName,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              'Technician ID: ${_techDetails!.techId}',
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _techDetails!.phone,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _makeCall(_techDetails!.phone),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange.withValues(alpha: 0.5),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.phone, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text('Call', style: TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                ElevatedButton(
                                  onPressed: () => _sendSms(_techDetails!.phone),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange.withValues(alpha: 0.5),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.message, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text('SMS', style: TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

            // ── Timeline ──────────────────────────────────────────────
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Service Timeline",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FixedTimeline.tileBuilder(
                    theme: TimelineThemeData(
                      nodePosition: 0,
                      connectorTheme: const ConnectorThemeData(thickness: 2),
                      indicatorTheme: const IndicatorThemeData(size: 26),
                    ),
                    builder: TimelineTileBuilder.connected(
                      itemCount: getTimelineItems(status).length,
                      connectionDirection: ConnectionDirection.before,
                      connectorBuilder: (_, index, _) => SolidLineConnector(
                        color: getTimelineItems(status)[index].completed
                            ? const Color(0xFF10B981)
                            : Colors.grey.shade300,
                      ),
                      indicatorBuilder: (_, index) {
                        final item = getTimelineItems(status)[index];
                        return DotIndicator(
                          color: item.completed
                              ? const Color(0xFF10B981)
                              : Colors.grey.shade300,
                          child: item.completed
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : null,
                        );
                      },
                      contentsBuilder: (_, index) {
                        final item = getTimelineItems(status)[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 14, bottom: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: item.completed ? Colors.black : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.time,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: item.completed ? Colors.black54 : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Invoice button ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _techDetails == null
                    ? null // disabled until tech loads
                    : () => context.go(
                          '/payment',
                          extra: {
                            'ticketId': complaint.tickectid,
                            'technicianId': _techDetails!.techId,
                            'technicianName': _techDetails!.fullName,
                            'equipment': complaint.serviceRequired,
                            'serviceDate': complaint.date?.toString() ?? '',
                          },
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C313A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "View Invoice & Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<TimelineItem> getTimelineItems(String status) {
    return [
      TimelineItem(title: "Complaint Registered", time: "Completed", completed: true),
      TimelineItem(
        title: "Technician Assigned",
        time: status == "Assigned" || status == "Pending" || status == "Completed"
            ? "Completed" : "Pending",
        completed: status == "Assigned" || status == "In Progress" || status == "Completed",
      ),
      TimelineItem(
        title: "Service in Progress",
        time: status == "In Progress" || status == "Completed" ? "Completed" : "Pending",
        completed: status == "In Progress" || status == "Completed",
      ),
      TimelineItem(
        title: "Service Completed",
        time: status == "Completed" ? "Completed" : "Pending",
        completed: status == "Completed",
      ),
    ];
  }

  Future<void> _makeCall(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open dialer')));
    }
  }

  Future<void> _sendSms(String phone) async {
    final Uri uri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open SMS app')));
    }
  }
}