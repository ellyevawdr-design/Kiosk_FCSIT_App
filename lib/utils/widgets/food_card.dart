import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(12),
              image: image != null
                  ? DecorationImage(
                      image: AssetImage(image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: image == null
                ? const Icon(Icons.fastfood, size: 40, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: onFavorite,
                icon: const Icon(Icons.favorite_border, color: Colors.white),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
