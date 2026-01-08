import 'package:flutter/material.dart' hide SearchBar;
import 'package:kiosk_fcsit/utils/widgets/cart_favorrite_manager.dart';
import 'package:kiosk_fcsit/utils/widgets/category_chip.dart';
import 'package:kiosk_fcsit/utils/widgets/custome_text_field.dart';
import 'package:kiosk_fcsit/utils/widgets/food_card.dart';
import 'package:kiosk_fcsit/utils/widgets/speech_mic_service.dart';

class AllPage extends StatefulWidget {
  const AllPage({super.key});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  final TextEditingController _controller = TextEditingController();
  final SpeechMicService _micService = SpeechMicService();
  bool _isListening = false;

  String _selectedCategory = "All";
  String _searchText = "";

  final manager = CartFavoriteManager.instance;

  late final List<Map<String, String>> allItems;

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

  @override
  void initState() {
    super.initState();
    allItems = [...mealItems, ...drinkItems, ...snackItems];
  }

  Future<void> _toggleMic() async {
    if (_isListening) {
      _micService.stopListening();
      setState(() => _isListening = false);
    } else {
      bool started = await _micService.startListening(
        onResult: (text) {
          _controller.text = text;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: text.length),
          );
          setState(() => _searchText = text.toLowerCase());
        },
      );

      if (started) setState(() => _isListening = true);
    }
  }

  void _onCategoryTap(String category) {
    if (_selectedCategory == category) return;
    setState(() => _selectedCategory = category);
  }

  List<Map<String, String>> get _displayedItems {
    List<Map<String, String>> baseList;
    switch (_selectedCategory) {
      case "Meal":
        baseList = mealItems;
        break;
      case "Drink":
        baseList = drinkItems;
        break;
      case "Snack":
        baseList = snackItems;
        break;
      default:
        baseList = allItems;
    }

    if (_searchText.isEmpty) return baseList;

    return baseList
        .where((item) => item['title']!.toLowerCase().contains(_searchText))
        .toList();
  }

  @override
  void dispose() {
    _micService.stopListening();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_selectedCategory)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            //CustomTextField with Mic
            CustomTextField(
              controller: _controller,
              hintText: "Search here",
              isMic: true,
              isListening: _isListening,
              onPressedSuffixIcon: _toggleMic,
              onChanged: (value) =>
                  setState(() => _searchText = value.toLowerCase()),
            ),

            const SizedBox(height: 16),

            // CATEGORY CHIPS
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

            // FOOD CARDS LIST
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
                  onAdd: () => manager.addToCart(item),
                  onFavorite: () => manager.addToFavorite(item),
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
