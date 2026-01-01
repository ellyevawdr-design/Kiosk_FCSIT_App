import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/categories/widget/category_widget.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/menu/widget/all_menu_widget.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/promotion/widgets/promotion_widget.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/search/widgets/search_field_widget.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Order Your Favourite \nFast Food!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      height: 43,
                      width: 43,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        "assets/icons/notificationicon.png",
                        height: 21,
                        width: 21,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search field
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(height: 60, child: SearchField()),
              ),
            ),

            // Promotions
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: RepaintBoundary(child: PromotionsWidget()),
              ),
            ),

            // Categories title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 120,
                  child: RepaintBoundary(child: CategoryWidget()),
                ),
              ),
            ),

            // Your Food title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your food",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // All Menu Items
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: const SliverToBoxAdapter(
                child: RepaintBoundary(child: AllMenuWidget()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
