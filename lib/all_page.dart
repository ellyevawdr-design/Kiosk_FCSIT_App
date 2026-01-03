import 'package:flutter/material.dart' hide SearchBar;
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/cart_favorrite_manager.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/category_chip.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/search_bar.dart';
import 'package:routemaster/routemaster.dart';
import '../utils/widgets/food_card.dart';

class AllPage extends StatefulWidget {
  const AllPage({super.key});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  String _selectedCategory = "All";

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

  final List<Map<String, String>> drinkItems = [
    {"title": "Cola", "price": "RM 2.00", "image": "assets/images/cola.png"},
    {
      "title": "Orange Juice",
      "price": "RM 3.00",
      "image": "assets/images/orange.jpg",
    },
    {
      "title": "Coffee",
      "price": "RM 4.00",
      "image": "assets/images/coffee.jpg",
    },
  ];

  final List<Map<String, String>> snackItems = [
    {
      "title": "Cupcakes",
      "price": "RM 3.00",
      "image": "assets/images/cupcake.jpg",
    },
    {
      "title": "Steam Pau",
      "price": "RM 1.50",
      "image": "assets/images/pau.jpg",
    },
    {"title": "Donuts", "price": "RM 2.50", "image": "assets/images/donut.jpg"},
  ];

  late final List<Map<String, String>> allItems;

  final manager = CartFavoriteManager.instance;

  @override
  void initState() {
    super.initState();
    allItems = [...mealItems, ...drinkItems, ...snackItems];
  }

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

  List<Map<String, String>> get _displayedItems {
    switch (_selectedCategory) {
      case "Meal":
        return mealItems;
      case "Drink":
        return drinkItems;
      case "Snack":
        return snackItems;
      default:
        return allItems;
    }
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
            const SearchBar(),
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
