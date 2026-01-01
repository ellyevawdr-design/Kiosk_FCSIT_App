// lib/feature/promotion/model/promotion_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

@freezed
abstract class PromotionModel with _$PromotionModel {
  factory PromotionModel({
    String? image, // single image path from FakeData
    List<String>? images, // optional list if needed later
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);
}
