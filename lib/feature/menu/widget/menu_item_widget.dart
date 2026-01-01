import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_model.dart';
import '../../favourites/controller/favourite_controller.dart';

class MenuItemWidget extends ConsumerWidget {
  final MenuModel menuModel;

  const MenuItemWidget({super.key, required this.menuModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.asset(
                    menuModel.image ?? "assets/placeholder.png",
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    menuModel.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "\$${menuModel.price?.toStringAsFixed(2) ?? '0.00'}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: () async {
                  await ref
                      .read(favouriteControllerProvider.notifier)
                      .addMenuToFavourite(menuModel, context);
                },
                child: _iconCircle("assets/icons/favourite.png"),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: _iconCircle("assets/icons/shopping-bag.png"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconCircle(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Image.asset(assetPath, height: 18, width: 18),
    );
  }
}
