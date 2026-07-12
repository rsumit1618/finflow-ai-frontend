import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme_provider.dart';
import '../core/localization/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(loc.translate('settings')),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          _buildSectionHeader(context, loc.translate('appearance')),
          _buildSettingsCard(
            context,
            children: [
              SwitchListTile(
                title: Text(loc.translate('dark_mode')),
                subtitle: Text(themeProvider.themeMode == ThemeMode.dark ? 'Enabled' : 'Disabled'),
                secondary: Icon(
                  themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                  color: theme.colorScheme.primary,
                ),
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) => themeProvider.toggleTheme(value),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(Icons.palette_outlined, color: theme.colorScheme.primary),
                title: Text(loc.translate('primary_color')),
                subtitle: const Text('Change the app accent color'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: themeProvider.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.outline, width: 1),
                  ),
                ),
                onTap: () => _showColorPicker(context, themeProvider),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(Icons.font_download_outlined, color: theme.colorScheme.primary),
                title: Text(loc.translate('choose_font')),
                subtitle: Text('Current: ${themeProvider.fontFamily}'),
                onTap: () => _showFontPicker(context, themeProvider),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, loc.translate('general')),
          _buildSettingsCard(
            context,
            children: [
              ListTile(
                leading: Icon(Icons.language_outlined, color: theme.colorScheme.primary),
                title: Text(loc.translate('language')),
                subtitle: const Text('English (Default)'),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () {
                  // TODO: Implement Language switching logic
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.blue),
                title: const Text('About FinFlow AI'),
                subtitle: const Text('Version 1.0.0'),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 1),
      ),
      color: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  void _showColorPicker(BuildContext context, ThemeProvider provider) {
    final colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.pink,
      Colors.indigo,
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Accent Color',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: colors.map((color) {
                  final isSelected = provider.primaryColor.value == color.value;
                  return GestureDetector(
                    onTap: () {
                      provider.setPrimaryColor(color);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showFontPicker(BuildContext context, ThemeProvider provider) {
    final fonts = ['Roboto', 'Inter', 'Poppins'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Choose Typography',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ...fonts.map((font) {
                final isSelected = provider.fontFamily == font;
                return ListTile(
                  title: Text(font, style: TextStyle(fontFamily: font)),
                  trailing: isSelected ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary) : null,
                  onTap: () {
                    provider.setFontFamily(font);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
