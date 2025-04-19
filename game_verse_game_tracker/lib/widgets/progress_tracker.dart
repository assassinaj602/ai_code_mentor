import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';

class ProgressTracker extends StatelessWidget {
  final String gameId;

  const ProgressTracker({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, provider, _) {
        final progress = provider.getProgress(gameId);
        final completionPercentage = progress?.completionPercentage ?? 0.0;
        final hoursPlayed = progress?.hoursPlayed ?? 0.0;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress Tracker',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined),
                    const SizedBox(width: 8),
                    Text(
                      'Hours Played: ${hoursPlayed.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addPlaytime(context, provider),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Completion: ${(completionPercentage * 100).toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: completionPercentage,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _updateCompletion(context, provider, completionPercentage),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addPlaytime(
    BuildContext context,
    ProgressProvider provider,
  ) async {
    double? hours = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        double inputHours = 0;
        return AlertDialog(
          title: const Text('Add Playtime'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Hours',
              hintText: 'Enter hours played',
            ),
            onChanged: (value) {
              inputHours = double.tryParse(value) ?? 0;
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () => Navigator.of(context).pop(inputHours),
            ),
          ],
        );
      },
    );

    if (hours != null && hours > 0) {
      await provider.updatePlaytime(gameId, hours);
    }
  }

  Future<void> _updateCompletion(
    BuildContext context,
    ProgressProvider provider,
    double currentPercentage,
  ) async {
    double? percentage = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        double inputPercentage = currentPercentage * 100;
        return AlertDialog(
          title: const Text('Update Completion'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Completion Percentage',
              hintText: 'Enter completion percentage (0-100)',
            ),
            onChanged: (value) {
              inputPercentage = double.tryParse(value) ?? 0;
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () =>
                  Navigator.of(context).pop(inputPercentage.clamp(0, 100) / 100),
            ),
          ],
        );
      },
    );

    if (percentage != null) {
      await provider.updateCompletion(gameId, percentage);
    }
  }
}
