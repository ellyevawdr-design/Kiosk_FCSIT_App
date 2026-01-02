import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color adminBlue = Color.fromRGBO(88, 100, 235, 1);

class AdminStaffPage extends StatefulWidget {
  const AdminStaffPage({super.key});

  @override
  State<AdminStaffPage> createState() => _AdminStaffPageState();
}

class _AdminStaffPageState extends State<AdminStaffPage> {
  DateTime selectedDate = DateTime.now();

  final CollectionReference staffRef =
      FirebaseFirestore.instance.collection('staff');

  // Example schedule data (local – can be migrated to Firestore later)
  final Map<String, List<String>> scheduleData = {
    "2025-12-28": [
      "09:00-11:00|Ahmad Bin Ali|Morning Shift",
      "11:00-13:00|Nurul Aina|Afternoon Shift",
    ],
    "2025-12-29": [
      "14:00-16:00|Anitra Joe|Evening Shift / Part-time",
    ],
  };

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    List<String> todaySchedule =
        scheduleData[formattedDate] ?? ["No schedule for this date"];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Admin Portal",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 4),
            Text(
              "View sales and staff reports",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Staff List title + Add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Staff List",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                _whiteButton(
                  icon: Icons.add,
                  label: "Add Staff",
                  onPressed: _showAddStaffDialog,
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// Staff list from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: staffRef.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Text("No staff available.");
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];
                    return StaffTile(
                      number: index + 1,
                      name: data['name'],
                      phone: data['phone'],
                      onEdit: () =>
                          _showEditStaffDialog(data.id, data),
                      onDelete: () => _confirmDelete(data.id),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            /// Staff Schedule
            const Text(
              "Staff Schedule",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                _whiteButton(
                  label: "Change Date",
                  onPressed: _pickDate,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Column(
              children: todaySchedule.map((e) {
                final parts = e.split('|');
                final time = parts[0];
                final staffName = parts.length > 1 ? parts[1] : '';
                final shift = parts.length > 2 ? parts[2] : '';

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            time,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(staffName),
                            Text(
                              shift,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// White outlined button
  Widget _whiteButton({
    String? label,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: adminBlue,
        elevation: 1,
        side: const BorderSide(color: adminBlue),
      ),
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(label ?? ""),
    );
  }

  /// Pick date
  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  /// Add staff
  void _showAddStaffDialog() {
    String name = '';
    String phone = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Staff"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: (v) => name = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
              onChanged: (v) => phone = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          _whiteButton(
            label: "Add",
            onPressed: () async {
              if (name.isNotEmpty && phone.isNotEmpty) {
                await staffRef.add({
                  'name': name,
                  'phone': phone,
                  'createdAt': Timestamp.now(),
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Edit staff
  void _showEditStaffDialog(
      String docId, QueryDocumentSnapshot data) {
    String name = data['name'];
    String phone = data['phone'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Staff"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: (v) => name = v,
            ),
            TextFormField(
              initialValue: phone,
              decoration: const InputDecoration(labelText: "Phone"),
              onChanged: (v) => phone = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          _whiteButton(
            label: "Update",
            onPressed: () async {
              await staffRef.doc(docId).update({
                'name': name,
                'phone': phone,
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// Confirm delete
  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Staff"),
        content: const Text("Are you sure you want to delete this staff?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await staffRef.doc(docId).delete();
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Staff Tile
class StaffTile extends StatelessWidget {
  final int number;
  final String name;
  final String phone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StaffTile({
    super.key,
    required this.number,
    required this.name,
    required this.phone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Staff $number: $name",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(phone, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
