import 'package:flutter/material.dart';
import 'staff_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory extends StatefulWidget {
  final String staffName;
  const Inventory({super.key, required this.staffName});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  String selectedCategory = 'All';

  final menusRef = FirebaseFirestore.instance.collection('menus');

  Color stockColor(int stock) => stock <= 3 ? Colors.orange : Colors.green;

  String stockLabel(int stock) => stock <= 3 ? 'Low stock' : 'In stock';

  // ===== ADD MENU DIALOG =====
  void showAddDialog() {
    final nameCtrl = TextEditingController();
    final vendorCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    final imageCtrl = TextEditingController();
    String category = 'Meal';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Menu'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Food Name'),
              ),
              TextField(
                controller: vendorCtrl,
                decoration: const InputDecoration(labelText: 'Vendor Name'),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Price (RM 3.00)'),
              ),
              TextField(
                controller: stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
              ),
              TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'Image Path'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                value: category,
                items: ['Meal', 'Drink', 'Snack']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => category = val!,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              await menusRef.add({
                "name": nameCtrl.text,
                "vendor_name": vendorCtrl.text,
                "price": priceCtrl.text,
                "stock": int.parse(stockCtrl.text),
                "category": category,
                "image": imageCtrl.text,
                "hidden": false,
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void showEditDialog(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final nameCtrl = TextEditingController(text: data['name']);
    final vendorCtrl = TextEditingController(text: data['vendor_name']);
    final priceCtrl = TextEditingController(text: data['price']);
    final stockCtrl = TextEditingController(text: data['stock'].toString());
    final imageCtrl = TextEditingController(text: data['image']);
    String category = data['category'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Menu'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Food Name'),
              ),
              TextField(
                controller: vendorCtrl,
                decoration: const InputDecoration(labelText: 'Vendor Name'),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
              ),
              TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'Image Path'),
              ),
              DropdownButtonFormField(
                value: category,
                items: ['Meal', 'Drink', 'Snack']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => category = val!,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              await doc.reference.update({
                "name": nameCtrl.text,
                "vendor_name": vendorCtrl.text,
                "price": priceCtrl.text,
                "stock": int.parse(stockCtrl.text),
                "image": imageCtrl.text,
                "category": category,
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ===== MENU CARD =====
  Widget buildMenuCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final bool isHidden = data['hidden'] == true;

    return Opacity(
      opacity: isHidden ? 0.45 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  data['image'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${data['name']} (${data['vendor_name']})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        if (isHidden)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Hidden',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    Text(
                      data['category'],
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['price'],
                          style: const TextStyle(color: Colors.blue),
                        ),
                        Text('Qty: ${data['stock']}'),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 6,
                      children: [
                        actionButton(
                          icon: Icons.edit,
                          label: 'Edit',
                          color: Colors.blue,
                          onTap: () => showEditDialog(doc),
                        ),
                        actionButton(
                          icon: isHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                          label: isHidden ? 'Unhide' : 'Hide',
                          color: Colors.purple,
                          onTap: () =>
                              doc.reference.update({'hidden': !isHidden}),
                        ),
                        actionButton(
                          icon: Icons.delete,
                          label: 'Delete',
                          color: Colors.red,
                          onTap: () => doc.reference.delete(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StaffHeader(staffName: widget.staffName),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search items...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: showAddDialog,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: menusRef.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final docs = snapshot.data!.docs.where((doc) {
                          final d = doc.data() as Map<String, dynamic>;
                          if (selectedCategory == 'All') return true;
                          return d['category'] == selectedCategory;
                        }).toList();

                        return ListView(
                          children: docs.map(buildMenuCard).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
