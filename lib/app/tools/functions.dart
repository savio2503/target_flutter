import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:target/app/data/provider/api.dart';
import 'package:target/app/tools/remove_background.dart';

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

Widget returnImageFromString(String? source, double width, Widget empty, {int? targetId}) {
  Widget? image;

  if (source != null && source.contains("http")) {
    image = FutureBuilder<Uint8List> (
      future: RemoveBackground.resizeFileFromWeb(source),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 60, width: 60, child: CircularProgressIndicator(),);
        } else if (snapshot.hasError) {
          return Image.network(
            source,
            width: width,
            height: width,
            errorBuilder: (context, exception, stacktrace) {
              return empty;
            },
          );
        } else {
          if (targetId != null) {
            Api api = Get.find<Api>();
            final baseEncoder = base64.encoder;
            String image64 = baseEncoder.convert(snapshot.data!);
            api.editarImage(targetId, image64);
            return Image.memory(
              base64Decode(image64),
              width: width,
              height: width,
              errorBuilder: (context, exception, stacktrace) {
                return empty;
              },
            );
          }
          return Image.memory(snapshot.data!);
        }
      },
    );
  } else if (source != null && source.compareTo(" ") != 0) {
    image = Image.memory(
      base64Decode(source),
      width: width,
      height: width,
      errorBuilder: (context, exception, stacktrace) {
        return empty;
      },
    );
  }

  if (image == null) {
    return empty;
  }

  return image;
}
