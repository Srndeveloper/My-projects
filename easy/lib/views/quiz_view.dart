import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> loadJsonData() async {
  String jsonString = await rootBundle.loadString('assets/word.json');
  return json.decode(jsonString);
}

class QuizView extends StatefulWidget {
  final String level;

  const QuizView({super.key, required this.level});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  Map<String, dynamic> allWords = {};
  List<dynamic> word = [];
  List<dynamic> englishWords = [];
  List<dynamic> turkishWords = [];
  String selectedLevel = "";
  int currentIndex = 0;
  List<dynamic> selectedWords = [];
  Map<String, String> matchedPairs = {};
  int? selectedEnglishIndex;
  int? selectedTurkishIndex;
  bool isWrong = false;

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.level;
    loadJsonData().then((data) async {
      print("JSON data geldi: $data");
      setState(() {
        allWords = data;
        word = allWords[selectedLevel];
      });

      final prefs = await SharedPreferences.getInstance();
      double savedProgress = prefs.getDouble("progress_${widget.level}") ?? 0.0;
      currentIndex = (savedProgress * word.length).floor();
      loadNextWords();
    });
  }

  Future<void> saveProgress(double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble("progress_${widget.level}", value);
  }

  void loadNextWords() {
    if (currentIndex + 6 <= word.length) {
      selectedWords = word.sublist(currentIndex, currentIndex + 6);
      englishWords = List.from(selectedWords)..shuffle();
      turkishWords = List.from(selectedWords)..shuffle();
      matchedPairs.clear();
      selectedEnglishIndex = null;
      selectedTurkishIndex = null;
    } else {
      selectedWords = [];
    }
  }

  void checkMatch() {
    if (selectedEnglishIndex != null && selectedTurkishIndex != null) {
      final english = englishWords[selectedEnglishIndex!];
      final turkish = turkishWords[selectedTurkishIndex!];

      if (english["turkish"] == turkish["turkish"]) {
        setState(() {
          matchedPairs[english["english"]] = turkish["turkish"];
        });
        double progressNow = (currentIndex + matchedPairs.length) / word.length;
        saveProgress(progressNow);
        if (matchedPairs.length == 6) {
          setState(() {
            currentIndex += 6;
            loadNextWords();
          });
          Future.delayed(const Duration(seconds: 1), () {
            if (currentIndex >= word.length) {
              double newProgress = (currentIndex / word.length).clamp(0.0, 1.0);
              Navigator.pop(context, newProgress);
            }
          });
        }
      } else {
        setState(() {
          isWrong = true;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            isWrong = false;
            selectedEnglishIndex = null;
            selectedTurkishIndex = null;
          });
        });
        return;
      }
    }
  }

  Color getEnglishButtonColour(int index) {
    final word = englishWords[index]["english"];
    if (matchedPairs.containsKey(word)) {
      return Colors.green;
    } else if (selectedEnglishIndex == index) {
      return Colors.grey.shade300;
    } else if (isWrong && selectedEnglishIndex == index) {
      return Colors.red.shade300;
    } else {
      return Colors.yellow.shade300;
    }
  }

  Color getTurkishButtonColour(int index) {
    final word = turkishWords[index]["turkish"];
    if (matchedPairs.containsValue(word)) {
      return Colors.green;
    } else if (selectedTurkishIndex == index) {
      return Colors.grey.shade300;
    } else if (isWrong && selectedTurkishIndex == index) {
      return Colors.red.shade300;
    } else {
      return Colors.yellow.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        double progressNow = (currentIndex + matchedPairs.length) / word.length;
        Navigator.pop(context, progressNow);
        return false;
      },

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFA726), Color(0xFFFFEB3B)],
                  ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    double progressNow =
                        (currentIndex + matchedPairs.length) / word.length;
                    Navigator.pop(context, progressNow);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    SizedBox(height: 60),
                    Text(
                      'Easy Peasy',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: screenWidth * 0.12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5D4037),
                        letterSpacing: 1.2,
                      ),
                    ),

                    SizedBox(height: 150),
                    word.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (var i = 0; i < 6; i++) ...[
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.4,
                                      child: ElevatedButton(
                                        onPressed: matchedPairs.containsKey(i)
                                            ? null
                                            : () {
                                                setState(() {
                                                  selectedEnglishIndex = i;
                                                });
                                              },
                                        child: Text(englishWords[i]["english"]),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              getEnglishButtonColour(i),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),

                                          textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (var i = 0; i < 6; i++) ...[
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.4,
                                      child: ElevatedButton(
                                        onPressed: matchedPairs.containsValue(i)
                                            ? null
                                            : () {
                                                setState(() {
                                                  selectedTurkishIndex = i;
                                                });
                                                if (selectedEnglishIndex !=
                                                        null &&
                                                    selectedTurkishIndex !=
                                                        null) {
                                                  checkMatch();
                                                }
                                              },
                                        child: Text(turkishWords[i]["turkish"]),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              getTurkishButtonColour(i),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
