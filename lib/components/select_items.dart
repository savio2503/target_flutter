import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/stores/add_store.dart';

class SelectItems extends StatefulWidget {
  const SelectItems(this.setChange);

  final void Function(TypeDebit) setChange;

  @override
  State<SelectItems> createState() => _SelectItemsState();
}

class _SelectItemsState extends State<SelectItems> {
  final List<String> items = [
    'Real',
    'Dolár',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Center(
            child: Text(
              'Real',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            if (value == "Real") {
              widget.setChange(TypeDebit.REAL);
            } else {
              widget.setChange(TypeDebit.DOLLAR);
            }
            setState(() {
              selectedValue = value as String;
            });
          },
          buttonHeight: 40,
          buttonWidth: 70,
          itemHeight: 40,
        ),
      );
  }
}
