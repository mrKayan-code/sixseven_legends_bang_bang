import 'package:flutter/material.dart';
import 'package:mapjacks/features/genetic/domain/entities/food_item.dart';

class FoodSelector extends StatelessWidget {
  final List<FoodItemType> selectedItems;
  final void Function(FoodItemType) onToggle;

  const FoodSelector({
    super.key,
    required this.selectedItems,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выберите еду чтоб поесть',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FoodItemType.values.map((item) {
                final isSelected = selectedItems.contains(item);
                return FilterChip(
                  label: Text(item.displayName),
                  selected: isSelected,
                  onSelected: (_) => onToggle(item),
                  avatar: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    size: 18,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}