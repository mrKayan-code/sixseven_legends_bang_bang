import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/decision_tree_provider.dart';

class DecisionTreeScreen extends StatefulWidget {
  const DecisionTreeScreen({super.key});

  @override
  State<DecisionTreeScreen> createState() => _DecisionTreeScreenState();
}

class _DecisionTreeScreenState extends State<DecisionTreeScreen> {
  String _selectedLocation = 'main_building';
  String _selectedBudget = 'low';
  String _selectedTime = 'short';
  String _selectedFood = 'snack';
  String _selectedQueue = 'low';
  String _selectedWeather = 'good';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Куда пойти на обед?'),
      ),
      body: Consumer<DecisionTreeProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (provider.rootNode == null) ...[
                  const Text(
                    'Алгоритм еще не обучен. Нажми кнопку ниже, чтобы загрузить данные (CSV) и построить дерево решений.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.trainTree(provider.defaultCsvData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Дерево успешно построено!')),
                      );
                    },
                    child: const Text('Обучить алгоритм'),
                  ),
                ] else ...[
                  const Text(
                    'Укажите вашу текущую ситуацию:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildMappedDropdown('Где вы находитесь?', _selectedLocation, {
                    'main_building': 'Главный корпус',
                    'second_building': 'Второй корпус',
                    'campus_center': 'Центр кампуса',
                  }, (val) => setState(() => _selectedLocation = val!)),

                  _buildMappedDropdown('Какой у вас бюджет?', _selectedBudget, {
                    'low': 'Низкий (Эконом)',
                    'medium': 'Средний',
                    'high': 'Высокий',
                  }, (val) => setState(() => _selectedBudget = val!)),

                  _buildMappedDropdown('Сколько есть времени?', _selectedTime, {
                    'very_short': 'Очень мало (на ходу)',
                    'short': 'Мало (10-20 минут)',
                    'medium': 'Достаточно (можно посидеть)',
                  }, (val) => setState(() => _selectedTime = val!)),

                  _buildMappedDropdown('Чего хочется?', _selectedFood, {
                    'coffee': 'Кофе / Напитки',
                    'pancakes': 'Блины',
                    'full_meal': 'Полноценный обед (Горячее)',
                    'snack': 'Быстрый перекус (Снеки)',
                  }, (val) => setState(() => _selectedFood = val!)),

                  _buildMappedDropdown('Готовы стоять в очереди?', _selectedQueue, {
                    'low': 'Нет, совсем не готов',
                    'medium': 'Могу немного подождать',
                    'high': 'Да, готов стоять',
                  }, (val) => setState(() => _selectedQueue = val!)),

                  _buildMappedDropdown('Какая сейчас погода?', _selectedWeather, {
                    'good': 'Хорошая (Готов прогуляться)',
                    'bad': 'Плохая (Никуда не пойду)',
                  }, (val) => setState(() => _selectedWeather = val!)),
                  
                  const SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    onPressed: () {
                      final input = {
                        'location': _selectedLocation,
                        'budget': _selectedBudget,
                        'time_available': _selectedTime,
                        'food_type': _selectedFood,
                        'queue_tolerance': _selectedQueue,
                        'weather': _selectedWeather,
                      };
                      provider.makePrediction(input);
                    },
                    child: const Text('Куда мне пойти?', style: TextStyle(fontSize: 18)),
                  ),

                  const SizedBox(height: 24),

                  if (provider.predictionResult.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text('Алгоритм рекомендует:', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(
                            provider.predictionResult,
                            style: const TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold, 
                              color: Colors.green
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMappedDropdown(String label, String value, Map<String, String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        initialValue: value,
        items: items.entries.map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}