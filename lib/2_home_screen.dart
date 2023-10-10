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
  void dispose() {
    Hive.close();
    // Hive.box('name').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          final data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) => Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(data[index].title),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            editNoteDialog(
                              data[index],
                              data[index].title,
                              data[index].description,
                            );
                          },
                          child: const Icon(Icons.edit),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            data[index].delete();
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
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
          createNoteDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> editNoteDialog(
    NotesModel notesModel,
    String title,
    String description,
  ) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Notes'),
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
            onPressed: () async {
              notesModel.title = titleController.text;
              notesModel.description = descriptionController.text;

              await notesModel.save();
              titleController.clear();
              descriptionController.clear();

              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> createNoteDialog() async {
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
              // box.put('myKey',data);

              data.save();
              debugPrint(box.length.toString());

              titleController.clear();
              descriptionController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
