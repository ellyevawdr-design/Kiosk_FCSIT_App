import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/promotion_controller.dart';
import '../../../utils/widgets/error_text.dart';
import '../../../utils/widgets/loader.dart';

class PromotionsWidget extends ConsumerWidget {
  const PromotionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotionsAsync = ref.watch(getPromotionsProvider);

    return promotionsAsync.when(
      data: (data) {
        if (data.isEmpty) return const SizedBox.shrink();

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CarouselSlider.builder(
            itemCount: data.length,
            itemBuilder: (context, index, realIndex) {
              final promo = data[index];
              return Image.asset(
                promo.image ?? "assets/placeholder.png",
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              viewportFraction: 1,
            ),
          ),
        );
      },
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
    );
  }
}
