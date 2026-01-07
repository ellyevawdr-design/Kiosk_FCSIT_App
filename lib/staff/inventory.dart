import 'package:flutter/material.dart';
import 'staff_header.dart';
class Inventory extends StatefulWidget {
  final String staffName;
  const Inventory({super.key, required this.staffName});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> menuItems = [
    {
      'name': 'Nasi lemak',
      'vendor': 'Vendor name',
      'category': 'Meals',
      'price': 3.50,
      'stock': 10,
      'hidden': false,
    },
    {
      'name': 'Mee Goreng',
      'vendor': 'Vendor name',
      'category': 'Meals',
      'price': 4.00,
      'stock': 8,
      'hidden': false,
    },
    {
      'name': 'Chocolate Cake',
      'vendor': 'Vendor name',
      'category': 'Meals',
      'price': 3.00,
      'stock': 3,
      'hidden': false,
    },
  ];

  List<Map<String, dynamic>> get filteredItems {
    return menuItems.where((item) {
      if (item['hidden'] == true) return false;
      if (selectedCategory == 'All') return true;
      return item['category'] == selectedCategory;
    }).toList();
  }

  Color stockColor(int stock) {
    return stock <= 3 ? Colors.orange : Colors.green;
  }

  String stockLabel(int stock) {
    return stock <= 3 ? 'Low stock' : 'In stock';
  }

  // ===== CATEGORY CHIP =====
  Widget buildCategoryChip(String label) {
    final isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C63FF) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ===== EDIT DIALOG =====
  void showEditDialog(Map<String, dynamic> item) {
    final nameCtrl = TextEditingController(text: item['name']);
    final priceCtrl =
        TextEditingController(text: item['price'].toString());
    final stockCtrl =
        TextEditingController(text: item['stock'].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Menu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: stockCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stock'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item['name'] = nameCtrl.text;
                item['price'] = double.tryParse(priceCtrl.text) ?? item['price'];
                item['stock'] = int.tryParse(stockCtrl.text) ?? item['stock'];
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ===== MENU CARD =====
  Widget buildMenuCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image, size: 30),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item['name']} (${item['vendor']})',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: stockColor(item['stock']).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          stockLabel(item['stock']),
                          style: TextStyle(
                              color: stockColor(item['stock']), fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(item['category'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RM ${item['price'].toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                      Text('Qty: ${item['stock']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ===== ACTION BUTTONS (OVERFLOW FIXED) =====
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      actionButton(
                        icon: Icons.edit,
                        label: 'Edit',
                        color: Colors.blue,
                        onTap: () => showEditDialog(item),
                      ),
                      actionButton(
                        icon: Icons.visibility_off,
                        label: 'Hide',
                        color: Colors.purple,
                        onTap: () => setState(() => item['hidden'] = true),
                      ),
                      actionButton(
                        icon: Icons.delete,
                        label: 'Delete',
                        color: Colors.red,
                        onTap: () => setState(() => menuItems.remove(item)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
      borderRadius: BorderRadius.circular(10),
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
        // ✅ STAFF HEADER AT THE TOP
        StaffHeader(staffName: widget.staffName),

        // ✅ PAGE CONTENT
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Menu',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    buildCategoryChip('All'),
                    const SizedBox(width: 8),
                    buildCategoryChip('Drinks'),
                    const SizedBox(width: 8),
                    buildCategoryChip('Meals'),
                    const SizedBox(width: 8),
                    buildCategoryChip('Snacks'),
                  ],
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: ListView(
                    children: filteredItems.map(buildMenuCard).toList(),
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