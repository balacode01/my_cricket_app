import 'package:flutter/material.dart';

void main() => runApp(CricketFieldApp());

class CricketFieldApp extends StatelessWidget {
  const CricketFieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: CricketFieldPage(),
    );
  }
}

class CricketFieldPage extends StatefulWidget {
  const CricketFieldPage({super.key});

  @override
  _CricketFieldPageState createState() => _CricketFieldPageState();
}

class _CricketFieldPageState extends State<CricketFieldPage> {
  final List<String> allPositions = fieldingPositionCoordinates.keys.toList();
  List<String> filteredPositions = [];
  final TextEditingController searchController = TextEditingController();
  List<String> selectedPositions = [];
  Offset fabPosition = Offset(150, 600);

  @override
  void initState() {
    super.initState();
    filteredPositions = allPositions;
  }

  void _showPositionSheet(BuildContext context) {
    searchController.clear();
    filteredPositions = allPositions;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void filterSearch(String query) {
              setModalState(() {
                filteredPositions =
                    allPositions
                        .where(
                          (pos) =>
                              pos.toLowerCase().contains(query.toLowerCase()),
                        )
                        .toList();
              });
            }

            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search position...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                        onChanged: filterSearch,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '${selectedPositions.length} selected, ${11 - selectedPositions.length} more',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredPositions.length,
                        itemBuilder: (context, index) {
                          final pos = filteredPositions[index];
                          final isSelected = selectedPositions.contains(pos);
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(pos),
                              trailing:
                                  isSelected
                                      ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                      : Icon(Icons.circle_outlined),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedPositions.remove(pos);
                                  } else {
                                    if (selectedPositions.length < 11) {
                                      selectedPositions.add(pos);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Only 11 fielders are allowed.',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  }
                                });
                                setModalState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Done"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Madras Mavericks",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPositionSheet(context),
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 400,
                    height: 400,
                    child: CricketFieldWidget(
                      size: 300,
                      selectedPositions: selectedPositions,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Selected Positions:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      selectedPositions.asMap().entries.map((entry) {
                        int index = entry.key + 1;
                        String position = entry.value;
                        return Chip(
                          label: Text("$index. $position"),
                          backgroundColor: Colors.purple[50],
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              selectedPositions.remove(position);
                            });
                          },
                        );
                      }).toList(),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
          // Positioned(
          //   left: fabPosition.dx,
          //   top: fabPosition.dy,
          //   child: GestureDetector(
          //     onPanUpdate: (details) {
          //       setState(() {
          //         fabPosition += details.delta;
          //       });
          //     },
          //     child: FloatingActionButton(
          //       onPressed: () => _showPositionSheet(context),
          //       backgroundColor: Colors.pink,
          //       child: Icon(Icons.add),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class CricketFieldWidget extends StatelessWidget {
  final double size;
  final List<String> selectedPositions;

  const CricketFieldWidget({
    super.key,
    required this.size,
    required this.selectedPositions,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CricketFieldPainter(selectedPositions: selectedPositions),
    );
  }
}

class CricketFieldPainter extends CustomPainter {
  final List<String> selectedPositions;

  CricketFieldPainter({required this.selectedPositions});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outerCircle = Paint()..color = Colors.green;
    final Paint innerCircle =
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = Colors.white;
    final Paint pitch = Paint()..color = Colors.grey[500]!;
    final Paint pitchBorder =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    canvas.drawCircle(Offset(centerX, centerY), size.width / 2, outerCircle);
    canvas.drawCircle(Offset(centerX, centerY), size.width / 3, innerCircle);

    final pitchRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: 30,
      height: 100,
    );
    canvas.drawRect(pitchRect, pitch);
    canvas.drawRect(pitchRect, pitchBorder);

    final Paint creasePaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2;

    double creaseLength = 30;
    canvas.drawLine(
      Offset(centerX - creaseLength / 2, centerY - 50),
      Offset(centerX + creaseLength / 2, centerY - 50),
      creasePaint,
    );
    canvas.drawLine(
      Offset(centerX - creaseLength / 2, centerY + 50),
      Offset(centerX + creaseLength / 2, centerY + 50),
      creasePaint,
    );

    int count = 1;
    for (var position in selectedPositions) {
      if (fieldingPositionCoordinates.containsKey(position)) {
        final offset = fieldingPositionCoordinates[position]!;
        final dx = offset.dx * size.width;
        final dy = offset.dy * size.height;

        final Paint dotPaint = Paint()..color = Colors.red;
        canvas.drawCircle(Offset(dx, dy), 4, dotPaint);

        final TextSpan span = TextSpan(
          text: '$count',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        );
        final TextPainter tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(dx + 5, dy - 5));

        count++;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

const Map<String, Offset> fieldingPositionCoordinates = {
  'Wicket Keeper': Offset(0.5, 0.3),
  'Slip': Offset(0.37, 0.35),
  'Gully': Offset(0.33, 0.38),
  'Point': Offset(0.25, 0.45),
  'Cover': Offset(0.22, 0.55),
  'Mid-off': Offset(0.35, 0.65),
  'Mid-on': Offset(0.65, 0.65),
  'Square Leg': Offset(0.7, 0.5),
  'Fine Leg': Offset(0.85, 0.35),
  'Long On': Offset(0.65, 0.85),
  'Long Off': Offset(0.35, 0.85),
  'Third man': Offset(0.15, 0.25),
  'Deep backward': Offset(0.15, 0.4),
  'Deep cover': Offset(0.18, 0.6),
  'Extra cover': Offset(0.3, 0.6),
  'Silly point': Offset(0.4, 0.52),
  'Leg slip': Offset(0.63, 0.38),
  'Short leg': Offset(0.65, 0.52),
  'Backward short leg': Offset(0.7, 0.45),
  'Leg gully': Offset(0.7, 0.4),
  'Silly mid-on': Offset(0.6, 0.6),
  'Silly mid-off': Offset(0.4, 0.6),
  'Deep square leg': Offset(0.85, 0.65),
  'Fly slip': Offset(0.4, 0.3),
  'Deep fine leg': Offset(0.9, 0.25),
  'Deep mid-wicket': Offset(0.8, 0.75),
  'Deep extra cover': Offset(0.2, 0.75),
  'Straight hit': Offset(0.5, 0.95),
  'Deep long on': Offset(0.6, 0.95),
  'Deep long off': Offset(0.4, 0.95),
  'Backward point': Offset(0.2, 0.4),
  'Deep third man': Offset(0.1, 0.15),
  'Short fine leg': Offset(0.75, 0.48),
  'Short third man': Offset(0.25, 0.35),
};
