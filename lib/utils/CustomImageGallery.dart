import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';

class CustomImageGallery extends StatefulWidget {
  final List<String?> imagePaths;
  final Color labelclr;
  final Color textcolor;
  final String iconImagePath;
  final BuildContext context;

  const CustomImageGallery({
    Key? key,
    required this.imagePaths,
    required this.labelclr,
    required this.textcolor,
    required this.iconImagePath,
    required this.context,
  }) : super(key: key);

  @override
  _CustomImageGalleryState createState() => _CustomImageGalleryState();
}

class _CustomImageGalleryState extends State<CustomImageGallery> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image Gallery'.tr,
          style: TextStyle(
            color: widget.labelclr,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          children: List.generate(
            widget.imagePaths.length < 3 ? widget.imagePaths.length + 1 : 3,
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
                  child: widget.imagePaths[index] != null
                      ? Image.memory(
                          base64Decode(widget.imagePaths[index]!.split(',')[1]),
                          fit: BoxFit.cover,
                        )
                      : Container(), // Empty container for null images
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
        if (widget.imagePaths.length < 3) {
          widget.imagePaths.add(base64Image);
        }
      });
    }
    while (widget.imagePaths.length < 3) {
      widget.imagePaths.add(null);
    }
  }
}


