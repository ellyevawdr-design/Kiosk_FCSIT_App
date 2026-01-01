import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/menu_details_screen.dart';
import '../../../fakedata/fakedata.dart';
import '../widget/menu_item_widget.dart';
import '../../favourites/controller/favourite_controller.dart';

class AllMenuWidget extends ConsumerWidget {
  const AllMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuList = FakeData.menu;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: menuList.length,
      itemBuilder: (context, index) {
        final menu = menuList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuDetailsPage(menuModel: menu),
              ),
            );
          },
          child: MenuItemWidget(menuModel: menu),
        );
      },
    );
  }
}
