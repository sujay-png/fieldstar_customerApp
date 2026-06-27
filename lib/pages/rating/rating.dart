import 'package:field_star_customer_app/model/service_rating_model.dart';
import 'package:field_star_customer_app/service/raise_complaint_db.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RateServicePage extends StatefulWidget {
  final String ticketId;
  final String technicianId;
  final String technicianName;
  final String equipment;
  final String serviceDate;
  const RateServicePage({
    super.key,
    required this.ticketId,
    required this.technicianId,
    required this.technicianName,
    required this.equipment,
    required this.serviceDate,
  });

  @override
  State<RateServicePage> createState() => _RateServicePageState();
}

class _RateServicePageState extends State<RateServicePage> {
  int rating = 0;
  final _repo = RaiseComplaintDb();
  bool _isSubmitting = false;
  final TextEditingController _commentController = TextEditingController();
  final List<String> tags = [
    "Quick Response",
    "Professional",
    "Problem Solved",
    "Friendly",
    "On Time",
    "Clean Work",
    "Fair Pricing",
    "Good Communication",
  ];

  final List<int> _selectedTags = [];
//======================Rating label===============================
  String get _ratingLabel {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
//=======================diffrent rating label color==========================
  Color get _ratingColor {
    switch (rating) {
      case 1:
        return const Color(0xFFEF4444);
      case 2:
        return const Color(0xFFF97316);
      case 3:
        return const Color(0xFFF59E0B);
      case 4:
        return const Color(0xFF22C55E);
      case 5:
        return const Color(0xFF10B981);
      default:
        return Colors.blueGrey;
    }
  }
@override
void dispose() {
  _commentController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 22, 14, 100),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFFFF1E6),
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  color: Colors.deepOrange,
                  size: 28,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Rate Your Experience",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "How was your service with Rajesh Kumar?",
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),

              const SizedBox(height: 42),

              const Text(
                "Tap to rate",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final selected = index < rating;
                  return GestureDetector(
                    onTap: () => setState(() => rating = index + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        selected
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: selected
                            ? Colors.deepOrange
                            : const Color(0xFFD1D5DB),
                        size: 40,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 8),

              // label that changes with rating
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _ratingLabel,
                  key: ValueKey(rating),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _ratingColor,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What did you like?",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: List.generate(tags.length, (i) {
                    final picked = _selectedTags.contains(i);
                    return GestureDetector(
                      onTap: () => setState(() {
                        picked ? _selectedTags.remove(i) : _selectedTags.add(i);
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: picked
                              ? const Color(0xFFFFF1E6)
                              : Colors.white,
                          border: Border.all(
                            color: picked
                                ? Colors.deepOrange
                                : const Color(0xFFE5E7EB),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tags[i],
                          style: TextStyle(
                            fontSize: 12,
                            color: picked
                                ? Colors.deepOrange
                                : const Color(0xFF475569),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 28),
//==================comment tectbox===============================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Additional Comments (Optional)",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                maxLines: 5,
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Share more details about your experience...",
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),

              const SizedBox(height: 30),
//=====================Service Summary============================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service Summary",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 14),
                    _SummaryRow(label: "Ticket ID:", value: widget.ticketId),
                    _SummaryRow(label: "Equipment:", value: widget.equipment),
                    _SummaryRow(
                      label: "Technician:",
                      value: widget.technicianName,
                    ),
                    // _SummaryRow(label: "Service Date:", value: widget.serviceDate),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => context.go('/finalpage'),
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ),
            const SizedBox(width: 10),
//==========================Save rating button=========================
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        setState(() => _isSubmitting = true);

                        try {
                          await _repo.submitRating(
                            ServiceRatingModel(
                              ticketId: widget.ticketId,
                              technicianId: widget.technicianId,
                              technicianName: widget.technicianName,
                              equipment: widget.equipment,
                              serviceDate: widget.serviceDate,
                              rating: rating,
                              ratingLabel: _ratingLabel,
                              selectedTags: _selectedTags
                                  .map((i) => tags[i])
                                  .toList(),
                              comments: _commentController.text.trim(),
                              status: 'Completed'
                            ),
                          );
                          context.go('/finalpage');
                        } catch (e) {
                          setState(() => _isSubmitting = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to submit: $e')),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Submit Rating",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//============================helper function=============================
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Flexible(
            // ✅ Flexible instead of Expanded
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
