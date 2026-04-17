import 'package:flutter/material.dart';
import 'package:mapjacks/features/genetic/domain/entities/food_item.dart';

class PresetSelector extends StatelessWidget {
  final void Function(List<FoodItemType>) onPresetSelected;

  const PresetSelector({super.key, required this.onPresetSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _PresetChip(
          label: 'Завтрак',
          items: FoodItemTypeExtension.breakfast,
          onTap: () => onPresetSelected(FoodItemTypeExtension.breakfast),
        ),
        _PresetChip(
          label: 'Обед',
          items: FoodItemTypeExtension.lunch,
          onTap: () => onPresetSelected(FoodItemTypeExtension.lunch),
        ),
        _PresetChip(
          label: 'Ужин',
          items: FoodItemTypeExtension.dinner,
          onTap: () => onPresetSelected(FoodItemTypeExtension.dinner),
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final List<FoodItemType> items;
  final void Function() onTap;

  const _PresetChip({
    required this.label,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      avatar: Icon(Icons.fastfood, size: 18),
    );
  }
}