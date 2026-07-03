import 'package:field_star_customer_app/component/jobsummary.dart';
import 'package:field_star_customer_app/component/recentservice_history.dart';
import 'package:field_star_customer_app/model/raise_complaint_model.dart';
import 'package:field_star_customer_app/pages/Raisecomplaint/raise_complaint.dart';
import 'package:field_star_customer_app/service/raise_complaint_db.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatefulWidget {
  final String tickedID;
  final String categoryName;
  final String equipmentName;
  final String problemDescription;
  const Dashboard({
    super.key,
    required this.tickedID,
    required this.categoryName,
    required this.equipmentName,
    required this.problemDescription,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final repo = RaiseComplaintDb();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,

      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Welcome to the dashboard',
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              context.go('/profile');
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              size: 25,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //========================Raise Complaint button=============================
                        SizedBox(
                          width: 500,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RaiseComplaintPage(
                                    tickedID: widget.tickedID,
                                    categoryName: widget.categoryName,
                                    equipmentName: widget.equipmentName,
                                    problemDescription:
                                        widget.problemDescription,
                                  ),
                                ),
                              );
                            },
                            style: btnStyle(Colors.deepOrange),
                            child: Row(
                              spacing: 15,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white70),
                                const Text('Raise New Compaint'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //=====================================jobsummary card==============================
              SizedBox(height: 20),
              Text(
                'Active complaints',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
//=====================================jobsummary card==============================
              SizedBox(height: 10),
              FutureBuilder<List<RaiseComplaintModel>>(
                future: repo.Fetchcomplaints(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('No complaints found'),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final c = snapshot.data![index];
                      final done =
                          c.complaintStatus?.toLowerCase() == 'completed';

                      return Opacity(
                        opacity: done ? 0.5 : 1.0,
                        child: IgnorePointer(
                          ignoring: done,
                          child: JobSummaryCard(
                            ticketId: c.tickectid ?? 'N/A',
                            status: c.complaintStatus ?? 'Pending',
                            equipment: c.serviceRequired ?? '',
                            issue: c.problem ?? '',
                            technician: c.technicianName ?? 'Unassigned',
                            complaintstatus: c.complaintStatus ?? 'pending',
                            onTap: () =>
                                context.go('/jobdescription', extra: c),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              //========================Recent service==============================
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.history, size: 18, color: Colors.black87),
                  const SizedBox(width: 6),
                  const Text(
                    'Recent Service History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
//====================================Fetch completed complaints and display them=========================
              const SizedBox(height: 10),
              FutureBuilder<List<RaiseComplaintModel>>(
                future: repo.fetchCompletedComplaints(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No completed services'));
                  }

                  final completed = snapshot.data!;

                  return Column(
                    children: completed.map((complaint) {
                      return RecentServiceHistoryCard(
                        equipmentName: complaint.serviceRequired ?? '',
                        ticketId: complaint.tickectid ?? '',
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //================Button Style=============================
  ButtonStyle btnStyle(Color color) => ElevatedButton.styleFrom(
    backgroundColor: color,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
