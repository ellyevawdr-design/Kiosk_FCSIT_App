import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/cart_favorrite_manager.dart';
import 'package:routemaster/routemaster.dart';
import '../utils/widgets/food_card.dart';
import '../utils/widgets/category_chip.dart';
import '../utils/widgets/search_bar.dart' hide SearchBar;

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  String _selectedCategory = "Meal";
  String _searchText = "";

  final List<Map<String, String>> mealItems = [
    {
      "title": "Beef Sandwich",
      "price": "RM 3.00",
      "image": "assets/images/beef.jpg",
    },
    {
      "title": "Ham Sandwich",
      "price": "RM 3.00",
      "image": "assets/images/ham.jpg",
    },
    {
      "title": "Chicken Rice",
      "price": "RM 5.00",
      "image": "assets/images/nasi_ayam.jpg",
    },
  ];

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

  //Filtered list for search
  List<Map<String, String>> get _displayedItems {
    if (_searchText.isEmpty) return mealItems;

    return mealItems
        .where((item) => item['title']!.toLowerCase().contains(_searchText))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedCategory),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Routemaster.of(context).replace('/menu'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            //SearchBar
            SearchBar(
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
            ),

            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "Meal", "Drink", "Snack"].map((category) {
                  return CategoryChip(
                    label: category,
                    selected: _selectedCategory == category,
                    onTap: () => _onCategoryTap(category),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _displayedItems.length,
              itemBuilder: (context, index) {
                final item = _displayedItems[index];
                return FoodCard(
                  name: item['title']!,
                  price: item['price']!,
                  image: item['image'],
                  onAdd: () {
                    manager.addToCart(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to Cart")),
                    );
                  },
                  onFavorite: () {
                    manager.addToFavorite(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to Favorite")),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
