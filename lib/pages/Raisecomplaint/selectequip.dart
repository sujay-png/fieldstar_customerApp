import 'package:field_star_customer_app/pages/Raisecomplaint/describeProblem.dart';
import 'package:flutter/material.dart';

class SelectEquipmentPage extends StatefulWidget {
  final String tickedID;
  final String categoryName;
  final String equipmentName;
  final String problemDescription;
  const SelectEquipmentPage({
    super.key,
    required this.tickedID,
    required this.categoryName,
    required this.equipmentName,
    required this.problemDescription,
  });

  @override
  State<SelectEquipmentPage> createState() => _SelectEquipmentPageState();
}

class _SelectEquipmentPageState extends State<SelectEquipmentPage> {
  String? selectedEquipment;

  final equipments = [
    'Commercial Deep Fryer - Pitco SE14',
    'Walk-in Freezer - Kolpak QS6',
    'Conveyor Dishwasher - Hobart FT900',
    'Industrial Oven - Vulcan VC4GD',
    'Ice Machine - Manitowoc ID-0502A',
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
              'Step 2 of 4',
              style: TextStyle(color: Colors.blueGrey, fontSize: 11),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 180,
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
              'Select Equipment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Which specific unit requires service?',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
            const SizedBox(height: 22),

            ...equipments.map((item) {
              final selected = selectedEquipment == item;

              return InkWell(
                onTap: () => setState(() => selectedEquipment = item),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xfffff7ed) : Colors.white,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: selected
                          ? Colors.deepOrange
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            Row(
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
                    onPressed: selectedEquipment == null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DescribeProblemPage(
                                  categoryName: widget.categoryName,
                                  tickedID: widget.tickedID,
                                  equipmentName: selectedEquipment!,
                                  problemDescription: widget.problemDescription,
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
                    child: const Text('Continue'),
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
