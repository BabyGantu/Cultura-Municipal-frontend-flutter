import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  final List<String> imagePaths;
  final String name;
  final Color labelclr;
  final Color textcolor;
  final String iconImagePath;
  final BuildContext context;

  const CustomImagePicker({
    Key? key,
    required this.imagePaths,
    required this.labelclr,
    required this.name,
    required this.textcolor,
    required this.iconImagePath,
    required this.context,
  }) : super(key: key);

  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.name.tr,
          style: TextStyle(
            color: widget.labelclr,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          children: List.generate(
            widget.imagePaths.length + 1,
            (index) {
              if (index == widget.imagePaths.length) {
                return GestureDetector(
                  onTap: () {
                    _selectImage(context);
                  },
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 40.0,
                      color: widget.labelclr,
                    ),
                  ),
                );
              } else {
                return Container(
                  width: 80.0,
                  height: 80.0,
                  margin: const EdgeInsets.only(right: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.file(
                    File(widget.imagePaths[index]),
                    fit: BoxFit.cover,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectImage(BuildContext context) async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      final base64Image = 'data:image/png;base64,${base64Encode(bytes.buffer.asUint8List())}';
      setState(() {
        widget.imagePaths.add(base64Image); // Agrega la imagen en formato base 64
      });
    }
  }
}
