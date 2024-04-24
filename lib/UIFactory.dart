import 'package:flutter/material.dart';

const double SEPARATION = 15;
const double MARGIN = 15;
const double EDITABLE_BORDER_WIDTH = 2.0;
const double READONLY_BORDER_WIDTH = 2.0;
const Color EDITABLE_BORDER_COLOR = Colors.black;
const Color READONLY_BORDER_COLOR = Colors.grey;
const Color RED_BORDER_COLOR = Colors.red;
const String ON = "On";
const String OFF = "Off";
const String YES = "Yes";
const String NO = "No";

class UIFactory {
  static BoxDecoration roundedRect(bool editable) {
    return roundedRectColored(editable ? EDITABLE_BORDER_COLOR : READONLY_BORDER_COLOR,editable ? EDITABLE_BORDER_WIDTH : READONLY_BORDER_WIDTH);
    // return BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(width: editable ? EDITABLE_BORDER_WIDTH : READONLY_BORDER_WIDTH, color: editable ? EDITABLE_BORDER_COLOR : READONLY_BORDER_COLOR));
  }

  static BoxDecoration roundedRectColored(Color color,double width) {
    return BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(width: width, color: color));
  }

  static Widget createRowDropdown(String label, String value, List<String> itemList, void Function(String) selectHandler) {
    final double colWidth = 150;
    return Padding(padding: EdgeInsets.only(bottom: SEPARATION), child: Container(decoration: roundedRect(true), child: Row(
      children: [
        //label
        Padding(padding: EdgeInsets.only(left: MARGIN), child: Container(width: colWidth, child: Text(label, textAlign: TextAlign.left))),
        //field
        Expanded(
            child: DropdownButton<String>(
                value: value,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? newValue) => selectHandler(newValue!),
                items: itemList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()))
      ],
    )));
  }
}