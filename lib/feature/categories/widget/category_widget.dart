// lib/feature/categories/widget/category_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/category_controller.dart';
import 'category_item_widget.dart';
import '../../menu/screens/menu_by_category_id_screen.dart';
import '../../../utils/widgets/error_text.dart';
import '../../../utils/widgets/loader.dart';

class CategoryWidget extends ConsumerWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the controller provider (returns AsyncValue<List<CategoryModel>>)
    final categoriesAsync = ref.watch(categoriesControllerProvider);

    return categoriesAsync.when(
      data: (data) {
        return ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuByCategoryIdScreen(
                      categoryId: data[index].categoryId ?? '',
                    ),
                  ),
                );
              },
              child: CategoryItemWidget(category: data[index]),
            );
          },
        );
      },
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
    );
  }
}
