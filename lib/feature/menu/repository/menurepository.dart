// lib/feature/menu/repository/menurepository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_model.dart';
import '../../../fakedata/fakedata.dart';

// Provider for offline menu repository
final menuRepositoryProvider = Provider<FakeMenuRepository>(
  (_) => FakeMenuRepository(),
);

class FakeMenuRepository {
  // Return all menus as a Stream
  Stream<List<MenuModel>> getMenus() async* {
    yield FakeData.menu;
  }

  // Return menus filtered by categoryId as a Stream
  Stream<List<MenuModel>> getMenuById(String categoryId) async* {
    yield FakeData.menu.where((menu) => menu.categoryId == categoryId).toList();
  }
}
