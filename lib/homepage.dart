import 'package:flutter/material.dart';
import 'package:capstone/HorizontalCardlist.dart' as hc;
import 'bnb_custom_painter.dart';
import 'package:capstone/record.dart';
import 'package:capstone/note.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Notes",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const hc.HorizontalCardList(),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Practice",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // 将来の縦スクロールリストを想定して Expanded で囲む
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 20, // サンプルアイテム数
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent[100],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Practice Item ${index + 1}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
