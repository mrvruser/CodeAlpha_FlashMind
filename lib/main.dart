import 'package:flashcard_quiz/flashcard.dart';
import 'package:flashcard_quiz/flashcard_view.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlashcardQuiz(),
    );
  }
}

class FlashcardQuiz extends StatefulWidget {
  const FlashcardQuiz({Key? key}) : super(key: key);

  @override
  _FlashcardQuizState createState() => _FlashcardQuizState();
}

class _FlashcardQuizState extends State<FlashcardQuiz> {
  final List<Flashcard> _flashcards = [
    Flashcard(
        question: "Which IDE is commonly used to develop Flutter apps?",
        answer: "Android Studio"),
    Flashcard(question: "What language does React use?", answer: "JavaScript"),
    Flashcard(
        question: "What does AI stand for?",
        answer: "Artificial Intelligence."),
    Flashcard(
        question: "What language does Angular use?", answer: "JavaScript"),
    Flashcard(
        question: "What does OOP stand for in programming?",
        answer: "Object-Oriented Programming."),
    Flashcard(
        question: "What language does Electron use?", answer: "JavaScript"),
    Flashcard(
        question:
            "Which platform is best for managing and storing code repositories?",
        answer: "GitHub."),
    Flashcard(
        question: "What language does React Native use?", answer: "JavaScript")
  ];

  int _currIndex = 0;
  int _score = 0;
  late Timer _timer;
  int _timeRemaining = 30;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          nextCard();
        }
      });
    });
  }

  void nextCard() {
    setState(() {
      _currIndex = (_currIndex + 1) % _flashcards.length;
      _timeRemaining = 30;
    });
  }

  void previousCard() {
    setState(() {
      _currIndex = (_currIndex - 1 + _flashcards.length) % _flashcards.length;
      _timeRemaining = 30;
    });
  }

  void shuffleCards() {
    setState(() {
      _flashcards.shuffle();
      _currIndex = 0;
      _timeRemaining = 30;
    });
  }

  void checkAnswer(String userAnswer) {
    if (userAnswer == _flashcards[_currIndex].answer) {
      setState(() {
        _score++;
      });
    }
    nextCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcard Quiz')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
                child: FlipCard(
                  front: FlashcardView(text: _flashcards[_currIndex].question),
                  back: FlashcardView(text: _flashcards[_currIndex].answer),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    onPressed: previousCard,
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Prev'),
                  ),
                  OutlinedButton.icon(
                    onPressed: nextCard,
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('Next'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: shuffleCards,
                child: const Text('Shuffle'),
              ),
              const SizedBox(height: 20),
              Text('Score: $_score', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text('Time Remaining: $_timeRemaining seconds',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              for (var flashcard in _flashcards)
                ElevatedButton(
                  onPressed: () => checkAnswer(flashcard.answer),
                  child: Text(flashcard.answer),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
