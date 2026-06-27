import 'package:field_star_customer_app/pages/Raisecomplaint/selectequip.dart';
import 'package:field_star_customer_app/service/raise_complaint_db.dart';
import 'package:flutter/material.dart';

class RaiseComplaintPage extends StatefulWidget {
  final String tickedID;
  final String categoryName;
  final String equipmentName;
  final String problemDescription;
  const RaiseComplaintPage({
    super.key,
    required this.tickedID,
    required this.categoryName,
    required this.equipmentName,
    required this.problemDescription,
  });

  @override
  State<RaiseComplaintPage> createState() => _RaiseComplaintPageState();
}

class _RaiseComplaintPageState extends State<RaiseComplaintPage> {
  String? selectedCategory;
  final RaiseComplaintDb _repository = RaiseComplaintDb();
  final bool _isLoading = false;

  final categories = const [
    ['🔍', 'Deep Fryer'],
    ['🔥', 'Oven/Range'],
    ['❄️', 'Freezer/Cooler'],
    ['💧', 'Dishwasher'],
    ['🌪️', 'Exhaust Hood'],
    ['⚙️', 'Other Equipment'],
  ];

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
              'Step 1 of 4',
              style: TextStyle(color: Colors.blueGrey, fontSize: 11),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 90,
              height: 3,
              child: ColoredBox(color: Colors.deepOrange),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Equipment Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'What type of equipment needs service?',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
            const SizedBox(height: 22),
//=================category gridview=============================
            GridView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final item = categories[index];
                final isSelected = selectedCategory == item[1];

                return InkWell(
                  onTap: () => setState(() => selectedCategory = item[1]),
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: isSelected
                            ? Colors.deepOrange
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item[0], style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 8),
                        Text(
                          item[1],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const Spacer(),
//====================continue button====================================
            SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                onPressed: selectedCategory == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectEquipmentPage(
                              tickedID: widget.tickedID,
                              categoryName: selectedCategory!,
                              problemDescription: widget.problemDescription,
                              equipmentName: widget.equipmentName,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  disabledBackgroundColor: const Color(0xffFDBA74),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
