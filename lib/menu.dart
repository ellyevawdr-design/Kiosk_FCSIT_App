import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/cart_favorrite_manager.dart';
import 'package:routemaster/routemaster.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final List<Map<String, String>> foodItems = [
    {
      "img": "assets/images/sandwich_menu.jpg",
      "title": "Beef Sandwich",
      "price": "RM 3.00",
    },
    {
      "img": "assets/images/sandwich_menu.jpg",
      "title": "Ham Sandwich",
      "price": "RM 3.00",
    },
    {
      "img": "assets/images/choc_cake.png",
      "title": "Cupcakes",
      "price": "RM 3.00",
    },
    {
      "img": "assets/images/choc_cake.png",
      "title": "Chocolate Cake",
      "price": "RM 1.50",
    },
  ];

  final List<Map<String, String>> popularMeals = [
    {
      "img": "assets/images/sandwich_menu.jpg",
      "title": "Beef Sandwich",
      "price": "RM 3.00",
    },
  ];

  final List<String> _categories = ["All", "Meal", "Drink", "Snack"];
  String _selectedCategory = "All";

  final manager = CartFavoriteManager.instance;

  void _onCategoryTap(String category) {
    if (_selectedCategory == category) return;
    setState(() => _selectedCategory = category);

    switch (category) {
      case "All":
        Routemaster.of(context).replace('/all');
        break;
      case "Meal":
        Routemaster.of(context).replace('/meal');
        break;
      case "Drink":
        Routemaster.of(context).replace('/drink');
        break;
      case "Snack":
        Routemaster.of(context).replace('/snack');
        break;
    }
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

              // Top Bar: Menu icon, Location, Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu Icon with popup
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, size: 28),
                    onSelected: (value) {
                      switch (value) {
                        case 'cart':
                          Routemaster.of(context).replace('/cart');
                          break;
                        case 'favorite':
                          Routemaster.of(context).replace('/favorite');
                          break;
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'cart', child: Text('Cart')),
                      PopupMenuItem(value: 'favorite', child: Text('Favorite')),
                    ],
                  ),

                  // Location
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, size: 20),
                      SizedBox(width: 4),
                      Text(
                        "FCSIT",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  // Profile Avatar
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Banner
              Container(
                width: double.infinity,
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
                          GestureDetector(
                            onTap: () {
                              Routemaster.of(context).replace('/ordertype');
                            },
                            child: Container(
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 25),
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

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black54),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Search here",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                    const Icon(Icons.mic_none, color: Colors.black54),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.filter_list, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Category Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
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

              // Food Grid
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: foodItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final item = foodItems[index];
                  return FoodCard(
                    name: item['title']!,
                    price: item['price']!,
                    image: item['img'],
                    onAdd: () {
                      manager.addToCart({
                        "title": item['title']!,
                        "price": item['price']!,
                        "image": item['img']!,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to Cart")),
                      );
                    },
                    onFavorite: () {
                      manager.addToFavorite({
                        "title": item['title']!,
                        "price": item['price']!,
                        "image": item['img']!,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to Favorite")),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              // Popular Meals
              const Text(
                "Popular Meals",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Column(
                children: popularMeals.map((item) {
                  return PopularMealCard(
                    item['img']!,
                    item['title']!,
                    item['price']!,
                    onAdd: () {
                      manager.addToCart({
                        "title": item['title']!,
                        "price": item['price']!,
                        "image": item['img']!,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to Cart")),
                      );
                    },
                    onFavorite: () {
                      manager.addToFavorite({
                        "title": item['title']!,
                        "price": item['price']!,
                        "image": item['img']!,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to Favorite")),
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// FoodCard with callbacks
class FoodCard extends StatelessWidget {
  final String name;
  final String price;
  final String? image;
  final VoidCallback? onAdd;
  final VoidCallback? onFavorite;

  const FoodCard({
    super.key,
    required this.name,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: image != null
                ? Image.asset(image!, fit: BoxFit.contain)
                : const Icon(Icons.fastfood, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(price, style: const TextStyle(color: Colors.white70)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
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

// PopularMealCard with callbacks
class PopularMealCard extends StatelessWidget {
  final String img;
  final String title;
  final String price;
  final VoidCallback? onAdd;
  final VoidCallback? onFavorite;

  const PopularMealCard(
    this.img,
    this.title,
    this.price, {
    this.onAdd,
    this.onFavorite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(img, height: 60, width: 60, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(price, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: onFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF4A90E2)),
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
