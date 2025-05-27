import 'package:flutter/material.dart';
import 'package:frontend/home/top_app_bar.dart';
import 'package:frontend/home/google_sign_in_button.dart';



class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chordify'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton(onPressed: () {}, child: const Text('Home', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {}, child: const Text('Chords Library', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {}, child: const Text('Tuner', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {}, child: const Text('Lessons', style: TextStyle(color: Colors.white))),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Master Guitar Chords with Ease!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Learn, explore, and generate chords effortlessly.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Start Learning'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Explore Chords'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'Search for a chord...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Features',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildFeatureCard('Chord Finder', 'Instantly find any chord you need.'),
                  _buildFeatureCard('Lessons & Tutorials', 'Step-by-step guidance to master chords.'),
                  _buildFeatureCard('Tuner & Metronome', 'Keep your guitar perfectly in tune.'),
                  _buildFeatureCard('Setlists', 'Organize and save songs for easy access.'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {}, child: const Text('Home')),
                  TextButton(onPressed: () {}, child: const Text('Chords Library')),
                  TextButton(onPressed: () {}, child: const Text('Tuner')),
                  TextButton(onPressed: () {}, child: const Text('Lessons')),
                ],
              ),
              const SizedBox(height: 8),
              const Text('© 2025 Chordify. All rights reserved.', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String subtitle) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
