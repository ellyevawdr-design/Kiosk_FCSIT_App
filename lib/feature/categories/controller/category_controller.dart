import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/categories/models/category_model.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/categories/repository/category_repository.dart';

final categoriesContollerProvider =
    AsyncNotifierProvider<CategoryController, AsyncValue<void>>(
      CategoryController.new,
    );

final getCategoriesProvider = StreamProvider(
  (ref) => ref.read(categoriesContollerProvider.notifier).getCategories(),
);

class CategoryController extends AsyncNotifier<AsyncValue<void>> {
  late CategoryRepository _categoryRepository;
  AsyncValue<void> build() {
    _categoryRepository = ref.watch(categoryRepositoryProvider);
    return const AsyncValue.data(null);
  }

  Stream<List<CategoryModel>> getCategories() {
    return _categoryRepository.getCategories();
  }
}
