import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ChordifyApp());
}

class ChordifyApp extends StatelessWidget {
  const ChordifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chordify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class Chord {
  final String name;
  final String description;
  final List<int> fingerPositions; // [string1, string2, string3, string4, string5, string6]
  final List<int> frets; // [fret1, fret2, fret3, fret4, fret5, fret6]
  final int startFret;

  Chord({
    required this.name,
    required this.description,
    required this.fingerPositions,
    required this.frets,
    this.startFret = 0,
  });
}

// Ultimate Guitar API Service
class UltimateGuitarService {
  static const String _baseUrl = 'https://api.ultimate-guitar.com/api/v1';
  static const String _apiKey = 'YOUR_UG_API_KEY'; // Replace with actual API key
  
  // Mock HTTP client for demonstration
  Future<Map<String, dynamic>> _get(String endpoint, {Map<String, String>? queryParams}) async {
    // In a real app, this would make an actual HTTP request
    // For demo purposes, we'll return mock data
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    if (endpoint.contains('search')) {
      return {
        'results': [
          {
            'id': '1234567',
            'song_name': 'Wonderwall',
            'artist_name': 'Oasis',
            'type': 'Chords',
            'rating': 4.8,
            'votes': 1250,
          },
          {
            'id': '7654321',
            'song_name': 'Sweet Home Alabama',
            'artist_name': 'Lynyrd Skynyrd',
            'type': 'Chords',
            'rating': 4.7,
            'votes': 980,
          },
          {
            'id': '9876543',
            'song_name': 'Wish You Were Here',
            'artist_name': 'Pink Floyd',
            'type': 'Chords',
            'rating': 4.9,
            'votes': 1500,
          },
        ]
      };
    } else if (endpoint.contains('tab')) {
      return {
        'id': '1234567',
        'song_name': 'Wonderwall',
        'artist_name': 'Oasis',
        'content': '''
[Intro] Em7 G D A7sus4

[Verse 1]
Em7        G
Today is gonna be the day
D                A7sus4
That they're gonna throw it back to you
Em7        G
By now you should've somehow
D                A7sus4
Realized what you gotta do
''',
        'chords': ['Em7', 'G', 'D', 'A7sus4'],
      };
    }
    
    return {'error': 'Endpoint not found'};
  }
  
  // Search for tabs
  Future<List<Map<String, dynamic>>> searchTabs(String query) async {
    final response = await _get('/search', queryParams: {'query': query, 'type': 'chords'});
    return List<Map<String, dynamic>>.from(response['results'] ?? []);
  }
  
  // Get tab details
  Future<Map<String, dynamic>> getTab(String tabId) async {
    final response = await _get('/tab/$tabId');
    return response;
  }
  
  // Get chord variations
  Future<List<Map<String, dynamic>>> getChordVariations(String chordName) async {
    final response = await _get('/chord/$chordName');
    return List<Map<String, dynamic>>.from(response['variations'] ?? []);
  }
}

// Yousician API Service
class YousicianService {
  static const String _baseUrl = 'https://api.yousician.com/v1';
  static const String _apiKey = 'YOUR_YOUSICIAN_API_KEY'; // Replace with actual API key
  
  // Mock HTTP client for demonstration
  Future<Map<String, dynamic>> _get(String endpoint, {Map<String, String>? queryParams}) async {
    // In a real app, this would make an actual HTTP request
    // For demo purposes, we'll return mock data
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network delay
    
    if (endpoint.contains('lessons')) {
      return {
        'lessons': [
          {
            'id': 'lesson1',
            'title': 'Basic Chords for Beginners',
            'difficulty': 'Beginner',
            'duration': '15 minutes',
            'description': 'Learn the most essential chords for guitar beginners: A, D, and E.',
            'thumbnail': 'https://example.com/lesson1.jpg',
          },
          {
            'id': 'lesson2',
            'title': 'Chord Transitions',
            'difficulty': 'Beginner',
            'duration': '20 minutes',
            'description': 'Practice smoothly transitioning between common chords.',
            'thumbnail': 'https://example.com/lesson2.jpg',
          },
          {
            'id': 'lesson3',
            'title': 'Barre Chords Masterclass',
            'difficulty': 'Intermediate',
            'duration': '30 minutes',
            'description': 'Learn how to play barre chords and move them up and down the fretboard.',
            'thumbnail': 'https://example.com/lesson3.jpg',
          },
        ]
      };
    } else if (endpoint.contains('exercises')) {
      return {
        'exercises': [
          {
            'id': 'ex1',
            'title': 'A to D Chord Transition',
            'difficulty': 'Beginner',
            'description': 'Practice switching between A and D chords with proper timing.',
          },
          {
            'id': 'ex2',
            'title': 'G, C, D Progression',
            'difficulty': 'Beginner',
            'description': 'Master the most common chord progression in popular music.',
          },
          {
            'id': 'ex3',
            'title': 'F Barre Chord Practice',
            'difficulty': 'Intermediate',
            'description': 'Build strength and accuracy with the challenging F barre chord.',
          },
        ]
      };
    }
    
    return {'error': 'Endpoint not found'};
  }
  
  // Get lessons
  Future<List<Map<String, dynamic>>> getLessons({String? difficulty}) async {
    final queryParams = difficulty != null ? {'difficulty': difficulty} : null;
    final response = await _get('/lessons', queryParams: queryParams);
    return List<Map<String, dynamic>>.from(response['lessons'] ?? []);
  }
  
  // Get exercises
  Future<List<Map<String, dynamic>>> getExercises({String? difficulty}) async {
    final queryParams = difficulty != null ? {'difficulty': difficulty} : null;
    final response = await _get('/exercises', queryParams: queryParams);
    return List<Map<String, dynamic>>.from(response['exercises'] ?? []);
  }
  
  // Track progress
  Future<Map<String, dynamic>> trackProgress(String userId, String exerciseId, double score) async {
    // In a real app, this would be a POST request
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'userId': userId,
      'exerciseId': exerciseId,
      'score': score,
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'success'
    };
  }
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  List<Chord> allChords = [
    // A Chords
    Chord(
      name: 'A',
      description: 'A major chord - bright and happy sounding',
      fingerPositions: [0, 2, 2, 2, 0, 0],
      frets: [0, 2, 2, 2, 0, 0],
    ),
    Chord(
      name: 'Am',
      description: 'A minor chord - sad and melancholic',
      fingerPositions: [0, 1, 2, 2, 0, 0],
      frets: [0, 1, 2, 2, 0, 0],
    ),
    Chord(
      name: 'A7',
      description: 'A dominant 7th - bluesy with tension',
      fingerPositions: [0, 2, 0, 2, 0, 0],
      frets: [0, 2, 0, 2, 0, 0],
    ),
    Chord(
      name: 'Amaj7',
      description: 'A major 7th - jazzy and sophisticated',
      fingerPositions: [0, 2, 1, 2, 0, 0],
      frets: [0, 2, 1, 2, 0, 0],
    ),
    Chord(
      name: 'Am7',
      description: 'A minor 7th - jazzy and melancholic',
      fingerPositions: [0, 1, 0, 2, 0, 0],
      frets: [0, 1, 0, 2, 0, 0],
    ),
    Chord(
      name: 'Asus2',
      description: 'A suspended 2nd - open and unresolved',
      fingerPositions: [0, 0, 2, 2, 0, 0],
      frets: [0, 0, 2, 2, 0, 0],
    ),
    Chord(
      name: 'Asus4',
      description: 'A suspended 4th - anticipatory feeling',
      fingerPositions: [0, 3, 2, 2, 0, 0],
      frets: [0, 3, 2, 2, 0, 0],
    ),
    
    // B Chords
    Chord(
      name: 'B',
      description: 'B major chord - bright and resonant',
      fingerPositions: [2, 4, 4, 4, 2, 2],
      frets: [2, 4, 4, 4, 2, 2],
    ),
    Chord(
      name: 'Bm',
      description: 'B minor chord - dark and serious',
      fingerPositions: [2, 3, 4, 4, 2, 2],
      frets: [2, 3, 4, 4, 2, 2],
    ),
    Chord(
      name: 'B7',
      description: 'B dominant 7th - bluesy and tense',
      fingerPositions: [2, 1, 2, 1, 2, 2],
      frets: [2, 1, 2, 1, 2, 2],
      startFret: 1,
    ),
    Chord(
      name: 'Bmaj7',
      description: 'B major 7th - sophisticated and smooth',
      fingerPositions: [2, 4, 3, 4, 2, 2],
      frets: [2, 4, 3, 4, 2, 2],
    ),
    Chord(
      name: 'Bm7',
      description: 'B minor 7th - moody and jazzy',
      fingerPositions: [2, 3, 2, 4, 2, 2],
      frets: [2, 3, 2, 4, 2, 2],
    ),
    
    // C Chords
    Chord(
      name: 'C',
      description: 'C major chord - pure and happy',
      fingerPositions: [0, 1, 0, 2, 3, 0],
      frets: [0, 1, 0, 2, 3, 0],
    ),
    Chord(
      name: 'Cm',
      description: 'C minor chord - sad and dramatic',
      fingerPositions: [3, 4, 5, 5, 3, 3],
      frets: [3, 4, 5, 5, 3, 3],
    ),
    Chord(
      name: 'C7',
      description: 'C dominant 7th - bluesy and tense',
      fingerPositions: [0, 1, 3, 2, 3, 0],
      frets: [0, 1, 3, 2, 3, 0],
    ),
    Chord(
      name: 'Cmaj7',
      description: 'C major 7th - smooth and jazzy',
      fingerPositions: [0, 0, 0, 2, 3, 0],
      frets: [0, 0, 0, 2, 3, 0],
    ),
    Chord(
      name: 'Cm7',
      description: 'C minor 7th - moody and complex',
      fingerPositions: [3, 4, 3, 5, 3, 3],
      frets: [3, 4, 3, 5, 3, 3],
    ),
    
    // D Chords
    Chord(
      name: 'D',
      description: 'D major chord - bright and uplifting',
      fingerPositions: [0, 0, 0, 2, 3, 2],
      frets: [0, 0, 0, 2, 3, 2],
    ),
    Chord(
      name: 'Dm',
      description: 'D minor chord - serious and melancholic',
      fingerPositions: [0, 0, 0, 2, 3, 1],
      frets: [0, 0, 0, 2, 3, 1],
    ),
    Chord(
      name: 'D7',
      description: 'D dominant 7th - bluesy with tension',
      fingerPositions: [0, 0, 0, 2, 1, 2],
      frets: [0, 0, 0, 2, 1, 2],
    ),
    Chord(
      name: 'Dmaj7',
      description: 'D major 7th - smooth and sophisticated',
      fingerPositions: [0, 0, 0, 2, 2, 2],
      frets: [0, 0, 0, 2, 2, 2],
    ),
    Chord(
      name: 'Dm7',
      description: 'D minor 7th - moody and jazzy',
      fingerPositions: [0, 0, 0, 2, 1, 1],
      frets: [0, 0, 0, 2, 1, 1],
    ),
    Chord(
      name: 'Dsus2',
      description: 'D suspended 2nd - open and unresolved',
      fingerPositions: [0, 0, 0, 0, 3, 2],
      frets: [0, 0, 0, 0, 3, 2],
    ),
    Chord(
      name: 'Dsus4',
      description: 'D suspended 4th - anticipatory feeling',
      fingerPositions: [0, 0, 0, 2, 3, 3],
      frets: [0, 0, 0, 2, 3, 3],
    ),
    
    // E Chords
    Chord(
      name: 'E',
      description: 'E major chord - strong and resonant',
      fingerPositions: [0, 0, 1, 2, 2, 0],
      frets: [0, 0, 1, 2, 2, 0],
    ),
    Chord(
      name: 'Em',
      description: 'E minor chord - dark and mysterious',
      fingerPositions: [0, 0, 0, 2, 2, 0],
      frets: [0, 0, 0, 2, 2, 0],
    ),
    Chord(
      name: 'E7',
      description: 'E dominant 7th - bluesy with tension',
      fingerPositions: [0, 0, 1, 0, 2, 0],
      frets: [0, 0, 1, 0, 2, 0],
    ),
    Chord(
      name: 'Emaj7',
      description: 'E major 7th - smooth and sophisticated',
      fingerPositions: [0, 0, 1, 1, 2, 0],
      frets: [0, 0, 1, 1, 2, 0],
    ),
    Chord(
      name: 'Em7',
      description: 'E minor 7th - moody and jazzy',
      fingerPositions: [0, 0, 0, 0, 2, 0],
      frets: [0, 0, 0, 0, 2, 0],
    ),
    
    // F Chords
    Chord(
      name: 'F',
      description: 'F major chord - bright but challenging',
      fingerPositions: [1, 1, 2, 3, 3, 1],
      frets: [1, 1, 2, 3, 3, 1],
    ),
    Chord(
      name: 'Fm',
      description: 'F minor chord - dark and brooding',
      fingerPositions: [1, 1, 1, 3, 3, 1],
      frets: [1, 1, 1, 3, 3, 1],
    ),
    Chord(
      name: 'F7',
      description: 'F dominant 7th - bluesy with tension',
      fingerPositions: [1, 1, 2, 1, 3, 1],
      frets: [1, 1, 2, 1, 3, 1],
    ),
    Chord(
      name: 'Fmaj7',
      description: 'F major 7th - smooth and sophisticated',
      fingerPositions: [0, 0, 2, 2, 1, 0],
      frets: [0, 0, 2, 2, 1, 0],
      startFret: 1,
    ),
    Chord(
      name: 'Fm7',
      description: 'F minor 7th - moody and jazzy',
      fingerPositions: [1, 1, 1, 1, 3, 1],
      frets: [1, 1, 1, 1, 3, 1],
    ),
    
    // G Chords
    Chord(
      name: 'G',
      description: 'G major chord - strong and cheerful',
      fingerPositions: [3, 0, 0, 0, 2, 3],
      frets: [3, 0, 0, 0, 2, 3],
    ),
    Chord(
      name: 'Gm',
      description: 'G minor chord - serious and dramatic',
      fingerPositions: [3, 3, 3, 5, 5, 3],
      frets: [3, 3, 3, 5, 5, 3],
    ),
    Chord(
      name: 'G7',
      description: 'G dominant 7th - bluesy with tension',
      fingerPositions: [3, 0, 0, 0, 2, 1],
      frets: [3, 0, 0, 0, 2, 1],
    ),
    Chord(
      name: 'Gmaj7',
      description: 'G major 7th - smooth and sophisticated',
      fingerPositions: [3, 0, 0, 0, 2, 2],
      frets: [3, 0, 0, 0, 2, 2],
    ),
    Chord(
      name: 'Gm7',
      description: 'G minor 7th - moody and jazzy',
      fingerPositions: [3, 3, 3, 3, 5, 3],
      frets: [3, 3, 3, 3, 5, 3],
    ),
  ];
  List<Chord> filteredChords = [];
  bool isSearching = false;
  
  // API services
  final UltimateGuitarService _ugService = UltimateGuitarService();
  final YousicianService _yousicianService = YousicianService();
  
  // State for API data
  List<Map<String, dynamic>> _tabSearchResults = [];
  List<Map<String, dynamic>> _lessons = [];
  List<Map<String, dynamic>> _exercises = [];
  bool _isLoadingTabs = false;
  bool _isLoadingLessons = false;
  bool _isLoadingExercises = false;
  String _tabSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _tabController = TabController(length: 3, vsync: this);
    
    // Load initial data
    _loadInitialData();
  }
  
  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingLessons = true;
      _isLoadingExercises = true;
    });
    
    try {
      final lessons = await _yousicianService.getLessons();
      final exercises = await _yousicianService.getExercises();
      
      setState(() {
        _lessons = lessons;
        _exercises = exercises;
      });
    } catch (e) {
      // Handle errors
      print('Error loading initial data: $e');
    } finally {
      setState(() {
        _isLoadingLessons = false;
        _isLoadingExercises = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchText = _searchController.text.toLowerCase();
    setState(() {
      isSearching = searchText.isNotEmpty;
      if (searchText.isEmpty) {
        filteredChords = [];
      } else {
        filteredChords = allChords
            .where((chord) => chord.name.toLowerCase().contains(searchText))
            .toList();
      }
    });
  }
  
  Future<void> _searchUltimateTabs(String query) async {
    if (query.isEmpty) return;
    
    setState(() {
      _isLoadingTabs = true;
      _tabSearchQuery = query;
    });
    
    try {
      final results = await _ugService.searchTabs(query);
      setState(() {
        _tabSearchResults = results;
      });
    } catch (e) {
      // Handle errors
      print('Error searching tabs: $e');
    } finally {
      setState(() {
        _isLoadingTabs = false;
      });
    }
  }

  void _onChordSelected(Chord chord) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${chord.name} Chord'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chord.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Chord Shape:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Center(
                child: ChordDiagram(chord: chord),
              ),
              const SizedBox(height: 20),
              const Text(
                'How to play:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(_getPlayingInstructions(chord)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.music_note),
                    label: const Text('Play Sound'),
                    onPressed: () {
                      // This would play the chord sound in a real app
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Playing ${chord.name} chord')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.school),
                    label: const Text('Learn in Yousician'),
                    onPressed: () {
                      Navigator.pop(context);
                      _tabController.animateTo(2); // Switch to Lessons tab
                      // This would open the specific lesson in a real app
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
    _searchController.clear();
  }

  String _getPlayingInstructions(Chord chord) {
    List<String> instructions = [];
    
    for (int i = 0; i < 6; i++) {
      String stringName = '';
      switch (i) {
        case 0: stringName = 'Low E (6th string)'; break;
        case 1: stringName = 'A (5th string)'; break;
        case 2: stringName = 'D (4th string)'; break;
        case 3: stringName = 'G (3rd string)'; break;
        case 4: stringName = 'B (2nd string)'; break;
        case 5: stringName = 'High E (1st string)'; break;
      }
      
      if (chord.frets[i] == 0) {
        instructions.add('$stringName: Play open');
      } else if (chord.frets[i] == -1) {
        instructions.add('$stringName: Don\'t play');
      } else {
        instructions.add('$stringName: Fret ${chord.frets[i]}');
      }
    }
    
    return instructions.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3B8D), Color(0xFF9C27B0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chordify',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Home', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Chords Library', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Tuner', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Lessons', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Tab Bar
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Home'),
                  Tab(text: 'Ultimate Guitar'),
                  Tab(text: 'Yousician'),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.amber,
              ),
              
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Home Tab
                    _buildHomeTab(),
                    
                    // Ultimate Guitar Tab
                    _buildUltimateGuitarTab(),
                    
                    // Yousician Tab
                    _buildYousicianTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Title
            const Text(
              'Master Guitar Chords with Ease!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Learn, explore, and generate chords effortlessly.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Start Learning'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Explore Chords'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Search Bar
            Container(
              width: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a chord...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: isSearching
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            
            // Search Results
            if (isSearching && filteredChords.isNotEmpty)
              Container(
                width: 500,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredChords.length > 5 ? 5 : filteredChords.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredChords[index].name),
                      subtitle: Text(
                        filteredChords[index].description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.music_note),
                      onTap: () => _onChordSelected(filteredChords[index]),
                    );
                  },
                ),
              ),
            
            const SizedBox(height: 30),
            
            // Feature Cards - Updated to match original layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // First row - 3 cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          'Chord Finder',
                          'Instantly find any chord you need.',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFeatureCard(
                          'Lessons & Tutorials',
                          'Step-by-step guidance to master chords.',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFeatureCard(
                          'Tuner & Metronome',
                          'Keep your guitar perfectly in tune.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Second row - 1 centered card
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: _buildFeatureCard(
                      'Setlists',
                      'Organize and save songs for easy access.',
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Footer
            const Text(
              '© 2025 Chordify. All rights reserved.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUltimateGuitarTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Title
          const Text(
            'Ultimate Guitar Integration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search for tabs, chords, and songs from Ultimate Guitar\'s vast library.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for songs, artists, or tabs...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
              onSubmitted: (value) {
                _searchUltimateTabs(value);
              },
            ),
          ),
          const SizedBox(height: 20),
          
          // Search Results
          Expanded(
            child: _isLoadingTabs
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _tabSearchResults.isEmpty
                    ? Center(
                        child: _tabSearchQuery.isEmpty
                            ? const Text(
                                'Search for songs to see tabs and chords',
                                style: TextStyle(color: Colors.white70),
                              )
                            : const Text(
                                'No results found',
                                style: TextStyle(color: Colors.white70),
                              ),
                      )
                    : ListView.builder(
                        itemCount: _tabSearchResults.length,
                        itemBuilder: (context, index) {
                          final tab = _tabSearchResults[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(tab['song_name']),
                              subtitle: Text(tab['artist_name']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('★ ${tab['rating']}'),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                              onTap: () {
                                // Show tab details
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('${tab['song_name']} - ${tab['artist_name']}'),
                                    content: const Text('This would display the full tab with chords and lyrics in a real app.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildYousicianTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Title
          const Text(
            'Yousician Integration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Learn guitar with interactive lessons and exercises from Yousician.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          
          // Lessons and Exercises
          Expanded(
            child: _isLoadingLessons || _isLoadingExercises
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lessons Section
                        const Text(
                          'Recommended Lessons',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _lessons.length,
                            itemBuilder: (context, index) {
                              final lesson = _lessons[index];
                              return Container(
                                width: 280,
                                margin: const EdgeInsets.only(right: 16),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 100,
                                        color: Colors.grey.shade300,
                                        child: Center(
                                          child: Icon(
                                            Icons.music_note,
                                            size: 40,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              lesson['title'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Difficulty: ${lesson['difficulty']} • ${lesson['duration']}',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Exercises Section
                        const Text(
                          'Practice Exercises',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _exercises.length,
                          itemBuilder: (context, index) {
                            final exercise = _exercises[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Text(
                                    exercise['difficulty'].substring(0, 1),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(exercise['title']),
                                subtitle: Text(exercise['description']),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    // Start exercise
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Starting exercise: ${exercise['title']}')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('Start'),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ChordDiagram extends StatelessWidget {
  final Chord chord;
  
  const ChordDiagram({
    Key? key,
    required this.chord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 250),
      painter: ChordDiagramPainter(chord: chord),
    );
  }
}

class ChordDiagramPainter extends CustomPainter {
  final Chord chord;
  
  ChordDiagramPainter({required this.chord});
  
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    
    // Calculate dimensions
    final double fretboardWidth = width * 0.8;
    final double stringSpacing = fretboardWidth / 5;
    final double fretSpacing = height * 0.7 / 5;
    final double leftMargin = (width - fretboardWidth) / 2;
    final double topMargin = height * 0.15;
    
    // Paint objects
    final Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final Paint thinLinePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    final Paint fingerPaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.fill;
    
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    // Draw fretboard
    // Strings (vertical lines)
    for (int i = 0; i < 6; i++) {
      final double x = leftMargin + i * stringSpacing;
      canvas.drawLine(
        Offset(x, topMargin),
        Offset(x, topMargin + fretSpacing * 5),
        i == 0 || i == 5 ? linePaint : thinLinePaint,
      );
    }
    
    // Frets (horizontal lines)
    for (int i = 0; i <= 5; i++) {
      final double y = topMargin + i * fretSpacing;
      canvas.drawLine(
        Offset(leftMargin, y),
        Offset(leftMargin + fretboardWidth, y),
        i == 0 ? linePaint : thinLinePaint,
      );
    }
    
    // Draw finger positions
    for (int string = 0; string < 6; string++) {
      final int fret = chord.frets[string];
      
      if (fret > 0) {
        // Draw finger position
        final double x = leftMargin + (5 - string) * stringSpacing;
        final double y = topMargin + (fret - 0.5) * fretSpacing;
        
        canvas.drawCircle(Offset(x, y), stringSpacing * 0.4, fingerPaint);
        
        // Draw finger number
        textPainter.text = TextSpan(
          text: chord.fingerPositions[string].toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );
        
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            x - textPainter.width / 2,
            y - textPainter.height / 2,
          ),
        );
      } else if (fret == 0) {
        // Draw open string symbol
        final double x = leftMargin + (5 - string) * stringSpacing;
        final double y = topMargin - fretSpacing * 0.3;
        
        canvas.drawCircle(Offset(x, y), stringSpacing * 0.2, thinLinePaint);
      } else if (fret == -1) {
        // Draw X for muted string
        final double x = leftMargin + (5 - string) * stringSpacing;
        final double y = topMargin - fretSpacing * 0.3;
        final double size = stringSpacing * 0.2;
        
        canvas.drawLine(
          Offset(x - size, y - size),
          Offset(x + size, y + size),
          linePaint,
        );
        
        canvas.drawLine(
          Offset(x - size, y + size),
          Offset(x + size, y - size),
          linePaint,
        );
      }
    }
    
    // Draw chord name
    textPainter.text = TextSpan(
      text: chord.name,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        width / 2 - textPainter.width / 2,
        height - textPainter.height - 10,
      ),
    );
    
    // Draw fret numbers if starting fret > 0
    if (chord.startFret > 0) {
      textPainter.text = TextSpan(
        text: chord.startFret.toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          leftMargin - textPainter.width - 5,
          topMargin + fretSpacing * 0.5 - textPainter.height / 2,
        ),
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}