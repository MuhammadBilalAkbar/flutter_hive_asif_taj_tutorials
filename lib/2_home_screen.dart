import 'package:flutter/material.dart';
import 'package:flutter_hive_asif_taj_tutorials/boxes/boxes.dart';
import 'package:flutter_hive_asif_taj_tutorials/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreenTwo extends StatefulWidget {
  final String title;

  const HomeScreenTwo({super.key, required this.title});

  @override
  State<HomeScreenTwo> createState() => _HomeScreenTwoState();
}

class _HomeScreenTwoState extends State<HomeScreenTwo> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            reverse: true,
            itemCount: box.length,
            itemBuilder: (context, index) => Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(data[index].title),
                    Text(data[index].description),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Notes'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final data = NotesModel(
                title: titleController.text,
                description: descriptionController.text,
              );

              final box = Boxes.getData();
              box.add(data);

              data.save();
              debugPrint(box.length.toString());

              titleController.clear();
              descriptionController.clear();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
