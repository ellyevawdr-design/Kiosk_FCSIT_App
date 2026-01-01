import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/menu_controller.dart';
import '../widget/menu_item_widget.dart';
import 'menu_details_screen.dart';
import '../../../utils/widgets/error_text.dart';
import '../../../utils/widgets/loader.dart';

class MenuByCategoryIdScreen extends ConsumerWidget {
  final String categoryId;

  const MenuByCategoryIdScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(getMenuByIdProvider(categoryId));

    return menuAsync.when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(title: const Text("Menu")),
          body: data.isEmpty
              ? const Center(child: Text("No menu items"))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final menu = data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MenuDetailsPage(menuModel: menu),
                          ),
                        );
                      },
                      child: MenuItemWidget(menuModel: menu),
                    );
                  },
                ),
        );
      },
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
    );
  }
}
