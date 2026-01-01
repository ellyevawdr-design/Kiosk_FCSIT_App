// lib/feature/promotion/controller/promotion_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networkclan_kiosk_fcsit_app/fakedata/fakedata.dart';
import '../model/promotion_model.dart';

/// Use StreamProvider for consistency with UI
final getPromotionsProvider = StreamProvider<List<PromotionModel>>((ref) {
  // Convert FakeData.promotions to a Stream of PromotionModel
  final promotions = FakeData.promotions
      .map((path) => PromotionModel(image: path))
      .toList();
  return Stream.value(promotions); // single-value stream
});

/// Optional controller for completeness
final promotionsControllerProvider = Provider<PromotionController>(
  (ref) => PromotionController(),
);

class PromotionController {
  Stream<List<PromotionModel>> getPromotions() {
    final promotions = FakeData.promotions
        .map((path) => PromotionModel(image: path))
        .toList();
    return Stream.value(promotions);
  }
}
