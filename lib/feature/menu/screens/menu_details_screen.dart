import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../favourites/controller/favourite_controller.dart';
import '../models/menu_model.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/color.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/decoreted_circle_icon.dart';

class MenuDetailsPage extends ConsumerStatefulWidget {
  final MenuModel menuModel;
  const MenuDetailsPage({super.key, required this.menuModel});

  @override
  ConsumerState<MenuDetailsPage> createState() => _MenuDetailsPageState();
}

class _MenuDetailsPageState extends ConsumerState<MenuDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final menu = widget.menuModel;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleIcon(
                      image: Image.asset("assets/icons/backarrow.png"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await ref
                          .read(favouriteControllerProvider.notifier)
                          .addMenuToFavourite(menu, context);
                    },
                    child: CircleIcon(
                      image: Image.asset("assets/icons/favourite.png"),
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                menu.image ?? "assets/placeholder.png",
                height: 224,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    Text(
                      menu.title ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      menu.description ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quantity",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          menu.quantity ?? '1',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\$${menu.price?.toStringAsFixed(2) ?? '0.00'}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Add To Cart",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
