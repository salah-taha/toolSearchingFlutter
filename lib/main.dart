import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:tool_searching/add_tool.dart';
import 'package:tool_searching/models/tool_model.dart';
import 'package:tool_searching/tool_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder, // A
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToolModel>? tools;
  bool isSearch = false;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    getAllTools();
  }

  void getAllTools() async {
    List<ToolModel> data = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("tools").get();
    for (var element in querySnapshot.docs) {
      ToolModel tool = ToolModel.fromDoc(element);
      data.add(tool);
    }
    setState(() {
      tools = data;
    });
  }

  void searchTools() async {
    List<ToolModel> data = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("tools")
        .where("titleIndex", arrayContains: searchText)
        .get();
    for (var element in querySnapshot.docs) {
      ToolModel tool = ToolModel.fromDoc(element);
      data.add(tool);
    }
    setState(() {
      tools = data;
    });
  }

  void addTool() async {
    ToolModel? tool = await showDialog<ToolModel>(
        context: context,
        builder: (context) {
          return const AddToolDialog();
        });
    if (tool != null) {
      await FirebaseFirestore.instance.collection('tools').add(tool.toMap());
      getAllTools();
    }
  }

  void updateTools() async {
    if (isSearch) {
      searchTools();
    } else {
      getAllTools();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: isSearch
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (val) {
                                if (val.isNotEmpty) {
                                  searchText = val;
                                  searchTools();
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Enter search text..",
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                getAllTools();
                                setState(() {
                                  isSearch = false;
                                });
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ))
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tools',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearch = true;
                                });
                              },
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              )),
                        ],
                      ),
              ),
              color: Colors.black87,
            ),
            Expanded(
              child: tools == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ResponsiveGridList(
                          desiredItemWidth: 250,
                          minSpacing: 20,
                          children: tools!.map((i) {
                            return ToolCard(
                              tool: i,
                              updateTools: updateTools,
                            );
                          }).toList()),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTool,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
