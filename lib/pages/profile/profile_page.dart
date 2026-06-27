import 'package:field_star_customer_app/model/customer_model.dart';
import 'package:field_star_customer_app/model/raise_complaint_model.dart';
import 'package:field_star_customer_app/service/raise_complaint_db.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _bg = Color(0xFFF7F6F3);
const _surface = Color(0xFFFFFFFF);
const _tint = Color(0xFFEEF4F1);
const _accent = Color(0xFF2D6A4F);
const _text = Color(0xFF1A1A1A);
const _muted = Color(0xFF6B7280);
const _border = Color(0xFFE5E4E0);
const _danger = Color(0xFFC0392B);
const _redLt = Color(0xFFFDE8E8);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final repo = RaiseComplaintDb();
  // ── build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _border),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: _text),
          onPressed: () => context.go('/Home'),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _text,
            letterSpacing: -.01,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          const SizedBox(height: 20),
          FutureBuilder<CustomerModel?>(
            future: repo.fetchCustomerDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const Text('No customer found');
              }

              final customer = snapshot.data!;

              return _identityCard(customer);
            },
          ),
          _sectionLabel('Contact'),
          FutureBuilder<CustomerModel?>(
            future: repo.fetchCustomerDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const Text('No customer found');
              }

              final customer = snapshot.data!;

              return _contactCard(customer);
            },
          ),
          _sectionLabel('Activity'),
          FutureBuilder<Map<String, int>>(
            future: repo.fetchComplaintStats(),
            builder: (context, snapshot) {
              // 1. Show loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2. Handle errors or empty data
              final stats =
                  snapshot.data ?? {'total': 0, 'completed': 0, 'pending': 0};

              // 3. Return the UI
              return Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  statCard(
                    value: stats['total'].toString(),
                    label: 'Total Complaint',
                  ),
                  statCard(
                    value: stats['completed'].toString(),
                    label: 'Completed',
                  ),
                  statCard(
                    value: stats['pending'].toString(),
                    label: 'Pending',
                  ),
                ],
              );
            },
          ),
          _sectionLabel('Recent Services'),
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
                  return historyRow(
                    title: complaint.categoryName,
                    date: '${complaint.date}',
                    status: '${complaint.complaintStatus}',
                  );
                }).toList(),
              );
            },
          ),

          Card(
            child: ListTile(
              leading: _iconBox(Icons.logout_rounded, _redLt, _danger),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: _danger, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _handleSignOut(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  //=============================Helper Function======================================
  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: _muted,
        letterSpacing: .1,
      ),
    ),
  );

  Widget _card(List<Widget> rows) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: rows),
    ),
  );

  Widget _row({
    required Widget child,
    bool isLast = false,
    VoidCallback? onTap,
  }) => InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: child,
        ),
        if (!isLast) const Divider(height: 1, thickness: 1, color: _border),
      ],
    ),
  );

  Widget _iconBox(IconData icon, Color bg, Color color) => Container(
    width: 34,
    height: 34,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(icon, size: 16, color: color),
  );

  // ── identity card ─────────────────────────────────────────────────────────
Widget _identityCard(CustomerModel customer) {
  String initials = customer.customerName.isNotEmpty
      ? customer.customerName
            .trim()
            .split(' ')
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
      : 'C';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: _accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.customerName,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: _text,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'CUSTOMER · #${customer.id?.substring(0, 6).toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: _muted,
                              letterSpacing: .08,
                            ),
                          ),

                          // ── Ticket IDs ────────────────────────────
                          const SizedBox(height: 10),
                         
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // ── contact card ──────────────────────────────────────────────────────────
  Widget _contactCard(CustomerModel customer) => _card([
    _contactItem(Icons.phone_outlined, 'Phone', customer.phone),
    const Divider(height: 24),
    _contactItem(Icons.people, 'Name', customer.customerName),
    const Divider(height: 24),

    _contactItem(Icons.business_outlined, 'Hotel Name', customer.hotelName),
    const Divider(height: 24),

    _contactItem(Icons.location_on_outlined, 'Address', customer.location),
  ]);

  Widget _contactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _iconBox(icon, _tint, _accent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _muted,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _text,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 16, color: _border),
        ],
      ),
    );
  }

  // ── stats row ─────────────────────────────────────────────────────────────
  Widget statCard({
    required String value,
    required String label,
    Color valueColor = Colors.black,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ── history card ──────────────────────────────────────────────────────────
  Widget historyRow({
    required String title,
    required String date,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                status,
                style: TextStyle(
                  color: status == "Completed"
                      ? Colors.green
                      : status == "pending"
                      ? Colors.orange
                      : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }

  // ── Handel Signout ──────────────────────────────────────────────────────────
  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (!context.mounted) return;
      context.go('/login');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error signing out: $e")));
    }
  }
}
