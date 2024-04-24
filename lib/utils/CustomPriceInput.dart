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
  bool isFree = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                enabled: !isFree,
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
            SizedBox(width: 10.0),
            Checkbox(
              value: isFree,
              onChanged: (value) {
                setState(() {
                  isFree = value!;
                  if (isFree) {
                    widget.controller.clear();
                  }
                });
              },
            ),
            Text('Free'.tr, style: TextStyle(color: widget.labelclr)),
          ],
        ),
      ],
    );
  }
}


