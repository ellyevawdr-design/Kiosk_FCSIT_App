import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networkclan_kiosk_fcsit_app/fakedata/fakedata.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/categories/models/category_model.dart';

// Fake repository provider that mimics the original Firebase repo
final categoryRepositoryProvider = Provider<FakeCategoryRepository>(
  (_) => FakeCategoryRepository(),
);

class FakeCategoryRepository {
  // Keep the same method signature as the original Firebase repo
  Stream<List<CategoryModel>> getCategories() {
    // Return a stream with a single event containing FakeData
    return Stream.value(FakeData.categoriesList);
  }
}
