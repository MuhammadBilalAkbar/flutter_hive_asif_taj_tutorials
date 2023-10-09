import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreenOne extends StatefulWidget {
  final String title;

  const HomeScreenOne({super.key, required this.title});

  @override
  State<HomeScreenOne> createState() => _HomeScreenOneState();
}

class _HomeScreenOneState extends State<HomeScreenOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: Hive.openBox('box1'),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(snapshot.data!.get('name').toString()),
                      subtitle: Text(snapshot.data!.get('age').toString()),
                      trailing:  IconButton(
                        onPressed: () {
                          setState(() {
                            // snapshot.data!.put('name', 'Muhammad Bilal Akbar');
                            snapshot.data!.put('age', 25);
                            snapshot.data!.delete('name');
                          });
                        },
                        // icon: const Icon(Icons.edit),
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                    Text(snapshot.data!.get('details').toString()),
                    Text(snapshot.data!.get('details')['pro'].toString()),
                    Text(snapshot.data!.get('details')['edu'].toString()),
                  ],
                );
              },
            ),
            FutureBuilder(
              future: Hive.openBox('box2'),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Text(snapshot.data!.get('youtube').toString()),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box1 = await Hive.openBox('box1');
          var box2 = await Hive.openBox('box2');

          box2.put('youtube', 'CodingWithFlutter');

          box1.put('name', 'Muhammad Bilal');
          box1.put('age', 25);
          box1.put('details', {
            'pro': 'developer',
            'edu': 'BS CS',
          });
          debugPrint(box1.get('name'));
          debugPrint(box1.get('age'));
          debugPrint(box1.get('details'));
          debugPrint(box1.get('details')['pro']);
          debugPrint(box1.get('details')['edu']);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
