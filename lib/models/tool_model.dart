import 'package:cloud_firestore/cloud_firestore.dart';

class ToolModel {
  String id;
  String title;
  String desc;
  String imageUrl;
  String url;

  ToolModel(
      {required this.id,
      required this.desc,
      required this.imageUrl,
      required this.title,
      required this.url});

  Map<String, dynamic> toMap() {
    return {
      'titleIndex': generateTitleSearch(title),
      'descIndex': generateDescSearch(desc),
      'title': title,
      'desc': desc,
      'imageUrl': imageUrl,
      'url': url
    };
  }

  factory ToolModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return ToolModel(
      id: doc.id,
      desc: data['desc'],
      imageUrl: data['imageUrl'],
      title: data['title'],
      url: data['url'],
    );
  }

  List<String> generateTitleSearch(String title) {
    List<String> searchList = [];
    String temp = "";
    for (int i = 0; i < title.length; i++) {
      temp = temp + title[i];
      searchList.add(temp.toLowerCase());
    }
    return searchList;
  }

  List<String> generateDescSearch(String desc) {
    return desc.split(' ').map((e) => e.toLowerCase()).toList();
  }
}
