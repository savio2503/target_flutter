import 'package:flutter/material.dart';

class DistributeScreen extends StatefulWidget {
  const DistributeScreen({super.key});

  @override
  State<DistributeScreen> createState() => _DistributeScreenState();
}

class _DistributeScreenState extends State<DistributeScreen> {
  List<int> _selectedItems = <int>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select List Items'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            color: (_selectedItems.contains(index))
                ? Colors.blue.withOpacity(0.5)
                : Colors.transparent,
            child: ListTile(
              onTap: () {
                if (_selectedItems.contains(index)) {
                  setState(() {
                    _selectedItems.removeWhere((element) => element == index);
                  });
                }
              },
              onLongPress: () {
                if (!_selectedItems.contains(index)) {
                  setState(() {
                    _selectedItems.add(index);
                  });
                }
              },
              title: Text('$index'),
            ),
          );
        },
      ),
    );
  }
}
