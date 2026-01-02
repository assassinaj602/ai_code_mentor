import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analysis_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final currentProvider = ref.watch(llmProviderNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // AI Provider Section
          _buildSectionHeader('AI Provider', context),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _buildProviderTile(
                  context: context,
                  ref: ref,
                  title: 'OpenRouter (Default)',
                  subtitle: 'Optimized for general coding tasks',
                  value: 'openrouter',
                  groupValue: currentProvider,
                  icon: Icons.cloud_queue,
                ),
                Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
                _buildProviderTile(
                  context: context,
                  ref: ref,
                  title: 'Google Gemini',
                  subtitle: 'Fast analysis and explanation',
                  value: 'gemini',
                  groupValue: currentProvider,
                  icon: Icons.auto_awesome,
                ),
                Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
                _buildProviderTile(
                  context: context,
                  ref: ref,
                  title: 'Groq (Llama 3)',
                  subtitle: 'Ultra-fast responses',
                  value: 'groq',
                  groupValue: currentProvider,
                  icon: Icons.flash_on,
                ),
                Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
                _buildProviderTile(
                  context: context,
                  ref: ref,
                  title: 'Mistral (Mistral AI)',
                  subtitle: 'Open & Efficient Models',
                  value: 'mistral',
                  groupValue: currentProvider,
                  icon: Icons.wind_power,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Appearance Section
          _buildSectionHeader('Appearance', context),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Use darker colors for comfortable coding',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: themeMode == 'dark',
                  secondary: Icon(
                    Icons.dark_mode,
                    color: theme.colorScheme.primary,
                  ),
                  onChanged: (bool value) {
                    ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(value ? 'dark' : 'light');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader('About', context),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    'Version',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text('1.0.0'),
                ),
                Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
                ListTile(
                  leading: Icon(Icons.code, color: theme.colorScheme.primary),
                  title: Text(
                    'Developer',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text('Muhammad Assad Ullah'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProviderTile({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: (newValue) {
        if (newValue != null) {
          ref.read(llmProviderNotifierProvider.notifier).setProvider(newValue);
        }
      },
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      secondary: Icon(
        icon,
        color:
            isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
      ),
      activeColor: theme.colorScheme.primary,
      selected: isSelected,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
