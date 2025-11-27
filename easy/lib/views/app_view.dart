import 'package:easy/views/quiz_view.dart';
import 'package:easy/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  Map<String, double> progress = {
    'A1': 0.0,
    'A2': 0.0,
    'B1': 0.0,
    'B2': 0.0,
    'C1': 0.0,
  };

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      progress['A1'] = prefs.getDouble('progress_A1') ?? 0.0;
      progress['A2'] = prefs.getDouble('progress_A2') ?? 0.0;
      progress['B1'] = prefs.getDouble('progress_B1') ?? 0.0;
      progress['B2'] = prefs.getDouble('progress_B2') ?? 0.0;
      progress['C1'] = prefs.getDouble('progress_C1') ?? 0.0;
    });
  }

  Future<void> updateProgress(String level, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      progress[level] = value;
    });
    await prefs.setDouble("progress_$level", value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,

          colors: [Color(0xFFFFD180), Color(0xFFFFAB40), Color(0xFFFF7043)],
        ),
      ),

      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,

              child: Lottie.asset(
                'assets/animations/bubbles.json',
                fit: BoxFit.cover,
                repeat: true,
                alignment: Alignment.topLeft,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsView(),
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    'Easy Peasy',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF5A3A21),
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Choose your level",
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B4F3F),
                    ),
                  ),

                  SizedBox(height: 40),
                  LevelProgressTile(
                    levelName: 'A1 Seviye',
                    progress: progress['A1'] ?? 0.0,
                    iconPath: 'assets/icons/chick.png',
                    onTap: () async {
                      final newProgress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizView(level: 'A1'),
                        ),
                      );
                      if (newProgress != null && newProgress is double) {
                        updateProgress('A1', newProgress);
                      }
                    },

                    color: const Color(0xFFC8E6C9),
                  ),
                  SizedBox(height: 30.0),
                  LevelProgressTile(
                    levelName: 'A2 Seviye',
                    progress: progress['A2'] ?? 0.0,
                    iconPath: 'assets/icons/book.png',
                    onTap: () async {
                      final newProgress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizView(level: 'A2'),
                        ),
                      );
                      if (newProgress != null && newProgress is double) {
                        updateProgress('A2', newProgress);
                      }
                    },

                    color: const Color(0xFFBBDEFB),
                  ),
                  SizedBox(height: 30.0),
                  LevelProgressTile(
                    levelName: 'B1 Seviye',
                    progress: progress['B1'] ?? 0.0,
                    iconPath: 'assets/icons/happy.png',
                    onTap: () async {
                      final newProgress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizView(level: 'B1'),
                        ),
                      );
                      if (newProgress != null && newProgress is double) {
                        updateProgress('B1', newProgress);
                      }
                    },

                    color: const Color(0xFFFFE0B2),
                  ),
                  SizedBox(height: 30.0),

                  LevelProgressTile(
                    levelName: 'B2 Seviye',
                    progress: progress['B2'] ?? 0.0,
                    iconPath: 'assets/icons/brain.png',
                    onTap: () async {
                      final newProgress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizView(level: 'B2'),
                        ),
                      );
                      if (newProgress != null && newProgress is double) {
                        updateProgress('B2', newProgress);
                      }
                    },

                    color: const Color(0xFFD1C4E9),
                  ),
                  SizedBox(height: 30.0),

                  LevelProgressTile(
                    levelName: 'C1 Seviye',
                    progress: progress['C1'] ?? 0.0,
                    iconPath: 'assets/icons/graduation2.png',
                    onTap: () async {
                      final newProgress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizView(level: 'C1'),
                        ),
                      );
                      if (newProgress != null && newProgress is double) {
                        updateProgress('C1', newProgress);
                      }
                    },

                    color: const Color(0xFF3949AB),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LevelProgressTile extends StatelessWidget {
  final String levelName;
  final double progress;
  final String iconPath;
  final VoidCallback onTap;
  final Color color;

  const LevelProgressTile({
    super.key,
    required this.levelName,
    required this.progress,
    required this.iconPath,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(350, 70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Image.asset(iconPath, width: 40, height: 40),
              const SizedBox(width: 12),
              Text(
                levelName,
                style: const TextStyle(
                  fontFamily: 'Fredoka',
                  color: Colors.black87,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ),

              const SizedBox(width: 10),
              Text(
                '%${(progress * 100).toInt()}',
                style: const TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
