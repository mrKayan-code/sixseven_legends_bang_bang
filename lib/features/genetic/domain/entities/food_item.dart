import 'package:equatable/equatable.dart';

enum FoodItemType {
  coffee,
  pancakes,
  fullMeal,
  snack,
  soup,
  salad,
  drink,
  dessert,
}

extension FoodItemTypeExtension on FoodItemType {
  static FoodItemType? fromString(String value) {
    try {
      return FoodItemType.values.firstWhere(
        (type) => type.name == value.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  String get displayName {
    const names = {
      FoodItemType.coffee: 'Кофе',
      FoodItemType.pancakes: 'Блины',
      FoodItemType.fullMeal: 'Полноценное блюдо',
      FoodItemType.snack: 'Закуска',
      FoodItemType.soup: 'Суп',
      FoodItemType.salad: 'Салат',
      FoodItemType.drink: 'Напиток',
      FoodItemType.dessert: 'Десерт',
    };
    return names[this] ?? name;
  }

  static const breakfast = [FoodItemType.coffee, FoodItemType.pancakes];
  static const lunch = [FoodItemType.fullMeal, FoodItemType.soup, FoodItemType.drink];
  static const dinner = [FoodItemType.fullMeal, FoodItemType.snack, FoodItemType.drink];
}

class FoodItem extends Equatable {
  final FoodItemType type;
  const FoodItem({required this.type});

  @override
  List<Object> get props => [type];
}