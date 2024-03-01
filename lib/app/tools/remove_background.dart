import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;

class RemoveBackground {

  static final _apiKey = "9cdESde845WdMbpALvcQKjzG";

  static final _baseUrl = Uri.parse("https://api.remove.bg/v1.0/removebg");

  static Future<Uint8List?> _fetchImageBytes(String imageUrl) async {

    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
  }
  static Future<Uint8List>? resizeFileFromWeb(String urlImageWeb) async {

    Uint8List? bytesFromImage = await _fetchImageBytes(urlImageWeb);
    print("resizeFileFromWeb 1");
    if (bytesFromImage == null) {
      throw "erro ao baixar a imagem";
    }
    print("resizeFileFromWeb 2");
    Uint8List? result;

    Img.Image? image = Img.decodeImage(bytesFromImage);
    print("resizeFileFromWeb 3");
    if (image == null) {
      throw 'Não foi possivel criar a imagem';
    }
    print("resizeFileFromWeb 4");

    var width = image.width;
    var height = image.height;
    var aspectRatio = width / height;
    var maxSide = width > height ? width : height;
    const max = 300;

    print("resizeFileFromWeb 5");
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

      var imageResize = Img.copyResize(image, width: newWidth, height: newHeight);

      result = Img.encodePng(imageResize);
      print("resizeFileFromWeb 6");
    } else {
      result = Img.encodePng(image);
      print("resizeFileFromWeb 7");
    }

    print("resizeFileFromWeb 8");
    return result;

  }

  /*  USANDO API WEB
  static Future<Uint8List>? removebg(String urlImageWeb) async {

    var req = http.MultipartRequest("POST", _baseUrl);

    req.headers.addAll({"X-API-Key": _apiKey});

    List<int>? bytesFromImage = await _fetchImageBytes(urlImageWeb);

    if (bytesFromImage == null) {
      throw "erro ao baixar a imagem";
    }

    req.files.add(await http.MultipartFile.fromBytes("image_file", bytesFromImage));

    final res = await req.send();

    if (res.statusCode == 200) {

      http.Response img = await http.Response.fromStream(res);
      return img.bodyBytes;

    } else {
      throw "Failed to fetch data";
    }
  }*/
}