import 'package:flutter/material.dart';
import 'package:notes_app/database_helper.dart';
import 'package:notes_app/note_model.dart';
import 'package:notes_app/view/add_note.dart';
import 'package:notes_app/view/archive_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  DatabaseHelper helper = DatabaseHelper.instance;
  List<NoteModel> notes = [];
  List<NoteModel> archive = [];
  @override
  void initState() {
    helper.database;
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () async {
                archive = (await Navigator.push<List<NoteModel>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArchiveView(
                      archive: archive,
                    ),
                  ),
                ))!;
                archive.forEach((element) {
                  if (element.isArchived == 0) {
                    update(element);
                  }

                });
                fetch();
              },
              child: const Icon(
                Icons.archive,
                color: Colors.grey,
              )),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Image(
                    image: AssetImage('images/no-task.png'),
                    height: 120,
                    width: 80,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Empty',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  background: Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    alignment: Alignment.centerLeft,
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    padding: const EdgeInsets.only(
                      right: 16,
                    ),
                    alignment: Alignment.centerRight,
                    color: Colors.green,
                    child: const Icon(
                      Icons.archive,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (DismissDirection direction) async {
                    print(direction.index);
                    bool isDismis = false;
                    if (direction.index == 3) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Be careful'),
                            content: const Text('rely want to delete'),
                            actions: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  isDismis = false;
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'CANCEL',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  isDismis = true;
                                  delete(notes[index]);
                                  fetch();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      var item = notes[index];
                      item.isArchived = 1;
                      update(item);
                      fetch();
                      isDismis = true;
                    }
                    return isDismis;
                  },
                  key: UniqueKey(),
                  child: GestureDetector(
                    onTap: () async {
                      NoteModel m = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddNote(
                            model: notes[index],
                          ),
                        ),
                      );
                      update(m);
                      fetch();
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notes[index].title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              notes[index].description ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  notes[index].time ?? '',
                                  style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 12,
                );
              },
            ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          NoteModel? m = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNote(),
            ),
          );
          if (m != null) {
            insert(m);
          }
          fetch();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void insert(NoteModel note) {
    helper.insertToDatabase(note);
    setState(() {});
  }

  void update(NoteModel note) {
    helper.updateDatabase(note);
    setState(() {});
  }

  void delete(NoteModel note) {
    helper.deleteFromDatabase(note);
    setState(() {});
  }

  void fetch() async {
    notes = [];
    archive = [];
    List<Map<String, dynamic>>? list = await helper.getFromDatabase();
    if (list == null) {
      notes = [];
      archive = [];
    } else {
      list.forEach((e) {
        if (e['isArchived'] == 0) {
          notes.add(NoteModel.fromJson(e));
        } else {
          archive.add(NoteModel.fromJson(e));
        }
      });
    }
    setState(() {});
  }
}
