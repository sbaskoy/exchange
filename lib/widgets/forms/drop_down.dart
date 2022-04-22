import 'package:flutter/material.dart';

class CustomDropDownItem {
  String id;
  String value;
  CustomDropDownItem(this.id, this.value);
}

class CustomDropDown extends StatefulWidget {
  final List<CustomDropDownItem> items;
  final Function(CustomDropDownItem) onselected;
  const CustomDropDown({Key? key, required this.items, required this.onselected}) : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  CustomDropDownItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        dropdownColor: Colors.pink,
        iconEnabledColor: Colors.white,
        value: _selectedItem?.value,
        items: widget.items
            .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text(
                  e.value,
                  style: const TextStyle(color: Colors.white),
                )))
            .toList(),
        onChanged: (String? val) {
          CustomDropDownItem selected = widget.items.firstWhere((element) => element.id == val);
          setState(() {
            _selectedItem = selected;
          });
          widget.onselected(selected);
        });
  }
}
