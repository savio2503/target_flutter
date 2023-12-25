import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

printd(String? msg) {
  if (kDebugMode) {
    print(msg ?? '');
  }
}

double currencyToDouble(String currency, {String symbol = 'R\$'}) {
  String clear =
      currency.replaceAll(symbol, '').replaceAll('.', '').replaceAll(',', '.');

  return double.parse(clear);
}

Widget returnImageFromString(String? source, double width, Widget empty) {
  Widget? image;

  if (source != null && source.contains("http")) {
    image = Container(
      //decoration:BoxDecoration(border: Border.all(color: Colors.blue, width: 5)),
      child: Image.network(
        source,
        width: width,
        height: width,
        errorBuilder: (context, exception, stacktrace) {
          return empty;
        },
      ),
    );
  } else if (source != null && source.compareTo(" ") != 0) {
    image = Container(
      //decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 5)),
      child: Image.memory(
        base64Decode(source),
        width: width,
        height: width,
        errorBuilder: (context, exception, stacktrace) {
          return empty;
        },
      ),
    );
  }

  if (image == null) {
    return empty;
  }

  return image;
}
