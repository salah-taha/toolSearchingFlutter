import 'package:flutter/material.dart';
import 'package:tool_searching/models/tool_model.dart';

class AddToolDialog extends StatefulWidget {
  const AddToolDialog({Key? key, this.tool}) : super(key: key);
  final ToolModel? tool;
  @override
  State<AddToolDialog> createState() => _AddToolDialogState();
}

class _AddToolDialogState extends State<AddToolDialog> {
  final _formKey = GlobalKey<FormState>();
  late ToolModel tool;

  @override
  void initState() {
    super.initState();
    if (widget.tool != null) {
      tool = widget.tool!;
    } else {
      tool = ToolModel(id: '', desc: '', imageUrl: '', title: '', url: '');
    }
  }

  InputDecoration textFormDecoration(
      {required Icon icon, required String hint}) {
    return InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        prefixIcon: icon,
        hintText: hint);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Add Tool",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: tool.title,
                    decoration: textFormDecoration(
                        icon: const Icon(Icons.title), hint: 'Enter title..'),
                    validator: (val) =>
                        val?.isEmpty == true ? "Enter title.." : null,
                    onChanged: (val) {
                      tool.title = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: tool.desc,
                    decoration: textFormDecoration(
                        icon: const Icon(Icons.description),
                        hint: 'Enter description..'),
                    validator: (val) =>
                        val?.isEmpty == true ? "Enter description.." : null,
                    onChanged: (val) {
                      tool.desc = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: tool.imageUrl,
                    decoration: textFormDecoration(
                        icon: const Icon(Icons.image),
                        hint: 'Enter image url..'),
                    validator: (val) =>
                        val?.isEmpty == true ? "Enter image url.." : null,
                    onChanged: (val) {
                      tool.imageUrl = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: tool.url,
                    decoration: textFormDecoration(
                        icon: const Icon(Icons.language), hint: 'Enter url..'),
                    validator: (val) =>
                        val?.isEmpty == true ? "Enter url.." : null,
                    onChanged: (val) {
                      tool.url = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _formKey.currentState?.save();
                        Navigator.of(context).pop(tool);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          widget.tool != null ? "Update Tool" : "Add Tool"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
