import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tool_searching/add_tool.dart';
import 'package:tool_searching/models/tool_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolCard extends StatefulWidget {
  const ToolCard({Key? key, required this.tool, required this.updateTools})
      : super(key: key);
  final ToolModel tool;
  final VoidCallback updateTools;

  @override
  State<ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<ToolCard> {
  bool hoverd = false;

  void _launchURL() async => await canLaunch(widget.tool.url)
      ? await launch(widget.tool.url)
      : showErrorDialog();

  void showErrorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Couldn't Launch Url"),
            content: const Text(
                "This url cannot be opened. it may be not valid url."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        });
  }

  void updateTool() async {
    ToolModel? tool = await showDialog<ToolModel>(
        context: context,
        builder: (context) {
          return AddToolDialog(
            tool: widget.tool,
          );
        });
    if (tool != null) {
      await FirebaseFirestore.instance
          .collection('tools')
          .doc(widget.tool.id)
          .update(tool.toMap());
      widget.updateTools();
    }
  }

  void deleteTool() async {
    bool? delete = await showDialog<bool?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete ${widget.tool.title}"),
            content: const Text("You cannot undo this operation."),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Delete"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        });
    if (delete != null && delete) {
      await FirebaseFirestore.instance
          .collection('tools')
          .doc(widget.tool.id)
          .delete();
      widget.updateTools();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (val) {
        setState(() {
          hoverd = true;
        });
      },
      onExit: (val) {
        setState(() {
          hoverd = false;
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launchURL,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: hoverd ? Colors.black : Colors.white,
            border: Border.all(
              color: Colors.white,
            ),
          ),
          height: 350,
          alignment: const Alignment(0, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: Image.network(
                        widget.tool.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tool.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: hoverd ? Colors.white : Colors.black87,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.tool.desc,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: hoverd ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
                Positioned(
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue[200]!,
                                blurRadius: 6,
                                spreadRadius: 0)
                          ],
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          onPressed: updateTool,
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue[200]!,
                                blurRadius: 6,
                                spreadRadius: 0)
                          ],
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          onPressed: deleteTool,
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  top: 10,
                  right: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
