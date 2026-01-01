import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel category;
  const CategoryItemWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 60,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use Image.asset if the path is local (for FakeData)
            category.image!.startsWith('http')
                ? Image.network(
                    category.image!,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  )
                : Image.asset(
                    category.image!,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
            const SizedBox(height: 4),
            Text(
              category.name ?? '',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[800],
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
