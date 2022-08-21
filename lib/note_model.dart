class NoteModel {
  String? title,description,time;
  int? id;
  int isArchived=0;

  NoteModel({this.id, this.title, this.description, this.time,this.isArchived=0});

  NoteModel.fromJson(Map map){
    id = map['id'];
    title = map['title'];
    description = map['description'];
    time = map['time'];
    isArchived = map['isArchived'];
  }

  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'title':title,
      'description':description,
      'time':time,
      'isArchived':isArchived,
    };
  }
}