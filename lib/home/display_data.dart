import 'package:flutter/material.dart';

/// Models
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

class Tab {
  final String id;
  final String songName;
  final String artistName;
  final String type;
  final double rating;
  final int votes;
  final String? content;
  final List<String>? chords;

  Tab({
    required this.id,
    required this.songName,
    required this.artistName,
    required this.type,
    required this.rating,
    required this.votes,
    this.content,
    this.chords,
  });

  factory Tab.fromJson(Map<String, dynamic> json) {
    return Tab(
      id: json['id'],
      songName: json['song_name'],
      artistName: json['artist_name'],
      type: json['type'],
      rating: json['rating'].toDouble(),
      votes: json['votes'],
      content: json['content'],
      chords: json['chords'] != null 
          ? List<String>.from(json['chords']) 
          : null,
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final String difficulty;
  final String duration;
  final String description;
  final String thumbnail;

  Lesson({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.duration,
    required this.description,
    required this.thumbnail,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      difficulty: json['difficulty'],
      duration: json['duration'],
      description: json['description'],
      thumbnail: json['thumbnail'],
    );
  }
}

class Exercise {
  final String id;
  final String title;
  final String difficulty;
  final String description;

  Exercise({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.description,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      title: json['title'],
      difficulty: json['difficulty'],
      description: json['description'],
    );
  }
}

/// Display Widgets

// Chord Display Components
class ChordCard extends StatelessWidget {
  final Chord chord;
  final VoidCallback onTap;

  const ChordCard({
    Key? key,
    required this.chord,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chord.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                chord.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: ChordDiagram(chord: chord),
                ),
              ),
            ],
          ),
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

class ChordDetailView extends StatelessWidget {
  final Chord chord;

  const ChordDetailView({
    Key? key,
    required this.chord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${chord.name} Chord',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              chord.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Chord Shape:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              height: 250,
              width: 200,
              child: ChordDiagram(chord: chord),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'How to play:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildPlayingInstructions(chord),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.music_note),
                  label: const Text('Play Sound'),
                  onPressed: () {
                    // This would play the chord sound in a real app
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.school),
                  label: const Text('Learn in Yousician'),
                  onPressed: () {
                    // This would open the specific lesson in a real app
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPlayingInstructions(Chord chord) {
    List<Widget> instructions = [];
    
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
      
      String instruction = '';
      if (chord.frets[i] == 0) {
        instruction = 'Play open';
      } else if (chord.frets[i] == -1) {
        instruction = 'Don\'t play';
      } else {
        instruction = 'Fret ${chord.frets[i]}';
      }
      
      instructions.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Text(
                stringName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                instruction,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructions,
    );
  }
}

// Tab Display Components
class TabCard extends StatelessWidget {
  final Tab tab;
  final VoidCallback onTap;

  const TabCard({
    Key? key,
    required this.tab,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(tab.songName),
        subtitle: Text(tab.artistName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('★ ${tab.rating.toStringAsFixed(1)}'),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class TabDetailView extends StatelessWidget {
  final Tab tab;

  const TabDetailView({
    Key? key,
    required this.tab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tab.songName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tab.artistName,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${tab.rating.toStringAsFixed(1)} (${tab.votes} votes)',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (tab.chords != null && tab.chords!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chords Used:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tab.chords!.map((chord) {
                      return Chip(
                        label: Text(chord),
                        backgroundColor: Colors.blue.shade100,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          if (tab.content != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                tab.content!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.favorite_border),
                  label: const Text('Favorite'),
                  onPressed: () {
                    // Add to favorites
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.playlist_add),
                  label: const Text('Add to Setlist'),
                  onPressed: () {
                    // Add to setlist
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// Lesson Display Components
class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonCard({
    Key? key,
    required this.lesson,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
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
                      lesson.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Difficulty: ${lesson.difficulty} • ${lesson.duration}',
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
      ),
    );
  }
}

class LessonDetailView extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailView({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: Center(
              child: Icon(
                Icons.music_note,
                size: 80,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      label: Text(lesson.difficulty),
                      backgroundColor: _getDifficultyColor(lesson.difficulty),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(lesson.duration),
                      backgroundColor: Colors.blue.shade100,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lesson.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Lesson'),
                  onPressed: () {
                    // Start the lesson
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green.shade100;
      case 'intermediate':
        return Colors.orange.shade100;
      case 'advanced':
        return Colors.red.shade100;
      default:
        return Colors.blue.shade100;
    }
  }
}

// Exercise Display Components
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getDifficultyColor(exercise.difficulty),
          child: Text(
            exercise.difficulty.substring(0, 1),
            style: TextStyle(
              color: _getDifficultyTextColor(exercise.difficulty),
            ),
          ),
        ),
        title: Text(exercise.title),
        subtitle: Text(exercise.description),
        trailing: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text('Start'),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Color _getDifficultyTextColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
      case 'intermediate':
      case 'advanced':
        return Colors.white;
      default:
        return Colors.white;
    }
  }
}

class ExerciseDetailView extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailView({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            color: _getDifficultyColor(exercise.difficulty).withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(exercise.difficulty),
                  backgroundColor: _getDifficultyColor(exercise.difficulty),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  exercise.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1. Position your fingers as shown in the diagram.\n'
                  '2. Strum the chord slowly, making sure each note rings clearly.\n'
                  '3. Practice transitioning to and from this chord smoothly.\n'
                  '4. Gradually increase your speed as you become more comfortable.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Exercise'),
                  onPressed: () {
                    // Start the exercise
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

// Feature Card Component
class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const FeatureCard({
    Key? key,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
      ),
    );
  }
}

// Loading and Error States
class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    Key? key,
    this.message = 'Loading...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateView({
    Key? key,
    required this.message,
    this.icon = Icons.search_off,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
