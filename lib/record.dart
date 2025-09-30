import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:capstone/note.dart';
import 'bnb_custom_painter.dart';
import 'package:capstone/homepage.dart';


class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage>
    with SingleTickerProviderStateMixin {
  final AudioRecorder audioRecorder = AudioRecorder();
  late AnimationController _controller;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      await audioRecorder.stop();
      _controller.stop();
      setState(() => isRecording = false);
    } else {
      if (await audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = p.join(
          dir.path,
          "recording_${DateTime.now().millisecondsSinceEpoch}.m4a",
        );

        await audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: filePath,
        );

        _controller.reset();
        _controller.repeat(reverse: true);

        setState(() => isRecording = true);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size size =MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: _toggleRecording,
          child: RepaintBoundary( // ← アニメーション軽量化
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double scale = 1 + (_controller.value * 0.2);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.15),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording ? Colors.grey.shade200 : Colors.grey.shade300,
                  ),
                  child: Icon(
                    Icons.mic,
                    size: 100,
                    color: isRecording ? Colors.red : Colors.white,
                  ),
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
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotePage())
                  );
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
