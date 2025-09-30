import 'package:flutter/material.dart';
import 'package:capstone/homepage.dart';
import 'package:capstone/record.dart';
import 'bnb_custom_painter.dart';
import 'package:capstone/button.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String noteTitle = '';
  String? selectedImage;

  final List<String> availableImages = [
    'assets/images/math.jpg',
    'assets/images/music.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    final Size size =MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Note Title',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => noteTitle = value),
                  ),
                  const SizedBox(height: 20),
                  const Text("Select an image:"),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableImages.length,
                      itemBuilder: (context, index) {
                        final image = availableImages[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImage = image;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedImage == image
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(image, width: 60, height: 80),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: buttonPrimary,
                    onPressed: () {
                      if (noteTitle.isEmpty || selectedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text('Please enter a title and select an image'),
                          ),
                        );
                        return;
                      }

                      Navigator.pop(context, {
                        'title': noteTitle,
                        'image': selectedImage!,
                      });
                    },
                    child: const Text('Save Note'),
                  ),
                ],
              ),
            ),

        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white10,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(size.width, 80),
              painter: BNBCustomPainter(),
            ),
            Center(
              heightFactor: 0.6,
              child: FloatingActionButton(
                onPressed: ()async{
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotePage()),
                  );
                  if (result != null) {
                    print("New note: $result");
                  }
                },
                backgroundColor: Colors.orange,
                child: Icon(Icons.add),
                elevation: 0.1,
                shape: CircleBorder(),
              ),
            ),
            SizedBox(
              width: size.width,
              height: 80,
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: IconButton(icon: Icon(Icons.home), onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 45),
                    child: IconButton(icon: Icon(Icons.mic), onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RecordPage()),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45),
                    child: IconButton(icon: Icon(Icons.assignment), onPressed: () {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: IconButton(icon: Icon(Icons.person), onPressed: () {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
