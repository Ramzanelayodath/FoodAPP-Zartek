import 'dart:convert';

class MenuResponse {
  final List<Category> categories;

  MenuResponse({required this.categories});

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    return MenuResponse(
      categories: (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList(),
    );
  }
}

class Category {
  final int id;
  final String name;
  final List<Dish> dishes;

  Category({required this.id, required this.name, required this.dishes});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      dishes: (json['dishes'] as List)
          .map((dish) => Dish.fromJson(dish))
          .toList(),
    );
  }
}

class Dish {
  final int id;
  final String name;
  final String price;
  final String currency;
  final int calories;
  final String description;
  final List<Addon> addons;
  final String imageUrl;
  final bool customizationsAvailable;
  int  qty;

  Dish({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.calories,
    required this.description,
    required this.addons,
    required this.imageUrl,
    required this.customizationsAvailable,
    this.qty = 0
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      currency: json['currency'],
      calories: json['calories'],
      description: json['description'],
      addons: (json['addons'] as List)
          .map((addon) => Addon.fromJson(addon))
          .toList(),
      imageUrl: json['image_url'],
      customizationsAvailable: json['customizations_available'],
      qty: 0
    );
  }
}

class Addon {
  final int id;
  final String name;
  final String price;

  Addon({required this.id, required this.name, required this.price});

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
}
