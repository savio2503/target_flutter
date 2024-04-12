import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:target/app/core/image_callback.dart';
import 'package:target/app/tools/remove_background.dart';

void printd(String? msg) {
  if (kDebugMode) {
    print(msg ?? '');
  }
}

double currencyToDouble(String currency, {String symbol = 'R\$'}) {
  String clear =
      currency.replaceAll(symbol, '').replaceAll('.', '').replaceAll(',', '.');

  return double.parse(clear);
}

Future<String> returnImageWithoutBackground(String source) async {
  Uint8List? convertido;

  try {
    convertido = await RemoveBackground.remove(source);
  } catch (e) {
    printd("$e");
  }

  if (convertido == null) {
    return source;
  }

  final baseEncoder = base64.encoder;
  String image64 = baseEncoder.convert(convertido);

  return image64;
}

Widget returnImageFromString(
    String? source, double width, Widget empty, ImageCallback? callback) {
  Widget? image;

  if (source != null && source.contains("http")) {
    image = FutureBuilder<Uint8List>(
      future: RemoveBackground.resizeFileFromWeb(source),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(),
          );
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
          final baseEncoder = base64.encoder;
          String image64 = baseEncoder.convert(snapshot.data!);

          if (callback != null) {
            callback.onImageReceived(image64);
          }

          return Image.memory(
            base64Decode(image64),
            width: width,
            height: width,
            errorBuilder: (context, exception, stacktrace) {
              return empty;
            },
          );
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
