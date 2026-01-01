// lib/feature/promotion/repository/promotion_repository.dart
import 'package:networkclan_kiosk_fcsit_app/fakedata/fakedata.dart';
import '../model/promotion_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final promotionRepositoryProvider = Provider<PromotionRepository>((ref) {
  return PromotionRepository();
});

class PromotionRepository {
  /// Offline-friendly: returns promotions from FakeData
  Stream<List<PromotionModel>> getPromotions() {
    final promotions = FakeData.promotions
        .map((path) => PromotionModel(image: path))
        .toList();
    return Stream.value(promotions); // single-value stream
  }
}
