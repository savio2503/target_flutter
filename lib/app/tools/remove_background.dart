import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;
import 'package:target/app/tools/functions.dart';
import 'package:http_parser/http_parser.dart';

class RemoveBackground {
  //adress server
  static final _baseUrl = Uri.parse("http://192.168.3.20:5000/upload");

  static Future<Uint8List?> _fetchImageBytes(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
  }

  static Future<Uint8List>? remove(String base64) async {
    try {
      Uint8List bytes = base64Decode(base64);

      var response = await http.post(
        _baseUrl,
        body: bytes,
        headers: {'Content-Type': 'image/webp'},
      );

      if (response.statusCode == 200) {
        Uint8List responseBytes = response.bodyBytes;

        Img.Image? image = Img.decodeImage(responseBytes);

        if (image == null) {
          return responseBytes;
        }

        image = _removeTransparentPixels(image);

        responseBytes = Img.encodePng(image);

        return responseBytes;
      } else {
        throw 'Error sending image: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Error when processing: $e';
    }
  }

  static Img.Image _removeTransparentPixels(Img.Image image) {
    int nx = image.width, ny = image.height, right = 0, bottom = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (image.getPixel(x, y).a > 100) {
          if (y < ny) ny = y;
          if (x < nx) nx = x;
          if (x > right) right = x;
          if (y > bottom) bottom = y;
        } 
      }
    }

    Img.Image croppedImage = Img.copyCrop(
      image,
      x: nx,
      y: ny,
      width: right - nx,
      height: bottom - ny,
    );

    return croppedImage;
  }

  static Future<Uint8List>? resizeFileFromWeb(String urlImageWeb) async {
    Uint8List? bytesFromImage = await _fetchImageBytes(urlImageWeb);

    if (bytesFromImage == null) {
      throw "Error downloading image";
    }

    Uint8List? result;

    Img.Image? image = Img.decodeImage(bytesFromImage);

    if (image == null) {
      throw 'Unable to create image';
    }

    var width = image.width;
    var height = image.height;
    var aspectRatio = width / height;
    var maxSide = width > height ? width : height;
    const max = 300;

    if (maxSide > max) {
      var newWidth = 0;
      var newHeight = 0;

      if (width > height) {
        newWidth = max;
        newHeight = (max / aspectRatio).toInt();
      } else {
        newWidth = (max * aspectRatio).toInt();
        newHeight = max;
      }

      var imageResize =
          Img.copyResize(image, width: newWidth, height: newHeight);

      result = Img.encodePng(imageResize);
    } else {
      result = Img.encodePng(image);
    }

    return result;
  }
}
