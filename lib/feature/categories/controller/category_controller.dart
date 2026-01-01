// lib/feature/categories/controller/category_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networkclan_kiosk_fcsit_app/fakedata/fakedata.dart';
import '../models/category_model.dart';
import '../repository/category_repository.dart';

final categoriesControllerProvider =
    AsyncNotifierProvider<CategoryController, List<CategoryModel>>(
      CategoryController.new,
    );

class CategoryController extends AsyncNotifier<List<CategoryModel>> {
  late FakeCategoryRepository _categoryRepository;

  @override
  List<CategoryModel> build() {
    _categoryRepository = ref.watch(categoryRepositoryProvider);
    // Return initial offline data
    return FakeData.categoriesList;
  }

  Stream<List<CategoryModel>> getCategories() {
    return _categoryRepository.getCategories();
  }
}
