import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'staff_header.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  bool checkedIn = false;
  DateTime selectedScheduleDate = DateTime.now();

  // Request Replacement fields
  DateTime? replacementDate;
  String? replacementShift;
  TextEditingController reasonController = TextEditingController();

  // Example shifts
  final List<String> shifts = [
    "Morning Shift",
    "Afternoon Shift",
    "Night Shift",
  ];

  String staffName = "";

  @override
  void initState() {
    super.initState();
    fetchStaffName();
  }

  /// Fetch staff name from users collection
  Future<void> fetchStaffName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      setState(() {
        staffName = doc['name'];
      });
    }
  }

  /// Show replacement request dialog
  void showReplacementDialog() {
    replacementDate = null;
    replacementShift = null;
    reasonController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Request Staff Replacement"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pick Date"),
              SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2025, 1, 1),
                    lastDate: DateTime(2026, 12, 31),
                  );
                  if (picked != null) {
                    setState(() {
                      replacementDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    replacementDate != null
                        ? DateFormat('yyyy-MM-dd').format(replacementDate!)
                        : "Select Date",
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text("Pick Shift"),
              SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: replacementShift,
                hint: Text("Select Shift"),
                items: shifts
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    replacementShift = val;
                  });
                },
              ),
              SizedBox(height: 12),
              Text("Reason"),
              SizedBox(height: 6),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter reason",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (replacementDate == null ||
                  replacementShift == null ||
                  reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Please fill all fields")));
                return;
              }

              print("Replacement Request:");
              print("Staff: $staffName");
              print("Date: ${DateFormat('yyyy-MM-dd').format(replacementDate!)}");
              print("Shift: $replacementShift");
              print("Reason: ${reasonController.text}");

              Navigator.pop(context);

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Replacement request submitted")));
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text("No user logged in"));
    }

    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final selectedKey = DateFormat('yyyy-MM-dd').format(selectedScheduleDate);

    return Column(
      children: [
        StaffHeader(staffName: staffName),
        Expanded(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Shift')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.data() == null) {
                return Center(child: Text("No schedule found"));
              }

              final scheduleData = snapshot.data!.data()!;
              final shiftToday = scheduleData[todayKey] ?? "Off";
              final shiftSelected = scheduleData[selectedKey] ?? "Off";

              return SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Attendance
                    Text("Staff Attendance",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
                        style: TextStyle(color: Color.fromARGB(255, 46, 46, 46))),
                    SizedBox(height: 20),
                    StaffCard(
                      name: staffName,
                      shift: shiftToday,
                      checkedIn: checkedIn,
                      onCheckIn: () {
                        setState(() {
                          checkedIn = true;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: showReplacementDialog,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color(0xFF3B47FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          "Request Staff Replacement",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Schedule
                    Text("Staff Schedule",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedScheduleDate,
                          firstDate: DateTime(2025, 1, 1),
                          lastDate: DateTime(2026, 12, 31),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedScheduleDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat('EEEE, dd MMM yyyy')
                                .format(selectedScheduleDate)),
                            Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Shift", style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            shiftSelected,
                            style: TextStyle(
                                color: shiftSelected == "Off" ? Colors.red : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Staff Card
class StaffCard extends StatelessWidget {
  final String name;
  final String shift;
  final bool checkedIn;
  final VoidCallback onCheckIn;

  const StaffCard({
    super.key,
    required this.name,
    required this.shift,
    required this.checkedIn,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text(
                shift,
                style: TextStyle(color: shift == "Off" ? Colors.red : Colors.black),
              ),
            ],
          ),
          checkedIn
              ? Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 30),
                    SizedBox(width: 6),
                    Text("Checked In", style: TextStyle(color: Colors.green)),
                  ],
                )
              : ElevatedButton(
                  onPressed: onCheckIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B47FF),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Check-in", style: TextStyle(color: Colors.white)),
                ),
        ],
      ),
    );
  }
}
