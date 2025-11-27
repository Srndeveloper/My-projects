import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isDarkMode = false;
  bool soundEnabled = true;
  bool prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
      prefsLoaded = true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    if (!prefsLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              setState(() => isDarkMode = value);
              _saveSetting('isDarkMode', value);
              themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          SwitchListTile(
            title: const Text('SoundEffects'),
            value: soundEnabled,
            onChanged: (value) {
              setState(() => soundEnabled = value);
              _saveSetting('soundEnabled', value);
            },
          ),
          ListTile(
            title: const Text("İlerlemeyi Sıfırla"),
            subtitle: const Text("Tüm seviyelerdeki ilerleme sıfırlanır"),
            trailing: const Icon(Icons.delete_outline),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setDouble("progress_A1", 0.0);
              await prefs.setDouble("progress_A2", 0.0);
              await prefs.setDouble("progress_B1", 0.0);
              await prefs.setDouble("progress_B2", 0.0);
              await prefs.setDouble("progress_C1", 0.0);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Tüm seviyelerin ilerlemesi sıfırlandı"),
                  ),
                );
              }

              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
