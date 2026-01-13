import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:kiosk_fcsit/navbar/cart.dart';
import 'package:kiosk_fcsit/navbar/favorite.dart';
import 'package:kiosk_fcsit/profile_page.dart';
import 'package:kiosk_fcsit/utils/widgets/cart_favorrite_manager.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CartFavoriteManager manager = CartFavoriteManager.instance;

  final List<String> _categories = ["All", "Meal", "Drink", "Snack"];
  String _selectedCategory = "All";
  String _searchText = "";

  final TextEditingController _searchController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _onCategoryTap(String category) {
    setState(() => _selectedCategory = category);
  }

  /// 🎤 SPEECH TO TEXT
  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (!available) return;

    setState(() => _isListening = true);

    _speech.listen(
      onResult: (result) {
        setState(() {
          _searchText = result.recognizedWords;
          _searchController.text = _searchText;
        });
      },
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              /// TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, size: 28),
                    onSelected: (value) {
                      if (value == 'cart') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartPage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoritePage(),
                          ),
                        );
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'cart', child: Text('Cart')),
                      PopupMenuItem(value: 'favorite', child: Text('Favorite')),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, size: 20),
                      SizedBox(width: 4),
                      Text(
                        "FCSIT",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// BANNER
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Good Meal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Order Now",
                              style: TextStyle(
                                color: Color(0xFF4A90E2),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 90,
                      width: 120,
                      child: Image.asset(
                        "assets/images/sandwich_banner.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔍 SEARCH BAR + 🎤 VOICE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black54),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() => _searchText = value);
                        },
                        decoration: const InputDecoration(
                          hintText: "Search here",
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.black54,
                      ),
                      onPressed: _isListening ? _stopListening : _startListening,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// CATEGORY
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final selected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () => _onCategoryTap(category),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? Colors.blue : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              /// FIRESTORE MENU
              StreamBuilder<QuerySnapshot>(
                stream: _selectedCategory == "All"
                    ? _firestore.collection('menus').snapshots()
                    : _firestore
                        .collection('menus')
                        .where('category', isEqualTo: _selectedCategory)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No menu available"));
                  }

                  final docs = snapshot.data!.docs.where((doc) {
                    final name = doc['name'].toString().toLowerCase();
                    return name.contains(_searchText.toLowerCase());
                  }).toList();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      return FoodCard(
                        name: data['name'],
                        vendorName: data['vendor_name'],
                        price: data['price'].toString(),
                        image: data['image'],
                        onAdd: () {
                          manager.addToCart({
                            "name": data['name'],
                            "vendor_name": data['vendor_name'],
                            "price": data['price'].toString(),
                            "image": data['image'],
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to Cart")),
                          );
                        },
                        onFavorite: () {
                          manager.addToFavorite({
                            "name": data['name'],
                            "vendor_name": data['vendor_name'],
                            "price": data['price'].toString(),
                            "image": data['image'],
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to Favorite")),
                          );
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= FOOD CARD =================
class FoodCard extends StatelessWidget {
  final String name;
  final String vendorName;
  final String price;
  final String? image;
  final VoidCallback? onAdd;
  final VoidCallback? onFavorite;

  const FoodCard({
    super.key,
    required this.name,
    required this.vendorName,
    required this.price,
    this.image,
    this.onAdd,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(child: Image.asset(image!, fit: BoxFit.contain)),
          const SizedBox(height: 8),
          Text(name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(vendorName,
              style: const TextStyle(color: Colors.white70)),
          Text(price, style: const TextStyle(color: Colors.white70)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon:
                    const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: onFavorite,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.white),
                onPressed: onAdd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
