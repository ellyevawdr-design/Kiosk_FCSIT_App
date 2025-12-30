import 'package:networkclan_kiosk_fcsit_app/feature/categories/models/category_model.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/menu/models/menu_model.dart';

class FakeData {
  static final List<String> promotions = ["assets/banner/banner.png"];
  static final List<CategoryModel> categoriesList = [
    CategoryModel(image: "assets/categories/meal.png", name: "meal"),
    CategoryModel(image: "assets/categories/drink.png", name: "drink"),
    CategoryModel(image: "assets/categories/snack.png", name: "snack"),
  ];
  static final List<MenuModel> menu = [
    MenuModel(
      menuId: "1",
      title: "Beef Sandwich",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis consequat pulvinar vehicula. Ut mattis consequat felis, a condimentum nisl eleifend et. Maecenas bibendum vulputate urna.",
      price: 3.00,
      image: "assets/food/sandwich.jpg",
    ),
    MenuModel(
      menuId: "2",
      title: "Mushroom soup",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis consequat pulvinar vehicula. Ut mattis consequat felis, a condimentum nisl eleifend et. Maecenas bibendum vulputate urna.",
      price: 3.50,
      image: "assets/food/soup.jpg",
    ),
    MenuModel(
      menuId: "3",
      title: "Chocolate Cake",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis consequat pulvinar vehicula. Ut mattis consequat felis, a condimentum nisl eleifend et. Maecenas bibendum vulputate urna.",
      price: 2.00,
      image: "assets/food/cake.jpg",
    ),
    MenuModel(
      menuId: "4",
      title: "Coka Cola",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis consequat pulvinar vehicula. Ut mattis consequat felis, a condimentum nisl eleifend et. Maecenas bibendum vulputate urna.",
      price: 2.00,
      image: "assets/food/coke.jpg",
    ),
  ];
}
