import 'package:flutter/material.dart';
import 'package:notes_app/note_model.dart';

class AddNote extends StatelessWidget {
  AddNote({Key? key,this.model}) : super(key: key);
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  NoteModel? model;
  int? id;
  @override
  Widget build(BuildContext context) {
    if(model!=null){
      titleController.text=model!.title!;
      descriptionController.text=model!.description!;
      id=model!.id;
    }
    return WillPopScope(
      onWillPop: () {
        return send(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Add note',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          leading: GestureDetector(
              onTap: () {
                send(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.grey,
              )),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    cursorColor: Colors.grey,
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Note title',
                    ),
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: Colors.grey,
                      controller: descriptionController,
                      maxLines: 100,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Note content',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
Future<bool> send(context) async
{
  if (descriptionController.text.isNotEmpty &&
      titleController.text.isNotEmpty) {
    DateTime dateTime = DateTime.now();
    String time =
        '${dateTime.year}-${dateTime.month}-${dateTime.day}  ${dateTime.hour}:${dateTime.minute}';
    model = NoteModel(
      title: titleController.text,
      description: descriptionController.text,
      time: time,
      id: id,
    );
    Navigator.of(context).pop<NoteModel>(model);
    return true;
  }
  else {
    Navigator.of(context).pop();
    return false;
  }

}

}
