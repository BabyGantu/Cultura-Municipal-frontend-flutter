import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CustomPriceInput extends StatefulWidget {
  final TextEditingController controller;
  final String name;
  final Color labelclr;
  final Color textcolor;
  final String iconImagePath;
  final BuildContext context;

  const CustomPriceInput({
    Key? key,
    required this.controller,
    required this.name,
    required this.labelclr,
    required this.textcolor,
    required this.iconImagePath,
    required this.context,
  }) : super(key: key);

  @override
  _CustomPriceInputState createState() => _CustomPriceInputState();
}

class _CustomPriceInputState extends State<CustomPriceInput> {
  List<TextEditingController> controllers = [];
  List<bool> isFreeList = [];

  @override
  void initState() {
    super.initState();
    controllers.add(widget.controller);
    isFreeList.add(false);
  }

  void addPriceField() {
    setState(() {
      controllers.add(TextEditingController());
      isFreeList.add(false);
    });
  }

  void removePriceField(int index) {
    setState(() {
      controllers.removeAt(index);
      isFreeList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controllers[index],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      enabled: !isFreeList[index],
                      style: TextStyle(color: widget.textcolor),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: widget.name,
                        labelStyle: TextStyle(color: widget.labelclr),
                        prefixIcon: Image.asset(
                          widget.iconImagePath,
                          scale: 3.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Checkbox(
                    value: isFreeList[index],
                    onChanged: (value) {
                      setState(() {
                        isFreeList[index] = value!;
                        if (isFreeList[index]) {
                          controllers[index].text = '0';
                        } else {
                          controllers[index].clear();
                        }
                      });
                    },
                  ),
                  Text('Free'.tr, style: TextStyle(color: widget.labelclr)),
                  IconButton(
                    icon: Icon(Icons.remove_circle),
                    color: Colors.red,
                    onPressed: () {
                      if (controllers.length > 1) {
                        removePriceField(index);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
        TextButton(
          onPressed: addPriceField,
          child: Text('Add more prices'.tr),
        ),
      ],
    );
  }
}
