import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/cart_favorrite_manager.dart';
import 'package:routemaster/routemaster.dart';

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
          onPressed: () => Routemaster.of(context).replace('/menu'),
        ),
      ),
      body: manager.favoriteItems.isEmpty
          ? const Center(child: Text("No favorite items"))
          : ListView.builder(
              itemCount: manager.favoriteItems.length,
              itemBuilder: (context, index) {
                final item = manager.favoriteItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: item['image'] != null
                        ? Image.asset(item['image']!, width: 50, height: 50)
                        : const Icon(Icons.fastfood),
                    title: Text(item['title']!),
                    subtitle: Text(item['price']!),
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
