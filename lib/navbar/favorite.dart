import 'package:flutter/material.dart';
import 'package:kiosk_fcsit/utils/widgets/cart_favorrite_manager.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final manager = CartFavoriteManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: manager.favoriteItems.isEmpty
          ? const Center(child: Text("No favorite items"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: manager.favoriteItems.length,
              itemBuilder: (context, index) {
                final item = manager.favoriteItems[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item['image'] != null && item['image']!.isNotEmpty
                          ? Image.asset(
                              item['image']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.fastfood, size: 40),
                    ),
                    title: Text(
                      item['name'] ?? 'Unnamed item',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item['price'] ?? 'RM 0.00'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          manager.removeFromFavorite(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
